<script setup lang="ts">
import { ref, computed } from 'vue'
import type { PanelType } from '../types'
import { siteConfig } from '../data'
import BaseCard from './BaseCard.vue'
import SvgIcon from './SvgIcon.vue'
import StatsPanel from './StatsPanel.vue'
import SkillsPanel from './SkillsPanel.vue'
import AchievementsPanel from './AchievementsPanel.vue'

const { profile, stats, skills, skillProgress, achievements, achievementsTotal, evaluation, links, siteLabel } = siteConfig

/** 根据生日计算当前年龄（实时） */
function calcAge(birthday: string): number {
  const birth = new Date(birthday)
  const now = new Date()
  let age = now.getFullYear() - birth.getFullYear()
  const monthDiff = now.getMonth() - birth.getMonth()
  if (monthDiff < 0 || (monthDiff === 0 && now.getDate() < birth.getDate())) {
    age--
  }
  return age
}

/** 今年已过的天数占比（经验条） */
function calcYearProgress(birthday: string): number {
  const birth = new Date(birthday)
  const now = new Date()
  const age = calcAge(birthday)
  const thisYearBirthday = new Date(birth.getFullYear() + age, birth.getMonth(), birth.getDate())
  const nextBirthday = new Date(birth.getFullYear() + age + 1, birth.getMonth(), birth.getDate())
  const total = nextBirthday.getTime() - thisYearBirthday.getTime()
  const elapsed = now.getTime() - thisYearBirthday.getTime()
  return Math.min(100, Math.max(0, Math.round((elapsed / total) * 100)))
}

const level = computed(() => calcAge(profile.birthday))
const expPercent = computed(() => calcYearProgress(profile.birthday))

const activePanel = ref<PanelType>('stats')

const tabs: { key: PanelType; label: string; code: string; icon: string }[] = [
  { key: 'stats', label: '属性', code: 'STATUS', icon: 'bar-chart' },
  { key: 'skills', label: '技能', code: 'SKILLS', icon: 'zap' },
  { key: 'achievements', label: '成就', code: 'TROPHY', icon: 'trophy' },
]

// 移动端状态：是否展开子面板
const mobileShowSub = ref(false)

function selectTab(key: PanelType) {
  activePanel.value = key
  mobileShowSub.value = true
}

function mobileBack() {
  mobileShowSub.value = false
}
</script>

<template>
  <div class="min-h-screen overflow-hidden topo-bg">
    <!-- 网格装饰 -->
    <div class="fixed inset-0 grid-dots pointer-events-none opacity-30" />

    <!-- 顶部装饰线 -->
    <div class="fixed top-0 left-0 right-0 h-[1px] bg-ark-border z-30" />
    <div class="fixed top-0 left-0 w-20 h-[3px] bg-ark-yellow z-30" />

    <!-- ============ PC 布局 (lg+): 左贴边 + 装饰留白 ============ -->
    <div class="hidden lg:flex min-h-screen relative z-10">

      <!-- 左侧：个人信息面板 -->
      <aside class="w-[300px] xl:w-[340px] flex-shrink-0 border-r border-ark-border flex flex-col">
        <div class="flex-1 flex flex-col p-8 gap-6">
          <!-- 头像 + 基本信息 -->
          <div class="flex items-start gap-5">
            <div class="w-20 h-20 bg-ark-surface border border-ark-border flex items-center justify-center flex-shrink-0 clip-cut-tr text-ark-yellow">
              <SvgIcon :name="profile.avatar" :size="36" />
            </div>
            <div class="flex-1 min-w-0 pt-1">
              <h1 class="text-3xl font-black tracking-tight text-white">{{ profile.name }}</h1>
              <p class="text-ark-muted text-sm mt-1">{{ profile.title }}</p>
            </div>
          </div>

          <!-- 等级 + 经验（年龄 = level，经验条 = 距下次生日进度） -->
          <div class="bg-ark-card border border-ark-border p-4 clip-cut-bl">
            <div class="flex items-center justify-between mb-2">
              <span class="tag-label text-ark-yellow">Lv.{{ level }}</span>
            </div>
            <div class="ark-bar">
              <div class="ark-bar-fill" :style="{ width: `${expPercent}%` }" />
            </div>
            <div class="flex items-center justify-between mt-2">
              <span class="tag-label">exp</span>
              <span class="tag-label text-ark-yellow">{{ expPercent }}%</span>
            </div>
          </div>

          <!-- Tab 导航 -->
          <nav class="flex flex-col gap-1 mt-2">
            <button
              v-for="tab in tabs"
              :key="tab.key"
              class="flex items-center gap-3 px-4 py-3 text-left transition-all duration-150 clip-cut-bl border"
              :class="activePanel === tab.key
                ? 'bg-ark-card border-ark-yellow/40 text-ark-yellow'
                : 'bg-transparent border-transparent text-ark-muted hover:bg-ark-card/50 hover:text-ark-white'"
              @click="activePanel = tab.key"
            >
              <div class="w-0.5 h-5 flex-shrink-0 transition-colors" :class="activePanel === tab.key ? 'bg-ark-yellow' : 'bg-transparent'" />
              <SvgIcon :name="tab.icon" :size="16" />
              <span class="text-sm font-medium">{{ tab.label }}</span>
              <span class="tag-label ml-auto">{{ tab.code }}</span>
            </button>
          </nav>

          <!-- 快捷链接 -->
          <div class="mt-auto">
            <div class="flex items-center gap-2 mb-3">
              <div class="w-1 h-3 bg-ark-dim" />
              <SvgIcon name="link" :size="12" class="text-ark-dim" />
              <span class="tag-label">quicklinks</span>
            </div>
            <div class="flex flex-wrap gap-2">
              <a
                v-for="link in links"
                :key="link.href"
                :href="link.href"
                class="px-3 py-1.5 text-xs bg-ark-surface border border-ark-border text-ark-muted transition-all duration-150 hover:border-ark-yellow/50 hover:text-ark-yellow clip-cut-bl"
              >
                {{ link.label }}
              </a>
            </div>
          </div>

          <!-- 底部状态 -->
          <div class="flex items-center justify-between pt-4 border-t border-ark-border">
            <div class="flex items-center gap-1.5">
              <SvgIcon name="signal" :size="12" class="text-ark-yellow" style="animation: pulse-slow 3s ease infinite;" />
              <span class="tag-label">online</span>
            </div>
            <span class="tag-label">{{ siteLabel }}</span>
          </div>
        </div>
      </aside>

      <!-- 中间：动态面板 -->
      <main class="w-[580px] xl:w-[900px] flex-shrink-0 overflow-y-auto border-r border-ark-border/30">
        <div class="p-8 xl:p-12">
          <!-- 面板标题 -->
          <div class="flex items-center gap-3 mb-8">
            <div class="w-1 h-6 bg-ark-yellow" />
            <SvgIcon :name="tabs.find(t => t.key === activePanel)!.icon" :size="20" class="text-ark-yellow" />
            <h2 class="text-2xl font-bold tracking-tight">{{ tabs.find(t => t.key === activePanel)!.label }}</h2>
            <span class="tag-label">{{ tabs.find(t => t.key === activePanel)!.code }}</span>
          </div>

          <Transition name="ark-fade" mode="out-in">
            <StatsPanel
              v-if="activePanel === 'stats'"
              key="stats"
              :stats="stats"
              :evaluation="evaluation"
              :compact="true"
            />
            <SkillsPanel
              v-else-if="activePanel === 'skills'"
              key="skills"
              :skills="skills"
              :skill-progress="skillProgress"
              :compact="true"
            />
            <AchievementsPanel
              v-else-if="activePanel === 'achievements'"
              key="achievements"
              :achievements="achievements"
              :achievements-total="achievementsTotal"
              :compact="true"
            />
          </Transition>
        </div>
      </main>

      <!-- 右侧：装饰区域 -->
      <div class="flex-1 min-w-0 flex flex-col justify-between p-8 xl:p-12 pointer-events-none select-none">
        <!-- 右上角：日期/坐标 -->
        <div class="flex flex-col items-end gap-1">
          <span class="tag-label text-ark-dim">{{ new Date().toLocaleDateString('en-CA') }}</span>
          <span class="tag-label text-ark-border">N 39.9° / E 116.4°</span>
        </div>

        <!-- 中间留白 -->
        <div />

        <!-- 右下角：装饰文字 -->
        <div class="flex flex-col items-end gap-2">
          <div class="flex items-center gap-2">
            <div class="w-12 h-[1px] bg-ark-border/50" />
            <span class="tag-label text-ark-border">SYS.NORMAL</span>
          </div>
          <p class="text-right text-[10px] tracking-[0.2em] text-ark-border/60 uppercase leading-relaxed">
            Over the frontier<br />Into the front
          </p>
          <span class="tag-label text-ark-dim mt-4">{{ siteLabel }} — v1.0</span>
        </div>
      </div>

    </div>

    <!-- ============ 移动布局 (<lg): 单列切换 ============ -->
    <div class="lg:hidden min-h-screen relative z-10 p-4">
      <Transition name="ark-forward" mode="out-in">
        <!-- 主面板 -->
        <div v-if="!mobileShowSub" key="mobile-main" class="flex flex-col gap-4">
          <!-- 角色卡 -->
          <BaseCard :accent="true">
            <div class="p-5">
              <div class="flex items-start gap-4">
                <div class="w-16 h-16 bg-ark-surface border border-ark-border flex items-center justify-center flex-shrink-0 clip-cut-tr text-ark-yellow">
                  <SvgIcon :name="profile.avatar" :size="28" />
                </div>
                <div class="flex-1 min-w-0">
                  <div class="flex items-baseline gap-2">
                    <h1 class="text-xl font-bold tracking-tight text-white">{{ profile.name }}</h1>
                    <span class="tag-label text-ark-yellow">Lv.{{ level }}</span>
                  </div>
                  <p class="text-ark-muted text-sm mt-0.5">{{ profile.title }}</p>
                  <div class="mt-3">
                    <div class="flex items-center justify-between mb-1">
                      <span class="tag-label">exp</span>
                      <span class="tag-label">{{ expPercent }}%</span>
                    </div>
                    <div class="ark-bar">
                      <div class="ark-bar-fill" :style="{ width: `${expPercent}%` }" />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </BaseCard>

          <!-- 菜单 -->
          <div class="flex flex-col gap-2">
            <div
              v-for="tab in tabs"
              :key="tab.key"
              class="ark-btn p-4 clip-cut-bl"
              @click="selectTab(tab.key)"
            >
              <div class="w-1 h-5 bg-ark-yellow flex-shrink-0" />
              <SvgIcon :name="tab.icon" :size="16" class="opacity-60" />
              <div class="flex-1 flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <span class="text-sm font-semibold">{{ tab.label }}</span>
                  <span class="tag-label">{{ tab.code }}</span>
                </div>
                <SvgIcon name="arrow-right" :size="14" class="opacity-40" />
              </div>
            </div>
          </div>

          <!-- 快捷链接 -->
          <BaseCard>
            <div class="p-4">
              <div class="flex items-center gap-2 mb-3">
                <div class="w-1 h-3 bg-ark-dim" />
                <SvgIcon name="link" :size="12" class="text-ark-dim" />
                <span class="tag-label">quicklinks</span>
              </div>
              <div class="flex flex-wrap gap-2">
                <a
                  v-for="link in links"
                  :key="link.href"
                  :href="link.href"
                  class="px-3 py-1.5 text-xs bg-ark-surface border border-ark-border text-ark-muted transition-all duration-150 hover:border-ark-yellow/50 hover:text-ark-yellow clip-cut-bl"
                >
                  {{ link.label }}
                </a>
              </div>
            </div>
          </BaseCard>

          <div class="flex items-center justify-between mt-2 px-1">
            <div class="flex items-center gap-1.5">
              <SvgIcon name="signal" :size="12" class="text-ark-yellow" style="animation: pulse-slow 3s ease infinite;" />
              <span class="tag-label">online</span>
            </div>
            <span class="tag-label">{{ siteLabel }}</span>
          </div>
        </div>

        <!-- 子面板 -->
        <div v-else key="mobile-sub" class="flex flex-col gap-4">
          <!-- 返回按钮 + 标题 -->
          <div class="flex items-center gap-3">
            <button class="ark-btn px-3 py-2 clip-cut-bl text-xs" @click="mobileBack">
              <SvgIcon name="arrow-left" :size="14" />
              返回
            </button>
            <div class="flex items-center gap-2">
              <div class="w-1 h-4 bg-ark-yellow" />
              <SvgIcon :name="tabs.find(t => t.key === activePanel)!.icon" :size="16" class="text-ark-yellow" />
              <span class="text-lg font-bold tracking-tight">{{ tabs.find(t => t.key === activePanel)!.label }}</span>
              <span class="tag-label">{{ tabs.find(t => t.key === activePanel)!.code }}</span>
            </div>
          </div>

          <StatsPanel
            v-if="activePanel === 'stats'"
            :stats="stats"
            :evaluation="evaluation"
            :compact="true"
          />
          <SkillsPanel
            v-else-if="activePanel === 'skills'"
            :skills="skills"
            :skill-progress="skillProgress"
            :compact="true"
          />
          <AchievementsPanel
            v-else-if="activePanel === 'achievements'"
            :achievements="achievements"
            :achievements-total="achievementsTotal"
            :compact="true"
          />
        </div>
      </Transition>
    </div>
  </div>
</template>

<style scoped>
/* 淡入切换（PC右侧面板） */
.ark-fade-enter-active,
.ark-fade-leave-active {
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}
.ark-fade-enter-from {
  opacity: 0;
  transform: translateY(12px);
}
.ark-fade-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

/* 滑入切换（移动端） */
.ark-forward-enter-active,
.ark-forward-leave-active {
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}
.ark-forward-enter-from {
  opacity: 0;
  transform: translateX(30px);
}
.ark-forward-leave-to {
  opacity: 0;
  transform: translateX(-15px);
}
</style>