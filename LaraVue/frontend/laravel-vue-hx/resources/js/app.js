import { createApp } from 'vue'
import VisitorTemplateDemo from './components/VisitorTemplateDemo.vue'
import 'htmx.org'
import 'hyperscript.org'

createApp({
  components: { VisitorTemplateDemo }
}).mount('#vue-app')
