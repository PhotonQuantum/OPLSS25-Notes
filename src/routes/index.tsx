import { Title } from "@solidjs/meta";
import { usePageTitle } from "~/context/title";

export default function Home() {
  usePageTitle("OPLSS Lecture Notes");

  return (
    <div class="p-8">
      <Title>OPLSS Lecture</Title>
      <div class="prose prose-lg max-w-none">
        <h3>About</h3>
        <p>
          This is a collection of notes I made during <a href="https://opls.org/opls25/">OPLSS25</a>.
          You can navigate through different lectures using the sidebar.
        </p>
        <p>
          Note that I'm still organizing the notes, so most of the lectures may not be complete.{" "}
          <a href="/paige">Introduction to Category Theory</a> is the most complete one, but it's still a work in progress.
        </p>
        <p class="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
          Due to an upstream issue with the typst renderer, this website does not work on Firefox.
          Please use other browsers to view the notes, or check out <a href="https://github.com/PhotonQuantum/OPLSS25-Notes/tree/master/pdfs">PDF versions</a> instead.
        </p>
        <h3>Links</h3>
        <ul>
          <li>
            <a href="https://github.com/PhotonQuantum/OPLSS25-Notes">GitHub repository</a>
          </li>
          <li>
            <a href="https://yanningchen.me">About me</a>
          </li>
        </ul>
      </div>
    </div>
  );
}
