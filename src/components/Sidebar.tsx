import { A } from "@solidjs/router";
import { createSignal, JSX, Show } from "solid-js";
import SvgChevronRight from "@tabler/icons/outline/chevron-right.svg";
import { metaJsons, typstArtifacts } from "~/assets/typst";
import { convertMetaToSections, Section } from "~/typst/meta";

interface SidebarProps {
  isOpen: boolean;
}

interface NavItemProps {
  title: string;
  href?: string;
  children?: JSX.Element;
  defaultExpanded?: boolean;
}

function NavItem(props: NavItemProps) {
  const hasChildren = () => {
    return "children" in props;
  }

  const [isExpanded, setIsExpanded] = createSignal(props.defaultExpanded || false);

  const toggleExpanded = () => {
    setIsExpanded(!isExpanded());
  };

  return (
    <Show when={hasChildren()} fallback={
      <A
        href={props.href!}
        class="block p-2 ml-5 text-sm font-medium text-gray-700 rounded-md hover:bg-gray-100 hover:text-gray-900 transition-colors"
        activeClass="bg-gray-100 text-gray-900"
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
    </Show>
  );
}

interface SectionTree {
  section: Section;
  children: SectionTree[];
}

function buildSectionTree(sections: Section[]): SectionTree[] {
  const tree: SectionTree[] = [];
  const stack: SectionTree[] = [];

  for (const section of sections) {
    const node: SectionTree = { section, children: [] };

    // Remove nodes from stack that are at same or deeper level
    while (stack.length > 0 && stack[stack.length - 1].section.level >= section.level) {
      stack.pop();
    }

    // Add as child to the last node in stack, or as root
    if (stack.length > 0) {
      stack[stack.length - 1].children.push(node);
    } else {
      tree.push(node);
    }

    stack.push(node);
  }

  return tree;
}

function renderSectionTree(tree: SectionTree[], name: string): JSX.Element[] {
  return tree.map((node) => {
    const title = node.section.title;
    const href = `/${name}#${node.section.hash}`;
    
    if (node.children.length > 0) {
      return (
        <NavItem title={title} href={href}>
          {renderSectionTree(node.children, name)}
        </NavItem>
      );
    } else {
      return <NavItem title={title} href={href} />;
    }
  });
}

function ItemForTypst(name: string) {
  const metaJson = metaJsons[`/src/assets/typst/${name}.meta.json`]
  const sections = convertMetaToSections(metaJson)
  const sectionTree = buildSectionTree(sections);
  
  return (
    <NavItem title={name} href={`/${name}`}>
      {renderSectionTree(sectionTree, name)}
    </NavItem>
  )
}

export default function Sidebar(props: SidebarProps) {
  return (
    <aside class={`bg-gray-50 border-r border-gray-200 min-h-screen transition-all duration-300 ${props.isOpen ? "w-64" : "w-0 overflow-hidden"}`}>
      <div class="p-4">
        <nav class="space-y-1">
          <NavItem title="Home" href="/" />

          <NavItem title="About" href="/about" />

          {ItemForTypst("paige")}
          {ItemForTypst("ningning")}

          <NavItem title="Academic Writing" href="/academic-writing">
            <NavItem title="Papers" href="/academic-writing/papers" />
            <NavItem title="Thesis" href="/academic-writing/thesis" />
            <NavItem title="Conferences" href="/academic-writing/conferences">
              <NavItem title="POPL 2024" href="/academic-writing/conferences/popl-2024" />
              <NavItem title="PLDI 2024" href="/academic-writing/conferences/pldi-2024" />
              <NavItem title="ICFP 2024" href="/academic-writing/conferences/icfp-2024" />
            </NavItem>
            <NavItem title="Workshops" href="/academic-writing/workshops" />
          </NavItem>
        </nav>
      </div>
    </aside>
  );
}

export { NavItem }; 