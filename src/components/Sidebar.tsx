import { A } from "@solidjs/router";
import { createSignal, For, Show, createEffect } from "solid-js";
import SvgChevronRight from "@tabler/icons/outline/chevron-right.svg";

interface NavigationItem {
  name: string;
  href?: string;
  children?: NavigationItem[];
}

interface NavigationItemProps {
  item: NavigationItem;
  depth?: number;
  onTitleChange?: (title: string) => void;
}

interface SidebarProps {
  isOpen: boolean;
  onTitleChange: (title: string) => void;
}

function NavigationItemComponent(props: NavigationItemProps) {
  const [isExpanded, setIsExpanded] = createSignal(false);
  const depth = props.depth || 0;
  const hasChildren = props.item.children && props.item.children.length > 0;

  const toggleExpanded = () => {
    if (hasChildren) {
      setIsExpanded(!isExpanded());
    }
  };

  const getIndentClass = (depth: number) => {
    switch (depth) {
      case 0: return "";
      case 1: return "ml-4";
      case 2: return "ml-8";
      case 3: return "ml-12";
      case 4: return "ml-16";
      default: return "ml-20";
    }
  };
  
  const indentClass = getIndentClass(depth);
  const paddingClass = depth > 0 ? "pl-3" : "px-3";

  return (
    <div>
      <div class={`flex items-center ${indentClass}`}>
        <Show when={hasChildren}>
          <button
            onClick={toggleExpanded}
            class="flex-shrink-0 w-4 h-4 mr-2 text-gray-400 hover:text-gray-600 transition-colors cursor-pointer"
          >
            <SvgChevronRight
              class={`w-3 h-3 transition-transform ${isExpanded() ? "rotate-90" : ""}`}
            />
          </button>
        </Show>
        <Show when={!hasChildren}>
          <div class="w-4 h-4 mr-2 flex-shrink-0" />
        </Show>
        
        <Show when={props.item.href} fallback={
          <button
            onClick={toggleExpanded}
            class={`flex-1 text-left ${paddingClass} py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors`}
          >
            {props.item.name}
          </button>
        }>
          <A
            href={props.item.href!}
            class={`flex-1 block ${paddingClass} py-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors`}
            activeClass="bg-gray-100 text-gray-900"
            onClick={() => props.onTitleChange?.(props.item.name)}
          >
            {props.item.name}
          </A>
        </Show>
      </div>
      
      <Show when={hasChildren && isExpanded()}>
        <div class="mt-1">
          <For each={props.item.children}>
            {(childItem) => (
              <NavigationItemComponent 
                item={childItem} 
                depth={depth + 1} 
                onTitleChange={props.onTitleChange}
              />
            )}
          </For>
        </div>
      </Show>
    </div>
  );
}

export default function Sidebar(props: SidebarProps) {
  const navigationItems: NavigationItem[] = [
    { name: "About", href: "/about" },
    { name: "Paige", href: "/paige" },
    { name: "Ningning", href: "/ningning" },
    { 
      name: "Academic Writing", 
      href: "/academic-writing",
      children: [
        { name: "Papers", href: "/academic-writing/papers" },
        { name: "Thesis", href: "/academic-writing/thesis" },
        { 
          name: "Conferences", 
          href: "/academic-writing/conferences",
          children: [
            { name: "POPL 2024", href: "/academic-writing/conferences/popl-2024" },
            { name: "PLDI 2024", href: "/academic-writing/conferences/pldi-2024" },
            { name: "ICFP 2024", href: "/academic-writing/conferences/icfp-2024" },
          ]
        },
        { name: "Workshops", href: "/academic-writing/workshops" },
      ]
    },
  ];

  return (
    <aside class={`bg-gray-50 border-r border-gray-200 min-h-screen transition-all duration-300 ${props.isOpen ? "w-64" : "w-0 overflow-hidden"}`}>
      <div class="p-4">
        <nav class="space-y-1">
          <For each={navigationItems}>
            {(item) => (
              <NavigationItemComponent 
                item={item} 
                onTitleChange={props.onTitleChange}
              />
            )}
          </For>
        </nav>
      </div>
    </aside>
  );
} 