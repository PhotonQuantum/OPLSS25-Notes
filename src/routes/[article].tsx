import { createResizeObserver } from "@solid-primitives/resize-observer";
import { useLocation, useParams, useNavigate } from "@solidjs/router";
import { createEffect, createResource, createSignal, onMount } from "solid-js";
import { Dynamic } from "solid-js/web";
import { metaJsons, typstArtifacts } from "~/assets/typst";
import Typst, { TypstProps } from "~/components/Typst";
import { usePageTitle } from "~/context/title";
import { convertMetaToLocationMap, getTitle } from "~/typst/meta";

export default function Article() {
  const navigate = useNavigate();

  const location = useLocation();
  const jumpKey = () => {
    const hash = location.hash.slice(1);
    if (hash.startsWith("loc-")) {
      // It's a specific location, e.g. loc-1x20x100
      const [page, x, y] = hash.slice(4).split("x")
      return { page: parseInt(page), x: parseFloat(x), y: parseFloat(y) }
    }
    return hash
  }

  const params = useParams();
  const article = () => params.article

  const metaJson = () => metaJsons[`/src/assets/typst/${article()}.meta.json`]
  const title = () => getTitle(metaJson(), article())
  usePageTitle(title());

  const [artifactUrl] = createResource(article, async (article) => {
    return await typstArtifacts[`/src/assets/typst/${article}.multi.sir.in`]()
  })
  const locationMap = () => convertMetaToLocationMap(metaJson())

  const [scrollMarginTop, setScrollMarginTop] = createSignal<number>()

  let measureRef!: HTMLDivElement;

  onMount(() => {
    createResizeObserver(measureRef, ({height}) => {
      setScrollMarginTop(height/4)
    })
  })

  // NOTE this is due to a bug in typst.ts. Glyphs are not reloaded when the artifact changes.
  // We are forced to create a new component instance when the artifact changes.
  const TypstComponent = () => {
    if (artifactUrl() === undefined) {
      // Avoid creating typst component when artifact is undefined
      return () => <div />
    } else {
      // eta expand it to avoid component caching
      return (props: TypstProps) => Typst(props)
    }
  }

  return (
    <>
      <div class="absolute w-full h-full -z-50" ref={measureRef} />
      <Dynamic component={TypstComponent()}
        artifact={artifactUrl()}
        scrollMargin={{
          top: () => `${scrollMarginTop()}px`,
        }}
        locationMap={locationMap()}
        jumpKey={jumpKey} 
        onJumpEnd={(detail, jumpKeyTriggered, label) => {
          if (!jumpKeyTriggered) {
            const loc = location.pathname.split("#")[0]
            if (label) {
              navigate(`${loc}#${label}`)
            } else {
              navigate(`${loc}#loc-${detail.page}-${detail.x}-${detail.y}`)
            }
          }
        }}
        />
    </>
  );
}