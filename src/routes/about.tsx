import { Title } from "@solidjs/meta";

export default function About() {
  return (
    <>
      <Title>About - Conference Notes</Title>
      <div class="prose prose-lg max-w-none">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">About</h1>
        
        <div class="mb-8">
          <p class="text-lg text-gray-700 leading-relaxed">
            This is a collection of notes and resources from various conferences, workshops, and academic activities.
            The site serves as a digital repository for research materials, presentations, and related documentation.
          </p>
          
          <p class="text-lg text-gray-700 leading-relaxed mt-4">
            You can navigate through different sections using the sidebar to explore various topics including
            academic writing, logic research, and typesetting experiments.
          </p>
        </div>

        <div class="mt-8 p-4 bg-blue-50 border border-blue-200 rounded-lg">
          <p class="text-gray-700">
            <strong>Note:</strong> This site is actively being developed. More content and features will be added over time.
          </p>
        </div>
      </div>
    </>
  );
}
