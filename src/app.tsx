import { MetaProvider, Title } from "@solidjs/meta";
import { Router, useLocation } from "@solidjs/router";
import { FileRoutes } from "@solidjs/start/router";
import { Suspense, createSignal, createMemo, createEffect, onMount, Show } from "solid-js";
import { createMediaQuery } from "@solid-primitives/media";
import "./app.css";
import Sidebar from "~/components/Sidebar";
import Header from "~/components/Header";
import { TypstProvider } from "./context/typst";
import { TitleProvider } from "./context/title";
import { createPresence } from "@solid-primitives/presence";
import { createRouteTree } from "./routes";

export default function App() {
  const isMdScreen = createMediaQuery("(min-width: 768px)");
  const [isSidebarOpen, setIsSidebarOpen] = createSignal(false);
  const routes = createRouteTree();

  const showBackdrop = () => isSidebarOpen() && !isMdScreen();
  const { isVisible: isBackdropVisible, isMounted: isBackdropMounted } = createPresence(showBackdrop, { transitionDuration: 300 });

  // Initialize sidebar state based on screen size
  onMount(() => {
    setIsSidebarOpen(isMdScreen());
  });

  const toggleSidebar = () => {
    setIsSidebarOpen(!isSidebarOpen());
  };

  const AppContent = (props: any) => {
    return (
      <div class="flex bg-white relative">
        {/* Mobile backdrop */}
        <Show when={isBackdropMounted()}>
          <div
            class={`fixed inset-0 bg-black z-40 transition-opacity duration-300 ${isBackdropVisible() ? "opacity-50" : "opacity-0"}`}
            onClick={toggleSidebar}
          />
        </Show>

        {/* Sidebar container - different behavior for mobile vs desktop */}
        <div class={
          isMdScreen()
            ? `transition-all duration-300 ${isSidebarOpen() ? "w-64" : "w-0"} overflow-x-hidden`
            : `fixed left-0 top-0 h-full z-50 transition-transform duration-300 overflow-y-auto ${isSidebarOpen() ? "translate-x-0" : "-translate-x-full"}`
        }>
          <Sidebar routes={routes} />
        </div>

        <div class="flex-1 flex flex-col h-full min-w-0">
          <Header
            onToggleSidebar={toggleSidebar}
            isSidebarOpen={isSidebarOpen()}
          />
          <main class="flex-1 h-full overflow-y-auto relative">
            <div class="max-w-4xl mx-auto h-full relative" id="book-container">
              <Suspense>{props.children}</Suspense>
            </div>
          </main>
        </div>
      </div>
    );
  };

  return (
    <MetaProvider>
      <TitleProvider>
        <TypstProvider>
          <Title>Conference Notes</Title>
          <Router root={AppContent}>
            <FileRoutes />
          </Router>
        </TypstProvider>
      </TitleProvider>
    </MetaProvider>
  );
}
