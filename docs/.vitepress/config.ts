import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "OpenSociocracy",
  description: "Open Source Sociocracy 3.0 Tools",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Join in', link: 'https://handbook.opensociocracy.org/contributing/' }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/orgs/OpenSociocracy' },
      // { icon: 'discord', link: 'https://discord.gg/seExDy6M'},
      { icon: 'twitter', link: 'https://twitter.com/OpenSociocracy'},
      { icon: 'facebook', link: 'https://www.facebook.com/OpenSociocracy/'},
      { icon: 'mastodon', link: 'https://fosstodon.org/@opensociocracy'}
    ],

    footer: {
      message: 'Sponsored by "S3 org name" and "funding org name"',
      copyright: 'Released under the <a href="https://github.com/OpenSociocracy/documentation-website/blob/main/LICENSE">MIT</a> and <a href="https://github.com/OpenSociocracy/open-sociocracy-saas/blob/main/LICENSE">AGPL</a> License</a>.<br />Copyright <a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA</a>'
    }
  }
})
