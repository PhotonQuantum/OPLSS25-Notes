import { createTypstRenderer, TypstRenderer } from "@myriaddreamin/typst.ts"
import typstWasm from "@myriaddreamin/typst-ts-renderer/wasm?url"
import { Accessor, createContext, createSignal, JSX, onMount } from "solid-js"

export const TypstContext = createContext<TypstContextType>()

export type TypstContextType = {
    renderer: Accessor<TypstRenderer | undefined>
}

export const TypstProvider = (props: { children: JSX.Element }) => {
    const [renderer, setRenderer] = createSignal<TypstRenderer | undefined>(undefined, {equals: false})
    onMount(async () => {
        const renderer = createTypstRenderer()
        await renderer.init({
            getModule: () => typstWasm,
        })
        setRenderer(renderer)
    })
    return (
        <TypstContext.Provider value={{ renderer }}>
            {props.children}
        </TypstContext.Provider>
    )
}