import { useParams } from "@solidjs/router";
import Typst from "~/components/Typst";
import { usePageTitle } from "~/context/title";

export default function Article() {
  const params = useParams();
  usePageTitle(params.article);
  return (
    <>
      <Typst artifact={`assets/${params.article}.multi.sir.in`} />
    </>
  );
}