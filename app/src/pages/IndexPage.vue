<template>
  <q-page class="row items-center justify-evenly">
    <div class="text-h1 full-width text-center">{{ $t('homepage.heading') }}</div>
    <div class="text-h2 full-width  text-center">{{ $t('homepage.tagline') }}</div>
    <div class="full-width  text-center">
      <q-btn
        size="xl"
        :label="$t('homepage.button')"
        color="primary"
        :to="{ name: 'new-article'}"
      ></q-btn>
    </div>
  </q-page>
</template>

<script setup lang="ts">



</script>

<style lang="scss">


</style>
