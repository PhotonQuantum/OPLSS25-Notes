import { Title } from "@solidjs/meta";

export default function Home() {
  return (
    <>
      <Title>Index</Title>
      <div class="prose prose-lg max-w-none">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">
          Title
        </h1>
        
        <div class="mb-8">
          <p class="text-lg text-gray-700 leading-relaxed">
            Some text
            <a href="#" class="text-blue-600 hover:text-blue-800">
              some link
            </a>{" "}
            .
          </p>
          
          <p class="text-lg text-gray-700 leading-relaxed mt-4">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          </p>
          
          <p class="text-lg text-gray-700 leading-relaxed mt-4">
            Some links:{" "}
            <a href="#" class="text-blue-600 hover:text-blue-800">ORCiD</a>,{" "}
            <a href="#" class="text-blue-600 hover:text-blue-800">GitHub</a>,{" "}
            <a href="#" class="text-blue-600 hover:text-blue-800">arXiv</a>,{" "}
          </p>
        </div>

        <div class="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
          <p class="text-gray-700 italic">
            This website is under construction, stay tuned!
          </p>
        </div>
      </div>
    </>
  );
}
