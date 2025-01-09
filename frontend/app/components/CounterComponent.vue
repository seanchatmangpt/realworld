<script setup>
import { storeToRefs } from 'pinia'

// access the `store` variable anywhere in the component ✨
const store = useCounterStore()
const { name, doubleCount } = storeToRefs(store)
const { increment } = store

// import { useIntervalFn } from "@vueuse/core";
//
// const { pause, resume, isActive } = useIntervalFn(() => {
//   store.increment();
// }, 300);
</script>

<template>
  {{ name }}{{ doubleCount }}
  <button @click="increment">Increment</button>
</template>

<style scoped></style>
