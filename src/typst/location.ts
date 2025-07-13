import { Accessor, untrack } from "solid-js";
import { LocationMapOfSizes } from "./meta";

export type TypstLocationOptions = { behavior: ScrollBehavior }
export type TypstLocationEventDetail<T> = { page: number, x: number, y: number, options: TypstLocationOptions, state?: T }
export type TypstLocationEvent<T> = CustomEvent<TypstLocationEventDetail<T>>

export const NewTypstLocationEvent = <T>(page: number, x: number, y: number, options: TypstLocationOptions, state?: T) => {
  return new CustomEvent('typst:location', {
    detail: { page, x, y, options, state },
    bubbles: true,  // Allow event to bubble up
    cancelable: true
  })
}

function locationEventDispatcher<T>(elem: Element, page: number, x: number, y: number, options: TypstLocationOptions, state?: T) {
  console.log("handleTypstLocation - dispatching event", page, x, y, options);

  // Create custom event with location data
  const locationEvent = NewTypstLocationEvent<T>(page, x, y, options, state)

  // Dispatch on the element - it will bubble up to document containers
  elem.dispatchEvent(locationEvent);

  // If no one handled it, fall back to default behavior
  if (!locationEvent.defaultPrevented) {
    console.warn('No handler found for typst:location event');
  }
}

export const findSvgRoot = (docRoot: HTMLElement, page: number) => {
  for (const h of docRoot.children) {
    if (h.classList.contains("typst-dom-page")) {
      const idx = Number.parseInt(h.getAttribute("data-index") || "999");
      if (idx + 1 === page) {
        const svg = h.querySelector(".typst-svg-page");
        if (svg) {
          if (svg.classList.contains('typst-semantic-layer')) {
            return svg.firstElementChild! as SVGGElement;
          }
          return svg as SVGGElement;
        }
        return undefined;
      }
    }
  }
}

export const getPageWidth = (docRoot: HTMLElement, page: number = 1) => {
  const svgRoot = findSvgRoot(docRoot, page);
  if (!svgRoot) {
    return 0;
  }
  return Number.parseFloat(svgRoot.getAttribute('data-width') || svgRoot.getAttribute('width') || '0');
}

export const getPageHeight = (docRoot: HTMLElement, page: number = 1) => {
  const svgRoot = findSvgRoot(docRoot, page);
  if (!svgRoot) {
    return 0;
  }
  return Number.parseFloat(svgRoot.getAttribute('data-height') || svgRoot.getAttribute('height') || '0');
}

export const getLocationMap = (docRoot: HTMLElement, locationMaps: LocationMapOfSizes, page: number = 1) => {
  const pageWidth = getPageWidth(docRoot, page)
  const size = Object.keys(locationMaps).map(Number).toSorted((a, b) => b - a).find(size => size <= pageWidth)
  if (!size) return
  return locationMaps[size]
}

/// Create a location event handler for the given document root and anchor element.
/// Install this on the typst document root element.
/// The reason we need an anchor element is because we want to reuse the same anchor element for all jumps.
/// It's very expensive to delete and recreate the anchor element for each jump due to reflows.
export function createLocationEventHandler(docRoot: Accessor<HTMLElement | undefined>, anchorElem: Accessor<HTMLElement | undefined>, fnRipple: (left: number, top: number) => void) {
  const handler = (page: number, x: number, y: number, options: TypstLocationOptions) => {
    const localDocRoot = untrack(docRoot);
    if (!localDocRoot) {
      console.warn(`No document root found`);
      return;
    }

    const svgRoot = findSvgRoot(localDocRoot, page);
    if (!svgRoot) {
      console.warn(`No SVG root found for page ${page}`);
      return;
    }

    const dataWidth = getPageWidth(localDocRoot, page);
    const dataHeight = getPageHeight(localDocRoot, page);
    const svgRectBase = svgRoot.getBoundingClientRect();
    const svgRect = {
      left: svgRectBase.left,
      top: svgRectBase.top,
      width: svgRectBase.width,
      height: svgRectBase.height,
    };
    const transform = svgRoot.transform?.baseVal?.consolidate()?.matrix;
    if (transform) {
      // console.log(transform.e, transform.f);
      svgRect.left += (transform.e / dataWidth) * svgRect.width;
      svgRect.top += (transform.f / dataHeight) * svgRect.height;
    }

    const behavior = options?.behavior || 'smooth';

    const xOffset = (x / dataWidth) * svgRect.width;
    const yOffset = (y / dataHeight) * svgRect.height;

    let anchor = untrack(anchorElem);
    if (!anchor) {
      console.warn(`No anchor element found`);
      return;
    }
    anchor.style.left = `${xOffset}px`;
    anchor.style.top = `${yOffset}px`;
    anchor.scrollIntoView({ behavior });

    fnRipple(xOffset, yOffset);
    // TODO assign hashloc
  }

  return <T,>(event: TypstLocationEvent<T>) => {
    // Stop propagation to prevent other documents from handling this
    event.stopPropagation();
    event.preventDefault();

    const { page, x, y, options } = event.detail;
    console.log("handleTypstLocation - handling event", page, x, y, options);

    handler(page, x, y, options);
  }
}

/// Inject the location event dispatcher into the window object.
export function injectLocationEventDispatcher(window: Window, force: boolean = false) {
  const w = (window as any);
  if (w.handleTypstLocation === undefined || force) {
    w.handleTypstLocation = locationEventDispatcher;
  }
}