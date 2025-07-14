import { A, useLocation, useResolvedPath } from "@solidjs/router";
import { createSignal, JSX, Show, createMemo, Accessor } from "solid-js";
import SvgChevronRight from "@tabler/icons/outline/chevron-right.svg";
import { metaJsons } from "~/assets/typst";
import { convertMetaToSections, getTitle, Section, SectionTree, buildSectionTree } from "~/typst/meta";

const useActive = (href: Accessor<string>) => {
  const to = useResolvedPath(href);
  const location = useLocation();
  const active = createMemo(() => {
    const to_ = to();
    if (to_ === undefined) return false;
    const path = normalizePath(to_.split(/[?#]/, 1)[0]).toLowerCase();
    const loc = decodeURI(normalizePath(location.pathname).toLowerCase());
    const urlMatch = (path === "" ? false : loc.startsWith(path + "/")) || loc === path
    if (!to_.includes("#") || to_.endsWith("#0")) {
      return urlMatch
    }
    const toHash = extractHash(to_)
    const currentHash = location.hash.slice(1)
    return urlMatch && toHash === currentHash
  });
  return active;
}

interface SidebarProps {
  isOpen: boolean;
}

interface NavItemProps {
  title: string;
  href?: string;
  children?: JSX.Element;
  isExpanded?: boolean;
  onToggle?: () => void;
}

interface RouteNode {
  id: string;
  title: string;
  href?: string;
  children?: RouteNode[];
  defaultExpanded?: boolean;
}

const trimPathRegex = /^\/+|(\/)\/+$/g;

function normalizePath(path: string, omitSlash: boolean = false) {
  const s = path.replace(trimPathRegex, "$1");
  return s ? (omitSlash || /^[?#]/.test(s) ? s : "/" + s) : "";
}

function extractHash(href: string): string {
  const hashIndex = href.indexOf('#');
  if (hashIndex === -1) {
    return '';
  }
  return href.substring(hashIndex + 1);
}

function NavItem(props: NavItemProps) {
  const active = useActive(() => props.href!);

  const hasChildren = () => {
    return "children" in props;
  }

  const toggleExpanded = () => {
    props.onToggle?.();
  };

  return (
    <Show when={hasChildren()} fallback={
      <A
        href={props.href!}
        class={`block p-2 ml-5 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors ${active() ? "bg-gray-100 text-gray-900" : ""}`}
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
              class="flex-1 text-left p-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors"
            >
              {props.title}
            </button>
          }>
            <A
              href={props.href!}
              class={`flex-1 block p-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors ${active() ? "bg-gray-100 text-gray-900" : ""}`}
            >
              {props.title}
            </A>
          </Show>
        </div>

        <Show when={props.isExpanded}>
          <div class="ml-4 mt-1 space-y-1">
            {props.children}
          </div>
        </Show>
      </div>
    </Show>
  );
}

function convertSectionTreeToRouteNodes(tree: SectionTree[], name: string): RouteNode[] {
  return tree.map((node) => {
    const id = `${name}-${node.section.hash}`;
    const title = node.section.title;
    const href = `/${name}#${node.section.hash}`;

    return {
      id,
      title,
      href,
      children: node.children.length > 0 ? convertSectionTreeToRouteNodes(node.children, name) : undefined
    };
  });
}

function createTypstRouteNode(name: string): RouteNode {
  const metaJson = metaJsons[`/src/assets/typst/${name}.meta.json`]
  const sections = convertMetaToSections(metaJson)
  const sectionTree = buildSectionTree(sections);
  const title = getTitle(metaJson, name)

  return {
    id: name,
    title,
    href: `/${name}#0`,
    children: convertSectionTreeToRouteNodes(sectionTree, name)
  };
}

// Define the route tree structure
function createRouteTree(): RouteNode[] {
  return [
    {
      id: "home",
      title: "Home",
      href: "/"
    },
    {
      id: "about",
      title: "About",
      href: "/about"
    },
    createTypstRouteNode("paige"),
    createTypstRouteNode("ningning"),
    {
      id: "academic-writing",
      title: "Academic Writing",
      href: "/academic-writing",
      children: [
        {
          id: "papers",
          title: "Papers",
          href: "/academic-writing/papers"
        },
        {
          id: "thesis",
          title: "Thesis",
          href: "/academic-writing/thesis"
        },
        {
          id: "conferences",
          title: "Conferences",
          href: "/academic-writing/conferences",
          children: [
            {
              id: "popl-2024",
              title: "POPL 2024",
              href: "/academic-writing/conferences/popl-2024"
            },
            {
              id: "pldi-2024",
              title: "PLDI 2024",
              href: "/academic-writing/conferences/pldi-2024"
            },
            {
              id: "icfp-2024",
              title: "ICFP 2024",
              href: "/academic-writing/conferences/icfp-2024"
            }
          ]
        },
        {
          id: "workshops",
          title: "Workshops",
          href: "/academic-writing/workshops"
        }
      ]
    }
  ];
}

interface NavigationProps {
  routes: RouteNode[];
}

function Navigation(props: NavigationProps) {
  const [expandedItems, setExpandedItems] = createSignal<Set<string>>(new Set());

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

  const renderRouteNodes = (nodes: RouteNode[]): JSX.Element[] => {
    return nodes.map((node) => {
      if (node.children && node.children.length > 0) {
        return (
          <NavItem
            title={node.title}
            href={node.href}
            isExpanded={isExpanded(node.id)}
            onToggle={() => toggleExpanded(node.id)}
          >
            {renderRouteNodes(node.children)}
          </NavItem>
        );
      } else {
        return <NavItem title={node.title} href={node.href} />;
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
  const routes = createRouteTree();

  return (
    <aside class={`bg-gray-50 border-r border-gray-200 min-h-screen transition-all duration-300 ${props.isOpen ? "w-64" : "w-0 overflow-hidden"}`}>
      <div class="p-4">
        <Navigation routes={routes} />
      </div>
    </aside>
  );
}

export { NavItem, Navigation, type RouteNode }; 