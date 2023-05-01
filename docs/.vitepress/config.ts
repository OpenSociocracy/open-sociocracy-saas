import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Open Sociocracy",
  description: "Open Source Sociocracy 3.0 Tools",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Build in Public', link: 'https://handbook.opensociocracy.org' }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/orgs/OpenSociocracy' }
    ]
  }
})
