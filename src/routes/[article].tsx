import { createResizeObserver } from "@solid-primitives/resize-observer";
import { useParams } from "@solidjs/router";
import { createSignal, onMount } from "solid-js";
import Typst from "~/components/Typst";
import { usePageTitle } from "~/context/title";

export default function Article() {
  const params = useParams();
  usePageTitle(params.article);

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
      <Typst artifact={`assets/${params.article}.multi.sir.in`} scrollMargin={{
        top: () => `${scrollMarginTop()}px`,
      }} />
    </>
  );
}