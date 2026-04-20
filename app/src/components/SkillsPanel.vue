<script setup lang="ts">
import BaseCard from './BaseCard.vue'
import SvgIcon from './SvgIcon.vue'

defineProps<{
  skills: string[]
  skillProgress: number
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
        <SvgIcon name="zap" :size="16" class="text-ark-yellow" />
        <span class="text-lg font-bold tracking-tight">技能</span>
        <span class="tag-label">SKILLS</span>
      </div>
    </div>

    <!-- 技能列表 -->
    <BaseCard>
      <div class="p-5">
        <div class="flex items-center justify-between mb-4">
          <span class="tag-label">acquired skills</span>
          <span class="tag-label text-ark-yellow">{{ skills.length }} unlocked</span>
        </div>
        <div class="flex flex-wrap gap-2">
          <div
            v-for="skill in skills"
            :key="skill"
            class="px-3 py-2 bg-ark-surface border border-ark-border text-sm text-ark-white clip-cut-bl transition-all duration-150 hover:border-ark-yellow/50 hover:text-ark-yellow cursor-default"
          >
            {{ skill }}
          </div>
        </div>
      </div>
    </BaseCard>

    <!-- 进度 -->
    <BaseCard :accent="true">
      <div class="p-5">
        <div class="flex items-center justify-between mb-2">
          <span class="tag-label">skill tree progress</span>
          <span class="font-mono text-sm text-ark-yellow font-medium">{{ skillProgress }}%</span>
        </div>
        <div class="ark-bar">
          <div class="ark-bar-fill" :style="{ width: `${skillProgress}%` }" />
        </div>
        <p class="tag-label mt-3">持续学习中 · 距精通还有很远的路</p>
      </div>
    </BaseCard>
  </div>
</template>