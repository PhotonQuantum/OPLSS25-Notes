import { createResizeObserver } from "@solid-primitives/resize-observer";
import { useLocation, useParams } from "@solidjs/router";
import { createEffect, createResource, createSignal, onMount } from "solid-js";
import { metaJsons, typstArtifacts } from "~/assets/typst";
import Typst from "~/components/Typst";
import { usePageTitle } from "~/context/title";
import { convertMetaToLocationMap } from "~/typst/meta";

export default function Article() {
  const location = useLocation();
  createEffect(() => {
    console.log("location", location.key)
  })
  const jumpKey = () => location.hash.slice(1);

  const params = useParams();
  const article = () => params.article
  usePageTitle(article());

  const [artifactUrl] = createResource(article, async (article) => {
    return await typstArtifacts[`/src/assets/typst/${article}.multi.sir.in`]()
  })
  const locationMap = () => convertMetaToLocationMap(metaJsons[`/src/assets/typst/${article()}.meta.json`])

  const [scrollMarginTop, setScrollMarginTop] = createSignal<number>()

  let measureRef!: HTMLDivElement;

  onMount(() => {
    createResizeObserver(measureRef, ({height}) => {
      setScrollMarginTop(height/4)
    })
  })

  return (
    <>
      <div class="absolute w-full h-full -z-50" ref={measureRef} />
      <Typst artifact={artifactUrl()} scrollMargin={{
        top: () => `${scrollMarginTop()}px`,
      }} locationMap={locationMap()} jumpKey={jumpKey}/>
    </>
  );
}