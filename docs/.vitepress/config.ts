import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "OpenSociocracy / S3+",
  description: "Open Source Sociocracy 3.0 Tools",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Join in', link: 'https://handbook.opensociocracy.org/contributing' }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/orgs/OpenSociocracy' },
      { icon: 'discord', link: 'https://discord.gg/seExDy6M'},
      { icon: 'twitter', link: 'https://twitter.com/OpenSociocracy'},
      { icon: 'facebook', link: 'https://www.facebook.com/OpenSociocracy/'},
      { icon: 'mastodon', link: 'https://fosstodon.org/@opensociocracy'}
    ]
  }
})
