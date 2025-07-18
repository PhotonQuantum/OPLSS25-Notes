import { Show } from "solid-js";
import SvgMenu from "@tabler/icons/outline/menu-2.svg";
import SvgBrandGithub from "@tabler/icons/outline/brand-github.svg";
import { useTitle } from "~/context/title";

interface HeaderProps {
  onToggleSidebar: () => void;
  isSidebarOpen: boolean;
}

export default function Header(props: HeaderProps) {
  const { title } = useTitle();

  return (
    <header class="bg-white border-b border-gray-200 px-4 py-4 flex items-center justify-between">
      <div class="flex items-center">
        <button
          onClick={props.onToggleSidebar}
          class="flex-shrink-0 w-8 h-8 flex items-center justify-center text-gray-500 hover:text-gray-700 hover:bg-gray-100 rounded-md transition-colors cursor-pointer"
          aria-label="Toggle sidebar"
        >
          <SvgMenu class="w-5 h-5" />
        </button>
      </div>
      
      <div class="flex-1 flex justify-center truncate">
        <h1 class="text-xl font-semibold text-gray-900 truncate">
          {title()}
        </h1>
      </div>
      
      <div class="flex items-center">
        <a
          href="https://github.com/PhotonQuantum/OPLSS25-Notes"
          class="flex-shrink-0 w-8 h-8 flex items-center justify-center text-gray-500 hover:text-gray-700 hover:bg-gray-100 rounded-md transition-colors cursor-pointer"
          aria-label="Visit GitHub"
        >
          <SvgBrandGithub class="w-5 h-5" />
        </a>
      </div>
    </header>
  );
} 