import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "OpenSociocracy",
  description: "Open Source Sociocracy 3.0 Tools",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Join in', link: 'https://handbook.opensociocracy.org/contributing' }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/orgs/Open Sociocray' },
      { icon: 'discord', link: 'https://discord.com/channels/1103176560699260938/1103176560699260941'}
    ]
  }
})
