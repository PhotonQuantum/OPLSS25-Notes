import { Accessor, untrack } from "solid-js";

export type TypstLocationOptions = { behavior: ScrollBehavior }
export type TypstLocationEventDetail = { elem: Element, page: number, x: number, y: number, options: TypstLocationOptions }
export type TypstLocationEvent = CustomEvent<TypstLocationEventDetail>

function locationEventDispatcher(elem: Element, page: number, x: number, y: number, options: TypstLocationOptions) {
  console.log("handleTypstLocation - dispatching event", elem, page, x, y, options);

  // Create custom event with location data
  const locationEvent = new CustomEvent('typst:location', {
    detail: { elem, page, x, y, options },
    bubbles: true,  // Allow event to bubble up
    cancelable: true
  });

  // Dispatch on the element - it will bubble up to document containers
  elem.dispatchEvent(locationEvent);

  // If no one handled it, fall back to default behavior
  if (!locationEvent.defaultPrevented) {
    console.warn('No handler found for typst:location event');
  }
}

const findSvgRoot = (docRoot: HTMLElement, page: number) => {
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

    const dataWidth =
      Number.parseFloat(
        svgRoot.getAttribute('data-width') || svgRoot.getAttribute('width') || '0',
      ) || 0;
    const dataHeight =
      Number.parseFloat(
        svgRoot.getAttribute('data-height') || svgRoot.getAttribute('height') || '0',
      ) || 0;
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

  return (event: TypstLocationEvent) => {
    // Stop propagation to prevent other documents from handling this
    event.stopPropagation();
    event.preventDefault();

    const { elem, page, x, y, options } = event.detail;
    console.log("handleTypstLocation - handling event", elem, page, x, y, options);

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