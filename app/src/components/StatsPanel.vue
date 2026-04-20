<script setup lang="ts">
import BaseCard from './BaseCard.vue'
import SvgIcon from './SvgIcon.vue'

interface StatItem {
  key: string
  label: string
  code: string
  icon: string
  value: number
}

defineProps<{
  stats: StatItem[]
  evaluation: { rank: string; comment: string }
  compact?: boolean
}>()

defineEmits<{
  back: []
}>()

function avgValue(stats: StatItem[]): number {
  return Math.round(stats.reduce((sum, s) => sum + s.value, 0) / stats.length)
}
</script>

<template>
  <div class="flex flex-col gap-4 w-full">
    <!-- Header（仅非 compact 模式） -->
    <div v-if="!compact" class="flex items-center gap-4">
      <button class="ark-btn px-3 py-2 clip-cut-bl text-xs" @click="$emit('back')">
        <SvgIcon name="arrow-left" :size="14" />
        返回
      </button>
      <div class="flex items-center gap-2">
        <div class="w-1 h-4 bg-ark-yellow" />
        <SvgIcon name="bar-chart" :size="16" class="text-ark-yellow" />
        <span class="text-lg font-bold tracking-tight">属性</span>
        <span class="tag-label">STATUS</span>
      </div>
    </div>

    <!-- 属性列表 -->
    <BaseCard>
      <div class="p-5 flex flex-col gap-5">
        <div v-for="stat in stats" :key="stat.key">
          <div class="flex items-center justify-between mb-2">
            <div class="flex items-center gap-2">
              <SvgIcon :name="stat.icon" :size="14" class="text-ark-dim" />
              <span class="tag-label text-ark-yellow w-8">{{ stat.code }}</span>
              <span class="text-sm text-ark-white">{{ stat.label }}</span>
            </div>
            <span class="font-mono text-sm font-medium text-ark-yellow">{{ stat.value }}</span>
          </div>
          <div class="ark-bar">
            <div class="ark-bar-fill" :style="{ width: `${stat.value}%` }" />
          </div>
        </div>
      </div>
    </BaseCard>

    <!-- 综合评估 -->
    <BaseCard :accent="true">
      <div class="p-5">
        <div class="flex items-center justify-between">
          <div>
            <span class="tag-label">comprehensive evaluation</span>
            <div class="flex items-baseline gap-2 mt-2">
              <span class="text-4xl font-black text-ark-yellow tracking-tighter">
                {{ avgValue(stats) }}
              </span>
              <span class="text-sm text-ark-muted">/ 100</span>
            </div>
          </div>
          <div class="text-right">
            <div class="text-2xl font-black text-ark-yellow tracking-wider">{{ evaluation.rank }}</div>
            <span class="tag-label">{{ evaluation.comment }}</span>
          </div>
        </div>
      </div>
    </BaseCard>
  </div>
</template>