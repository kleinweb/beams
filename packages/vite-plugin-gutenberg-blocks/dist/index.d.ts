import { Plugin } from "vite";

//#region src/index.d.ts
interface PluginConfig {
  watch?: string[];
  outDir?: string;
  dependencies?: string[];
}
declare const createViteBlock: (pluginConfig?: PluginConfig) => Plugin[];
//#endregion
export { PluginConfig, createViteBlock };
//# sourceMappingURL=index.d.ts.map