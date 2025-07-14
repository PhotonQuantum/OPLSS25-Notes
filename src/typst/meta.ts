/**
 * Converts a string into a valid URL hash fragment
 * @param str - The input string to convert
 * @returns A valid URL hash fragment string
 */
function toUrlHash(str: string): string {
  if (!str || typeof str !== 'string') {
    return 'section';
  }

  return str
    // Convert to lowercase
    .toLowerCase()
    // Replace spaces, underscores, and other separators with hyphens
    .replace(/[\s_.]+/g, '-')
    // Remove or replace special characters, keeping only alphanumeric and hyphens
    .replace(/[^a-z0-9\-]/g, '')
    // Replace multiple consecutive hyphens with a single hyphen
    .replace(/-+/g, '-')
    // Remove leading and trailing hyphens
    .replace(/^-+|-+$/g, '')
    // Fallback for empty results
    || 'section';
}

export interface Location {
  page: number,
  x: number,
  y: number,
}

export interface Position {
  page: number;
  x: string;
  y: string;
}

export interface Heading {
  level: number;
  numbering: string;
  position: Position;
  title: string;
}

export interface Document {
  author: string;
  title: string;
  headings: Heading[];
}

export interface MetaJson {
  [size: string]: Document;
}

export interface Section {
  hash: string;
  level: number;
  title: string;
}

/**
 * Represents a hierarchical tree structure of sections
 */
export interface SectionTree {
  section: Section;
  children: SectionTree[];
}

export type LocationMap = Record<string, Location[]>
export type LocationMapOfSizes = Record<number, LocationMap>

/**
 * Converts a meta.json structure to LocationMapOfSizes
 * @param metaJson - The parsed JSON structure from meta.json files
 * @returns A LocationMapOfSizes object organized by size and heading titles
 */
export function convertMetaToLocationMap(metaJson: MetaJson): LocationMapOfSizes {
  const result: LocationMapOfSizes = {};

  // Iterate through each size key (e.g., "250", "350")
  for (const [sizeKey, doc] of Object.entries(metaJson)) {
    const size = parseInt(sizeKey, 10);

    const locationMap: LocationMap = {};

    // Process each document in the size array
    // Process each heading
    for (const heading of doc.headings) {
      const key = toUrlHash(heading.numbering + "-" + heading.title);
      const position = heading.position;

      // Convert position strings to numbers (remove "pt" suffix)
      const x = parseFloat(position.x.replace('pt', ''))
      const y = parseFloat(position.y.replace('pt', ''))

      const location: Location = {
        page: position.page,
        x: x,
        y: y
      };

      // Add to location map
      if (!locationMap[key]) {
        locationMap[key] = [];
      }
      locationMap[key].push(location);
    }

    result[size] = locationMap;
  }

  return result;
}

/**
 * Lookup the first label that matches the given location in the location map.
 * @param locationMap - The location map to lookup the label in.
 * @param location - The location to lookup the label for.
 * @returns The label for the given location, or undefined if no label is found.
 */
export const lookupLabel = (locationMap: LocationMap, location: Location) => {
  const eps = 1e-2;
  const [label] = Object.entries(locationMap).find(([_, locations]) => {
    return locations.some(l => l.page === location.page && Math.abs(l.x - location.x) < eps && Math.abs(l.y - location.y) < eps)
  }) ?? [undefined]
  return label
}

/**
 * Converts a meta.json structure to a list of sections with hash and level using the first size
 * @param metaJson - The parsed JSON structure from meta.json files
 * @returns Array of Section objects with hash and level for all headings from the first size
 */
export function convertMetaToSections(metaJson: MetaJson): Section[] {
  const sections: Section[] = [];

  // Get the first size key
  const sizeKeys = Object.keys(metaJson);
  if (sizeKeys.length === 0) {
    return sections;
  }

  const doc = metaJson[sizeKeys[0]];

  // Process each heading
  for (const heading of doc.headings) {
    const hash = toUrlHash(heading.numbering + "-" + heading.title);
    sections.push({
      hash: hash,
      level: heading.level,
      title: heading.title
    });
  }

  return sections;
}

/**
 * Builds a hierarchical tree structure from a flat array of sections
 * @param sections - Array of Section objects to build the tree from
 * @returns Array of SectionTree objects representing the hierarchical structure
 * 
 * @example
 * ```typescript
 * const sections = [
 *   { hash: 'intro', level: 1, title: 'Introduction' },
 *   { hash: 'overview', level: 2, title: 'Overview' },
 *   { hash: 'details', level: 2, title: 'Details' },
 *   { hash: 'conclusion', level: 1, title: 'Conclusion' }
 * ];
 * 
 * const tree = buildSectionTree(sections);
 * // Returns a tree where 'Introduction' and 'Conclusion' are root nodes,
 * // and 'Overview' and 'Details' are children of 'Introduction'
 * ```
 */
export function buildSectionTree(sections: Section[]): SectionTree[] {
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

/**
 * Gets the title from a meta.json structure
 * @param metaJson - The parsed JSON structure from meta.json files
 * @param defaultTitle - The default title to return if no title is found
 * @returns The title from the meta.json structure, or the default title if no title is found
 */
export function getTitle(metaJson: MetaJson, defaultTitle: string = "Untitled"): string {
  return Object.values(metaJson).at(0)?.title ?? defaultTitle
}