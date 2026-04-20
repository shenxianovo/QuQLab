<script setup lang="ts">
import type { Achievement } from '../types'
import BaseCard from './BaseCard.vue'
import SvgIcon from './SvgIcon.vue'

defineProps<{
  achievements: Achievement[]
  achievementsTotal: number
  compact?: boolean
}>()

defineEmits<{
  back: []
}>()
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
        <SvgIcon name="trophy" :size="16" class="text-ark-yellow" />
        <span class="text-lg font-bold tracking-tight">成就</span>
        <span class="tag-label">TROPHY</span>
      </div>
    </div>

    <!-- 进度统计 -->
    <BaseCard :accent="true">
      <div class="p-4 flex items-center justify-between">
        <div>
          <span class="tag-label">completion</span>
          <div class="flex items-baseline gap-1 mt-1">
            <span class="font-mono text-lg font-bold text-ark-yellow">{{ achievements.length }}</span>
            <span class="text-ark-muted text-sm">/ {{ achievementsTotal }}</span>
          </div>
        </div>
        <div class="flex-1 ml-6">
          <div class="ark-bar">
            <div class="ark-bar-fill" :style="{ width: `${(achievements.length / achievementsTotal) * 100}%` }" />
          </div>
        </div>
      </div>
    </BaseCard>

    <!-- 成就列表 -->
    <div class="flex flex-col gap-2">
      <BaseCard v-for="(ach, i) in achievements" :key="i" :hover="true">
        <div class="p-4 flex items-start gap-4">
          <!-- 图标 -->
          <div class="w-10 h-10 bg-ark-surface border border-ark-yellow/30 flex items-center justify-center flex-shrink-0 clip-cut-tr text-ark-yellow">
            <SvgIcon :name="ach.icon" :size="20" />
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2">
              <span class="text-sm font-semibold text-ark-white">{{ ach.title }}</span>
              <span class="tag-label text-ark-yellow">achieved</span>
            </div>
            <p class="text-ark-muted text-xs mt-1">{{ ach.description }}</p>
          </div>
        </div>
      </BaseCard>
    </div>
  </div>
</template>