<template>
  <div class="p-4 bg-gray-800 border border-indigo-700 rounded">
    <p class="text-indigo-300 text-sm font-semibold">HelloWorld Component</p>
    <p class="text-gray-300 text-sm mt-1">{{ message }}</p>
    <p class="text-gray-500 text-xs mt-2">Rendered at: {{ timestamp }}</p>
  </div>
</template>

<script setup>
import { computed } from "vue";

const props = defineProps({
  message: {
    type: String,
    default: "Hello, World!",
  },
});

const timestamp = computed(() => new Date().toLocaleString());
</script>
