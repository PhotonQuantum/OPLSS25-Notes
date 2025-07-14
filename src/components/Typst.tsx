import { Accessor, createEffect, createSignal, onCleanup, onMount, untrack, useContext } from "solid-js"
import { TypstContext } from "~/context/typst"
import { TypstDomDocument } from "@myriaddreamin/typst.ts/dist/esm/dom.mjs";
import { createEventListenerMap } from "@solid-primitives/event-listener";
import { Many } from "@solid-primitives/utils"
import { injectLocationEventDispatcher, createLocationEventHandler, NewTypstLocationEvent, findSvgRoot, getPageWidth, TypstLocationEvent, getLocationMap, TypstLocationEventDetail } from "~/typst/location";
import injectTypst from "~/typst/inject";
import "~/typst/typst.css";
import { Location, LocationMapOfSizes, lookupLabel } from "~/typst/meta";
import { unwrap } from "solid-js/store";

export type TypstProps = {
  artifact?: string,
  locationMap?: LocationMapOfSizes,
  scrollMargin?: {
    top?: Accessor<string | undefined>,
    bottom?: Accessor<string | undefined>,
  },
  jumpKey?: Accessor<string | Location | undefined>,
  setupViewportChange?: (callback: () => void) => void,
  onLoaded?: () => void,
  onJumpStart?: (detail: TypstLocationEventDetail<string | undefined>, jumpKeyTriggered: boolean, label?: string) => void,
  onJumpEnd?: (detail: TypstLocationEventDetail<string | undefined>, jumpKeyTriggered: boolean, label?: string) => void,
}


function maybeToMany<T>(accessor: Accessor<T | undefined>): Accessor<Many<T>> {
  return () => {
    const value = accessor()
    if (value === undefined) {
      return []
    }
    return value
  }
}

export default function Typst(props: TypstProps) {
  const renderer = () => useContext(TypstContext)?.renderer()
  const [container, setContainer] = createSignal<HTMLDivElement>()
  const [isLoading, setIsLoading] = createSignal(false)
  const [error, setError] = createSignal<string>()
  const [anchorElem, setAnchorElem] = createSignal<HTMLDivElement>()
  const [artifact, setArtifact] = createSignal<Uint8Array | undefined>(undefined)
  const [domHandle, setDomHandle] = createSignal<TypstDomDocument>()

  const [rippleLeft, setRippleLeft] = createSignal(0)
  const [rippleTop, setRippleTop] = createSignal(0)
  const [rippleVisible, setRippleVisible] = createSignal(false)

  onMount(() => {
    if (typeof window !== "undefined") {
      injectTypst(window)
      injectLocationEventDispatcher(window)
    }
  })

  // Handle jump key from url hash
  createEffect(() => {
    if (isLoading()) return // wait for dom to be ready

    const jumpKey = props.jumpKey?.()
    const localLocationMap = props.locationMap
    const localContainer = container()

    if (jumpKey && localContainer && localLocationMap) {
      if (jumpKey === "0") {
        // Jump to top of the document
        localContainer.dispatchEvent(NewTypstLocationEvent(1, 0, 0, { behavior: "smooth" }, true))
        return
      }
      if (typeof jumpKey === "string") {
        // Jump to a named label
        const location = getLocationMap(localContainer, localLocationMap, 1)?.[jumpKey]?.[0]
        if (location) {
          localContainer.dispatchEvent(NewTypstLocationEvent(location.page, location.x, location.y, { behavior: "smooth" }, true))
        }
      }
      if (typeof jumpKey === "object") {
        // Jump to a specific location
        localContainer.dispatchEvent(NewTypstLocationEvent(jumpKey.page, jumpKey.x, jumpKey.y, { behavior: "smooth" }, true))
      }
    }
  })

  createEffect(async () => {
    if (props.artifact) {
      setIsLoading(true)
      setError(undefined)
      try {
        const buffer = await fetch(props.artifact).then(response => response.arrayBuffer())
        setArtifact(new Uint8Array(buffer))
      } catch (err) {
        console.error("error fetching artifact", err)
        setError(err instanceof Error ? err.message : "Unknown error")
      }
    } else {
      setArtifact(undefined)
    }
  })

  let disposeSession: () => void = () => { }

  createEffect<boolean>((loaded) => {
    const localRenderer = renderer()
    const localContainer = container()
    if (localRenderer && localContainer && !loaded) {
      requestAnimationFrame(() => {
        localRenderer.runWithSession((session) => new Promise(async (resolve) => {
          console.log("renderDom", localContainer)
          const dom = await localRenderer.renderDom({
            renderSession: session,
            container: localContainer,
            pixelPerPt: 4.5,
          })
          setDomHandle(dom);
          props.onLoaded?.()
          disposeSession = () => resolve(null)
        }))
        return true;
      })
    }
    return false;
  }, false);

  createEffect((delta) => {
    const localDomHandle = domHandle()
    const localArtifact = artifact()
    if (localDomHandle && localArtifact) {
      console.log("addChangement", localArtifact)
      requestAnimationFrame(() => {
        // @ts-ignore
        localDomHandle.addChangement(["new", localArtifact])
      })
      return true
    }
    return delta
  }, false)

  createEffect(() => {
    props.setupViewportChange?.(() => {
      requestAnimationFrame(() => { untrack(domHandle)?.addViewportChange() })
    })
  })

  const locationEventHandler = createLocationEventHandler(container, anchorElem, (left, top) => {
    setRippleLeft(left)
    setRippleTop(top)
    setRippleVisible(true)
  })
  createEventListenerMap(maybeToMany(container), {
    resize: () => {
      requestAnimationFrame(() => { domHandle()?.addViewportChange() })
    },
    scroll: () => {
      requestAnimationFrame(() => domHandle()?.addViewportChange())
    },
    "typst:location": (event: TypstLocationEvent<string | undefined>) => {
      // Reverse lookup the label. This is for onJumpStart and onJumpEnd handlers only.
      const label = (() => {
        const localContainer = untrack(container)
        const localLocationMap = unwrap(props.locationMap)
        const { page, x, y } = event.detail
        if (!localContainer || !localLocationMap) return
        const locationMap = getLocationMap(localContainer, localLocationMap, page)
        if (!locationMap) return
        return lookupLabel(locationMap, { page, x, y })
      })()

      props.onJumpStart?.(event.detail, event.detail.state !== undefined, label)
      locationEventHandler(event)
      props.onJumpEnd?.(event.detail, event.detail.state !== undefined, label)
    },
    "typst:svg-done": (event: Event) => {
      event.stopPropagation()
      event.preventDefault()
      setIsLoading(false)
    }
  })

  onCleanup(() => {
    setDomHandle(undefined)
    disposeSession()
  })

  const SkeletonPlaceholder = () => (
    <div class="absolute animate-pulse bg-gray-200 rounded-lg min-h-96 h-full w-full flex items-center justify-center z-10">
      <div class="text-gray-500">Loading document...</div>
    </div>
  )

  const ErrorPlaceholder = () => (
    <div class="absolute bg-red-50 border border-red-200 rounded-lg min-h-96 h-full w-full flex items-center justify-center z-10">
      <div class="text-red-600">Error loading document: {error()}</div>
    </div>
  )

  return (
    <div class="relative">
      {isLoading() && <SkeletonPlaceholder />}
      {error() && <ErrorPlaceholder />}
      <div
        class={`typst-app typst-doc ${isLoading() ? "opacity-0" : "opacity-100"}`}
        ref={el => setContainer(el)}
      />
      <div class="absolute w-1 h-1" ref={el => setAnchorElem(el)} style={{
        "scroll-margin-top": props.scrollMargin?.top?.(),
        "scroll-margin-bottom": props.scrollMargin?.bottom?.(),
      }} />
      <div class={`absolute w-0 h-0 border-cyan-400 border-2 rounded-full ${rippleVisible() ? "visible animate-[typst-jump-ripple-effect_1s_linear]" : "hidden"}`}
        style={{ left: `${rippleLeft()}px`, top: `${rippleTop()}px` }}
        onAnimationEnd={() => setRippleVisible(false)}
      />
    </div>
  )
}