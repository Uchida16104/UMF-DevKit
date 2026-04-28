<template>
  <div class="min-h-screen bg-gray-950 text-gray-100 font-mono">
    <header class="border-b border-gray-800 px-8 py-6">
      <h1 class="text-3xl font-bold text-indigo-400">LaraVue</h1>
      <p class="text-gray-400 mt-1">Vue.js 3 + Tailwind CSS Frontend</p>
    </header>

    <main class="max-w-3xl mx-auto px-8 py-12 space-y-10">
      <section>
        <h2 class="text-xl font-semibold text-indigo-300 mb-4">Reactive Counter</h2>
        <div class="flex items-center gap-4">
          <button
            class="px-4 py-2 bg-indigo-600 hover:bg-indigo-500 rounded text-white text-sm transition"
            @click="count--"
          >
            −
          </button>
          <span class="text-2xl font-bold text-white">{{ count }}</span>
          <button
            class="px-4 py-2 bg-indigo-600 hover:bg-indigo-500 rounded text-white text-sm transition"
            @click="count++"
          >
            +
          </button>
        </div>
      </section>

      <section>
        <h2 class="text-xl font-semibold text-indigo-300 mb-4">API Fetch (FastAPI)</h2>
        <button
          class="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 rounded text-white text-sm transition mb-4"
          @click="fetchHello"
          :disabled="loading"
        >
          {{ loading ? "Loading…" : "Fetch /hello" }}
        </button>
        <div
          class="p-4 bg-gray-800 rounded border border-gray-700 text-sm text-green-400 min-h-10"
        >
          {{ apiResponse || "No response yet." }}
        </div>
        <p v-if="error" class="text-red-400 text-sm mt-2">{{ error }}</p>
      </section>

      <section>
        <h2 class="text-xl font-semibold text-indigo-300 mb-4">Component Demo</h2>
        <HelloWorld message="Hello from LaraVue!" />
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref } from "vue";
import HelloWorld from "./components/HelloWorld.vue";

const count = ref(0);
const apiResponse = ref("");
const loading = ref(false);
const error = ref("");

async function fetchHello() {
  loading.value = true;
  error.value = "";
  try {
    const res = await fetch("https://umf-devkit-fastapi.onrender.com:8004/hello");
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    apiResponse.value = JSON.stringify(data, null, 2);
  } catch (e) {
    error.value = `Failed to fetch: ${e.message}`;
  } finally {
    loading.value = false;
  }
}
</script>
