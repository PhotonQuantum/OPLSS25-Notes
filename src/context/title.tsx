import { createContext, useContext, createSignal, JSX, createEffect } from "solid-js";

interface TitleContextValue {
  title: () => string;
  setTitle: (title: string) => void;
}

const TitleContext = createContext<TitleContextValue>();

export function TitleProvider(props: { children: JSX.Element }) {
  const [title, setTitle] = createSignal("Conference Notes");

  const value: TitleContextValue = {
    title,
    setTitle,
  };

  return (
    <TitleContext.Provider value={value}>
      {props.children}
    </TitleContext.Provider>
  );
}

export function useTitle() {
  const context = useContext(TitleContext);
  if (!context) {
    throw new Error("useTitle must be used within a TitleProvider");
  }
  return context;
}

// Convenience hook for pages to set their title
export function usePageTitle(title: string) {
  createEffect(() => {
    useTitle().setTitle(title);
  });
} 