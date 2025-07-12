import { MetaJson } from "~/typst/meta";

export const metaJsons: Record<string, MetaJson> = import.meta.glob("~/assets/typst/*.meta.json", { eager: true, import: "default" })
export const typstArtifacts = import.meta.glob<string>("~/assets/typst/*.multi.sir.in", { query: "?url", import: "default" })