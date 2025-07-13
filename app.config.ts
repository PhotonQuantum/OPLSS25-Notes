import { defineConfig } from "@solidjs/start/config";
import tailwindcss from "@tailwindcss/vite";
import solidSvg from "vite-plugin-solid-svg";


export default defineConfig({
  vite: {
    server: {
      allowedHosts: [".trycloudflare.com"]
    },
    plugins: [tailwindcss(), solidSvg({ svgo: { enabled: false } })],
    logLevel: "info",
  },
});
