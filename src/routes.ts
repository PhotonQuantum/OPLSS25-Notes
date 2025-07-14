import { metaJsons } from "~/assets/typst";
import { convertMetaToSections, getTitle, Section, SectionTree, buildSectionTree } from "~/typst/meta";
import type { RouteNode } from "./components/Sidebar";

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
export function createRouteTree(): RouteNode[] {
  return [
    {
      id: "home",
      title: "Home",
      href: "/"
    },
    createTypstRouteNode("anja"),
    createTypstRouteNode("brigitte"),
    createTypstRouteNode("paige"),
    createTypstRouteNode("ningning"),
  ];
}
