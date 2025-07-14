import { A, useLocation, useResolvedPath } from "@solidjs/router";
import { createSignal, JSX, Show, createMemo, Accessor, createEffect, onMount } from "solid-js";
import SvgChevronRight from "@tabler/icons/outline/chevron-right.svg";
import { isServer } from "solid-js/web";

function extractHash(href: string): string {
  const hashIndex = href.indexOf('#');
  if (hashIndex === -1) {
    return '';
  }
  return href.substring(hashIndex + 1);
}

/**
 * Normalizes a hash fragment for comparison
 * Treats '0' and hashes starting with 'loc-' as equivalent to no hash
 * @param hash - The hash fragment (without #)
 * @returns Normalized hash string
 */
function normalizeHash(hash: string): string {
  if (!hash || hash === '0' || hash.startsWith('loc-')) {
    return '';
  }
  return hash;
}

const useActive = (href: Accessor<string>, end: boolean = false) => {
  const to = useResolvedPath(href);
  const location = useLocation();
  const active = createMemo(() => {
    // Location on the server doesn't have a hash, so we can't use it to determine if the link is active.
    if (isServer) return false;
    
    const to_ = to();
    if (to_ === undefined) return false;
    const path = normalizePath(to_.split(/[?#]/, 1)[0]).toLowerCase();
    const loc = decodeURI(normalizePath(location.pathname).toLowerCase());
    
    if (end) {
      // For end nodes, require exact match on both path and hash
      const exactPathMatch = loc === path;
      if (!exactPathMatch) return false;
      
      const toHash = extractHash(to_);
      const currentHash = location.hash.slice(1);
      
      // Use the utility function to normalize hashes
      const normalizedToHash = normalizeHash(toHash);
      const normalizedCurrentHash = normalizeHash(currentHash);
      
      return normalizedToHash === normalizedCurrentHash;
    } else {
      // For ancestor nodes, allow prefix match
      const urlMatch = (path === "" ? false : loc.startsWith(path + "/")) || loc === path;
      if (!to_.includes("#") || to_.endsWith("#0")) {
        return urlMatch;
      }
      const toHash = extractHash(to_);
      const currentHash = location.hash.slice(1);
      return urlMatch && toHash === currentHash;
    }
  });
  return active;
}

interface SidebarProps {
  routes: RouteNode[];
}

interface NavItemProps {
  title: string;
  href?: string;
  children?: JSX.Element;
  isExpanded?: boolean;
  onToggle?: () => void;
  level?: number; // Add level prop for styling
}

interface RouteNode {
  id: string;
  title: string;
  href?: string;
  children?: RouteNode[];
  defaultExpanded?: boolean;
}

function normalizePath(path: string, omitSlash: boolean = false) {
  // Remove leading and trailing slashes
  const trimmed = path.replace(/^\/+|\/+$/g, '');
  // Add back one leading slash if not omitting and path is not empty and doesn't start with ? or #
  return trimmed ? (omitSlash || /^[?#]/.test(trimmed) ? trimmed : "/" + trimmed) : "";
}

function NavItem(props: NavItemProps) {
  const active = useActive(() => props.href!, true); // Use end=true for active styling
  const level = props.level || 0;

  const hasChildren = () => {
    return "children" in props;
  }

  const toggleExpanded = () => {
    props.onToggle?.();
  };

  // More compact styling for nested levels
  const getItemClasses = () => {
    const baseClasses = "text-sm font-medium rounded-md transition-colors";
    const hoverClasses = "hover:text-ctp-mauve-800";
    const activeClasses = active() ? "bg-ctp-mauve-100/50 text-ctp-mauve-800" : "text-gray-700";
    
    if (level === 0) {
      // Top level - normal padding
      return `block p-2 ml-5 ${baseClasses} ${hoverClasses} ${activeClasses}`;
    } else {
      // Nested levels - more compact padding
      return `block py-1 px-2 ml-5 ${baseClasses} ${hoverClasses} ${activeClasses}`;
    }
  };

  const getButtonClasses = () => {
    const baseClasses = "flex-1 text-left text-sm font-medium rounded-md transition-colors";
    const hoverClasses = "hover:text-ctp-mauve-800";
    const textClasses = "text-gray-700";
    
    if (level === 0) {
      // Top level - normal padding
      return `${baseClasses} ${hoverClasses} ${textClasses} p-2`;
    } else {
      // Nested levels - more compact padding
      return `${baseClasses} ${hoverClasses} ${textClasses} py-1 px-2`;
    }
  };

  const getLinkClasses = () => {
    const baseClasses = "flex-1 block text-sm font-medium rounded-md transition-colors";
    const hoverClasses = "hover:text-ctp-mauve-800";
    const activeClasses = active() ? "bg-ctp-mauve-100/50 text-ctp-mauve-800" : "text-gray-700";
    
    if (level === 0) {
      // Top level - normal padding
      return `${baseClasses} ${hoverClasses} ${activeClasses} p-2`;
    } else {
      // Nested levels - more compact padding
      return `${baseClasses} ${hoverClasses} ${activeClasses} py-1 px-2`;
    }
  };

  return (
    <Show when={hasChildren()} fallback={
      <A
        href={props.href!}
        class={getItemClasses()}
      >
        {props.title}
      </A>
    }>
      <div>
        <div class="flex items-center">
          <button
            onClick={toggleExpanded}
            class="flex-shrink-0 w-4 h-4 mr-1 text-gray-400 hover:text-gray-600 transition-colors cursor-pointer"
          >
            <SvgChevronRight
              class={`w-3 h-3 transition-transform ${props.isExpanded ? "rotate-90" : ""}`}
            />
          </button>

          <Show when={props.href} fallback={
            <button
              onClick={toggleExpanded}
              class={getButtonClasses()}
            >
              {props.title}
            </button>
          }>
            <A
              href={props.href!}
              class={getLinkClasses()}
            >
              {props.title}
            </A>
          </Show>
        </div>

        <Show when={props.isExpanded}>
          <div class={`ml-4 ${level === 0 ? 'mt-1 space-y-1' : 'mt-0.5 space-y-0.5'}`}>
            {props.children}
          </div>
        </Show>
      </div>
    </Show>
  );
}

interface NavigationProps {
  routes: RouteNode[];
}

function Navigation(props: NavigationProps) {
  const location = useLocation();
  const [expandedItems, setExpandedItems] = createSignal<Set<string>>(new Set());

  /**
   * Finds the active route node based on the current URL
   * @param nodes - Array of route nodes to search through
   * @param currentPath - Current pathname
   * @param currentHash - Current hash (without #)
   * @returns The active route node or null if not found
   */
  const findActiveRouteNode = (nodes: RouteNode[], currentPath: string, currentHash: string): RouteNode | null => {
    for (const node of nodes) {
      if (node.href) {
        const [path, hash] = node.href.split('#');
        const normalizedPath = normalizePath(path);
        const normalizedCurrentPath = normalizePath(currentPath);
        
        // Check if this node matches the current URL
        if (normalizedPath === normalizedCurrentPath) {
          // If there's a hash, check if it matches
          if (hash && currentHash) {
            if (hash === currentHash) {
              return node;
            }
          } else if (!hash && !currentHash) {
            // Both have no hash - exact match
            return node;
          } else if (!currentHash || currentHash === '0') {
            // No current hash or hash is '0' - consider it a match for the root
            return node;
          }
        }
      }
      
      // Recursively search in children
      if (node.children) {
        const found = findActiveRouteNode(node.children, currentPath, currentHash);
        if (found) return found;
      }
    }
    return null;
  };

  /**
   * Gets all ancestor IDs for a given route node
   * @param nodes - Array of route nodes to search through
   * @param targetId - ID of the target node
   * @param currentPath - Current path of ancestor IDs
   * @returns Array of ancestor IDs (including the target node itself)
   */
  const getAncestorIds = (nodes: RouteNode[], targetId: string, currentPath: string[] = []): string[] | null => {
    for (const node of nodes) {
      const newPath = [...currentPath, node.id];
      
      if (node.id === targetId) {
        return newPath;
      }
      
      if (node.children) {
        const found = getAncestorIds(node.children, targetId, newPath);
        if (found) return found;
      }
    }
    return null;
  };

  /**
   * Updates expanded state based on current URL
   */
  const updateExpandedState = () => {
    const currentPath = location.pathname;
    const currentHash = location.hash.slice(1); // Remove the # prefix
    
    const activeNode = findActiveRouteNode(props.routes, currentPath, currentHash);
    
    if (activeNode) {
      const ancestorIds = getAncestorIds(props.routes, activeNode.id);
      if (ancestorIds) {
        // Add ancestors to expanded items while preserving previously expanded items
        const expandedAncestors: string[] = ancestorIds.slice(0, -1);
        setExpandedItems(prev => {
          const newSet = new Set(prev);
          expandedAncestors.forEach(id => newSet.add(id));
          return newSet;
        });
      }
    }
  };

  // Watch for location changes and update expanded state
  createEffect(() => {
    updateExpandedState();
  });

  const toggleExpanded = (id: string) => {
    setExpandedItems(prev => {
      const newSet = new Set(prev);
      if (newSet.has(id)) {
        newSet.delete(id);
      } else {
        newSet.add(id);
      }
      return newSet;
    });
  };

  const isExpanded = (id: string) => expandedItems().has(id);

  const renderRouteNodes = (nodes: RouteNode[], level: number = 0): JSX.Element[] => {
    return nodes.map((node) => {
      if (node.children && node.children.length > 0) {
        return (
          <NavItem
            title={node.title}
            href={node.href}
            isExpanded={isExpanded(node.id)}
            onToggle={() => toggleExpanded(node.id)}
            level={level}
          >
            {renderRouteNodes(node.children, level + 1)}
          </NavItem>
        );
      } else {
        return <NavItem title={node.title} href={node.href} level={level} />;
      }
    });
  };

  return (
    <nav class="space-y-1">
      {renderRouteNodes(props.routes)}
    </nav>
  );
}

export default function Sidebar(props: SidebarProps) {
  return (
    <aside class={`bg-gray-50 border-r border-gray-200 min-h-screen transition-all duration-300 w-64`}>
      <div class="p-4">
        <Navigation routes={props.routes} />
      </div>
    </aside>
  );
}

export { NavItem, Navigation, type RouteNode }; 