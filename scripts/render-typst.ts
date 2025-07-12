import { NodeCompiler, DynLayoutCompiler } from "@myriaddreamin/typst-ts-node-compiler"
import { defineCommand, runMain } from "citty"
import fs from "fs"
import path from "path"

const breakpoints = (start: number, end: number, count: number) => Array.from({ length: count }, (_, i) => start - (i * ((start - end) / (count - 1))))
const defaultBreakpoints = "750,250,6"

const parseBreakpoints = (s: string) => {
    const [start, end, count] = s.split(",").map(Number)
    return breakpoints(start, end, count)
}

const collectMeta = (entry: string, breakpoints: number[], compiler: NodeCompiler) =>
    Promise.all(breakpoints.map(async (breakpoint) => {
        try {
            console.log(`Querying meta for breakpoint ${breakpoint}pt...`)
            const result = await compiler.query({
                mainFilePath: entry,
                inputs: {
                    "x-target": "web",
                    "x-page-width": `${breakpoint}pt`
                },
                resetRead: false
            }, {
                selector: "<article-meta>",
                field: "value"
            });
            console.log(`Querying meta for breakpoint ${breakpoint}pt... done`)

            return {
                breakpoint,
                meta: result[0]
            };
        } catch (error) {
            console.warn(`Failed to query meta for breakpoint ${breakpoint}:`, error);
            return {
                breakpoint,
                meta: null
            };
        }
    })).then(results => results.reduce((acc, curr) => {
        acc[curr.breakpoint] = curr.meta
        return acc
    }, {} as Record<number, any>))

const main = defineCommand({
    meta: {
        name: "render-typst",
        description: "Render a typst file to vector format",
        version: "0.0.1",
    },
    args: {
        fontPath: {
            type: "string",
            description: "Additional directories to search for fonts",
            default: ""
        },
        root: {
            type: "string",
            description: "The root directory of the typst project",
            default: "."
        },
        inputs: {
            type: "string",
            description: "Additional inputs to the typst project, in the format of key=value",
            default: "",
        },
        breakpoints: {
            type: "string",
            description: "The breakpoints of page width, in the format of \"start,end,count\"",
            default: defaultBreakpoints
        },
        entry: {
            type: "positional",
            description: "The entry file",
            required: true
        },
        output: {
            type: "string",
            alias: "o",
            description: "The output directory",
        }
    },
    async run({ args }) {
        const breakpoints = parseBreakpoints(args.breakpoints)
        const filedir = path.dirname(args.entry)
        const outputdir = args.output || filedir
        const basename = path.basename(args.entry).replace(/\.[^.]+$/, "")
        const baseCompiler = NodeCompiler.create({
            fontArgs: [{ fontPaths: args.fontPath.split(",") }],
            workspace: args.root,
            inputs: args.inputs.split(",").reduce((acc, curr) => {
                const [key, value] = curr.split("=")
                acc[key] = value
                return acc
            }, {} as Record<string, string>),
        });
        const results = await collectMeta(args.entry, breakpoints, baseCompiler)
        const metaOutputPath = path.join(outputdir, `${basename}.meta.json`)
        fs.writeFileSync(metaOutputPath, JSON.stringify(results, null, 2))
        console.log(`Meta written to ${metaOutputPath}`)

        const vectorOutputPath = path.join(outputdir, `${basename}.multi.sir.in`)
        const dynLayoutCompiler = DynLayoutCompiler.fromBoxed(baseCompiler.intoBoxed())
        dynLayoutCompiler.setTarget("web")
        dynLayoutCompiler.setLayoutWidths(breakpoints)
        console.log(`Compiling ${args.entry}... done`)
        const result = dynLayoutCompiler.vector({ mainFilePath: args.entry, resetRead: false })
        fs.writeFileSync(vectorOutputPath, result)
        console.log(`Compiled vector written to ${vectorOutputPath}`)
    }
})

runMain(main)