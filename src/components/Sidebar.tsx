import { A } from "@solidjs/router";
import { createSignal, JSX, Show, children } from "solid-js";
import SvgChevronRight from "@tabler/icons/outline/chevron-right.svg";

interface SidebarProps {
  isOpen: boolean;
}

interface NavItemProps {
  href: string;
  children: JSX.Element;
}

interface NavSectionProps {
  title: string;
  href?: string;
  children: JSX.Element;
  defaultExpanded?: boolean;
}

function NavItem(props: NavItemProps) {
  return (
    <A
      href={props.href}
      class="block p-2 ml-5 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors"
      activeClass="bg-gray-100 text-gray-900"
    >
      {props.children}
    </A>
  );
}

function NavSection(props: NavSectionProps) {
  const [isExpanded, setIsExpanded] = createSignal(props.defaultExpanded || false);

  const toggleExpanded = () => {
    setIsExpanded(!isExpanded());
  };

  return (
    <div>
      <div class="flex items-center">
        <button
          onClick={toggleExpanded}
          class="flex-shrink-0 w-4 h-4 mr-1 text-gray-400 hover:text-gray-600 transition-colors cursor-pointer"
        >
          <SvgChevronRight
            class={`w-3 h-3 transition-transform ${isExpanded() ? "rotate-90" : ""}`}
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
            class="flex-1 block p-2 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors"
            activeClass="bg-gray-100 text-gray-900"
          >
            {props.title}
          </A>
        </Show>
      </div>
      
      <Show when={isExpanded()}>
        <div class="ml-4 mt-1 space-y-1">
          {props.children}
        </div>
      </Show>
    </div>
  );
}

export default function Sidebar(props: SidebarProps) {
  return (
    <aside class={`bg-gray-50 border-r border-gray-200 min-h-screen transition-all duration-300 ${props.isOpen ? "w-64" : "w-0 overflow-hidden"}`}>
      <div class="p-4">
        <nav class="space-y-1">
          <NavItem href="/">Home</NavItem>

          <NavItem href="/about">About</NavItem>

          <NavItem href="/paige">Paige</NavItem>

          <NavItem href="/ningning">Ningning</NavItem>
          
          <NavSection title="Academic Writing" href="/academic-writing">
            <NavItem href="/academic-writing/papers">Papers</NavItem>
            <NavItem href="/academic-writing/thesis">Thesis</NavItem>
            <NavSection title="Conferences" href="/academic-writing/conferences">
              <NavItem href="/academic-writing/conferences/popl-2024">POPL 2024</NavItem>
              <NavItem href="/academic-writing/conferences/pldi-2024">PLDI 2024</NavItem>
              <NavItem href="/academic-writing/conferences/icfp-2024">ICFP 2024</NavItem>
            </NavSection>
            <NavItem href="/academic-writing/workshops">Workshops</NavItem>
          </NavSection>
        </nav>
      </div>
    </aside>
  );
}

export { NavItem, NavSection }; 