import NotFound from "~/components/404";
import { usePageTitle } from "~/context/title";

export default function NotFoundPage() {
  usePageTitle("(˃̣̣̥ᯅ˂̣̣̥)")
  return <NotFound />
}