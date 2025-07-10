import { MetaProvider, Title } from "@solidjs/meta";
import { Router, useLocation } from "@solidjs/router";
import { FileRoutes } from "@solidjs/start/router";
import { Suspense, createSignal, createMemo, createEffect, onMount } from "solid-js";
import { createMediaQuery } from "@solid-primitives/media";
import "./app.css";
import Sidebar from "~/components/Sidebar";
import Header from "~/components/Header";
import { TypstProvider } from "./context/typst";
import { TitleProvider } from "./context/title";

export default function App() {
  const isLargeScreen = createMediaQuery("(min-width: 1024px)");
  const [isSidebarOpen, setIsSidebarOpen] = createSignal(false);

  // Initialize sidebar state based on screen size
  onMount(() => {
    setIsSidebarOpen(isLargeScreen());
  });

  const toggleSidebar = () => {
    setIsSidebarOpen(!isSidebarOpen());
  };

  const AppContent = (props: any) => {
    return (
      <div class="flex h-screen bg-white">
        <div class={`transition-all duration-300 ${isSidebarOpen() ? "w-64" : "w-0"}`}>
          <Sidebar isOpen={isSidebarOpen()} />
        </div>
        <div class="flex-1 flex flex-col h-full min-w-0">
          <Header
            onToggleSidebar={toggleSidebar}
            isSidebarOpen={isSidebarOpen()}
          />
          <main class="flex-1 h-full overflow-y-auto relative">
            <div class="max-w-4xl mx-auto p-8 h-full relative">
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
