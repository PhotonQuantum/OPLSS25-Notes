import { Accessor, createEffect, createSignal, onCleanup, onMount, useContext } from "solid-js"
import { TypstContext } from "~/context/typst"
import { TypstDomDocument } from "@myriaddreamin/typst.ts/dist/esm/dom.mjs";
import { createEventListenerMap } from "@solid-primitives/event-listener";
import { Many } from "@solid-primitives/utils"
import { injectLocationEventDispatcher, createLocationEventHandler } from "~/typst/location";
import injectTypst from "~/typst/inject";
import "~/typst/typst.css";

export type TypstProps = {
  artifact?: string,
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
      } finally {
        setIsLoading(false)
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
      localRenderer.runWithSession((session) => new Promise(async (resolve) => {
        console.log("renderDom", localContainer)
        const dom = await localRenderer.renderDom({
          renderSession: session,
          container: localContainer,
          pixelPerPt: 4.5,
        })
        setDomHandle(dom);
        disposeSession = () => resolve(null)
      }))
      return true;
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

  createEventListenerMap(maybeToMany(container), {
    resize: () => {
      console.log("resize")
      domHandle()?.addViewportChange()
    },
    scroll: () => {
      console.log("scroll")
      domHandle()?.addViewportChange()
    },
    "typst:location": createLocationEventHandler(container, anchorElem, (left, top) => {
      setRippleLeft(left)
      setRippleTop(top)
      setRippleVisible(true)
    })
  })

  onCleanup(() => {
    setDomHandle(undefined)
    disposeSession()
  })

  const SkeletonPlaceholder = () => (
    <div class="animate-pulse bg-gray-200 rounded-lg h-96 flex items-center justify-center">
      <div class="text-gray-500">Loading document...</div>
    </div>
  )

  const ErrorPlaceholder = () => (
    <div class="bg-red-50 border border-red-200 rounded-lg h-96 flex items-center justify-center">
      <div class="text-red-600">Error loading document: {error()}</div>
    </div>
  )

  return (
    <div class="relative">
      {isLoading() && <SkeletonPlaceholder />}
      {error() && <ErrorPlaceholder />}
      <div
        class="typst-app typst-doc"
        ref={el => setContainer(el)}
      />
      <div class="absolute w-1 h-1" ref={el => setAnchorElem(el)} />
      <div class={`absolute w-0 h-0 border-cyan-400 border-2 rounded-full ${rippleVisible() ? "visible animate-[typst-jump-ripple-effect_1s_linear]" : "hidden"}`}
        style={{ left: `${rippleLeft()}px`, top: `${rippleTop()}px` }}
        onAnimationEnd={() => setRippleVisible(false)}
      />
    </div>
  )
}