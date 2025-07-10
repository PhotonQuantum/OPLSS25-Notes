import { useParams } from "@solidjs/router";
import Typst from "~/components/Typst";

export default function Article() {
  const params = useParams();
  return (
    <main>
      <Typst artifact={`assets/${params.article}.multi.sir.in`} />
    </main>
  );
}