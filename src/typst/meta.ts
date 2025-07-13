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
 * Gets the title from a meta.json structure
 * @param metaJson - The parsed JSON structure from meta.json files
 * @param defaultTitle - The default title to return if no title is found
 * @returns The title from the meta.json structure, or the default title if no title is found
 */
export function getTitle(metaJson: MetaJson, defaultTitle: string = "Untitled"): string {
  return Object.values(metaJson).at(0)?.title ?? defaultTitle
}