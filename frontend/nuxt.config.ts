// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: [
    '@nuxt/ui',
    '@nuxt/eslint',
    '@nuxt/test-utils/module',
    '@pinia/nuxt',
  ],
  css: ['~/assets/css/main.css'],

  pinia: {
    storesDirs: ['./stores/**', './app/stores/**'],
  },

  future: {
    compatibilityVersion: 4,
  },

  compatibilityDate: '2024-11-27',

  ssr: false,
})
