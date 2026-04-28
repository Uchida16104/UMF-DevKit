<template>
  <section class="lavue-card space-y-4">
    <div class="flex items-center justify-between gap-4">
      <div>
        <p class="text-sm uppercase tracking-[0.25em] text-cyan-300">Vue widget</p>
        <h2 class="text-2xl font-semibold">Template repository showcase</h2>
      </div>
      <button
        class="rounded-xl bg-cyan-400 px-4 py-2 font-semibold text-slate-950 transition hover:bg-cyan-300"
        @click="count += 1"
      >
        Count: {{ count }}
      </button>
    </div>

    <p class="text-slate-300">
      This component exists to show how a generated Laravel shell can host a Vue island while HTMX and hyperscript handle smaller interaction jobs.
    </p>

    <ul class="grid gap-2 text-sm text-slate-300 md:grid-cols-2">
      <li>Template repository explanation</li>
      <li>Event-driven analytics sample</li>
      <li>Progressive enhancement pattern</li>
      <li>Hybrid frontend composition</li>
    </ul>
  </section>
</template>

<script setup>
import { ref } from 'vue'

const count = ref(0)
</script>
