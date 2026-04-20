<script setup lang="ts">
defineProps<{
  accent?: boolean
  hover?: boolean
}>()
</script>

<template>
  <div
    class="bg-ark-card border border-ark-border clip-cut-bl corner-mark"
    :class="[
      accent ? 'border-l-2 border-l-ark-yellow' : '',
      hover ? 'cursor-pointer transition-all duration-150 hover:border-ark-yellow/50 hover:bg-[#2a2a2a] active:scale-[0.98]' : '',
    ]"
  >
    <slot />
  </div>
</template>