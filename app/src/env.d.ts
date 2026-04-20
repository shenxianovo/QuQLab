/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<object, object, unknown>
  export default component
}

declare module 'virtual:site-config' {
  interface SiteConfig {
    profile: {
      name: string
      title: string
      birthday: string
      avatar: string
    }
    stats: Array<{
      key: string
      label: string
      code: string
      icon: string
      value: number
    }>
    skills: string[]
    skillProgress: number
    achievements: Array<{
      title: string
      description: string
      icon: string
    }>
    achievementsTotal: number
    evaluation: {
      rank: string
      comment: string
    }
    links: Array<{
      label: string
      href: string
    }>
    siteLabel: string
  }
  const config: SiteConfig
  export default config
}