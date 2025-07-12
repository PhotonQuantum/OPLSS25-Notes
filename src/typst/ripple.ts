import { Accessor, untrack } from "solid-js";

export function triggerRipple(rippleElem: Accessor<HTMLDivElement|undefined>, left: number, top: number) {
    const ripple = untrack(rippleElem);
    if (!ripple) {
        console.warn(`No ripple element found`);
        return;
    }

    ripple.style.left = `${left}px`;
    ripple.style.top = `${top}px`;
    ripple.style.visibility = "visible";
}