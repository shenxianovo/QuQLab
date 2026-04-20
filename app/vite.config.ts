import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'
import { rmSync, readdirSync, readFileSync } from 'fs'
import yaml from 'js-yaml'

// 自定义插件：构建前清理 public/assets 目录中旧的构建产物
function cleanOldAssets() {
  return {
    name: 'clean-old-assets',
    buildStart() {
      const assetsDir = resolve(__dirname, '../public/assets')
      try {
        const files = readdirSync(assetsDir)
        for (const file of files) {
          rmSync(resolve(assetsDir, file))
        }
      } catch {
        // assets 目录不存在则忽略
      }
    },
  }
}

// 虚拟模块：将 site.config.yaml 注入为可 import 的 JSON
const VIRTUAL_CONFIG_ID = 'virtual:site-config'
const RESOLVED_VIRTUAL_CONFIG_ID = '\0' + VIRTUAL_CONFIG_ID

function siteConfigPlugin() {
  return {
    name: 'site-config',
    resolveId(id: string) {
      if (id === VIRTUAL_CONFIG_ID) return RESOLVED_VIRTUAL_CONFIG_ID
    },
    load(id: string) {
      if (id === RESOLVED_VIRTUAL_CONFIG_ID) {
        const configPath = resolve(__dirname, 'site.config.yaml')
        const raw = readFileSync(configPath, 'utf-8')
        const data = yaml.load(raw)
        return `export default ${JSON.stringify(data)}`
      }
    },
    handleHotUpdate({ file, server }: { file: string; server: any }) {
      if (file.endsWith('site.config.yaml')) {
        const mod = server.moduleGraph.getModuleById(RESOLVED_VIRTUAL_CONFIG_ID)
        if (mod) {
          server.moduleGraph.invalidateModule(mod)
          server.ws.send({ type: 'full-reload' })
        }
      }
    },
  }
}

export default defineConfig({
  plugins: [vue(), cleanOldAssets(), siteConfigPlugin()],
  build: {
    outDir: resolve(__dirname, '../public'),
    emptyOutDir: false,
  },
})