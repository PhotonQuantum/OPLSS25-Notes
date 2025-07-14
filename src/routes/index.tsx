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
        <div class="p-4 bg-ctp-yellow-100/50 border border-ctp-yellow-200 rounded-lg">
          Due to an upstream issue with the typst renderer, this website does <strong>not</strong> work on <i>Firefox</i>.
          Please use other browsers to view the notes, or check out <a href="https://github.com/PhotonQuantum/OPLSS25-Notes/tree/master/pdfs">PDF versions</a> instead.
        </div>
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
