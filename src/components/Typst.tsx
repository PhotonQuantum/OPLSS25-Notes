import { Accessor, createEffect, createResource, createSignal, onCleanup, onMount, untrack, useContext } from "solid-js"
import { TypstContext } from "~/context/typst"
import injectedCss from "./typst.css?raw";
// import injectedJs from "@7mile/enhanced-typst-svg/dist/index.min.js?raw"
// import injectedJs from "@7mile/enhanced-typst-svg/dist/index.min.js?url"
import { TypstDomDocument } from "@myriaddreamin/typst.ts/dist/esm/dom.mjs";
import { createEventListenerMap, makeEventListener, makeEventListenerStack } from "@solid-primitives/event-listener";
import { Many } from "@solid-primitives/utils"
import injectedJs from "./typst_inject?url"
export type TypstProps = {
  artifact?: string
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

  const [artifact, setArtifact] = createSignal<Uint8Array | undefined>(undefined)

  const [domHandle, setDomHandle] = createSignal<TypstDomDocument>()

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
    }
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
    <>
      <style>{injectedCss}</style>
      <script type="text/javascript" src={injectedJs}></script>
      <div>
        {isLoading() && <SkeletonPlaceholder />}
        {error() && <ErrorPlaceholder />}
        <div
          class="typst-app typst-doc"
          ref={el => setContainer(el)}
        // style={{ display: isLoading() || error() ? 'none' : 'block' }}
        />
      </div>
    </>
  )
}