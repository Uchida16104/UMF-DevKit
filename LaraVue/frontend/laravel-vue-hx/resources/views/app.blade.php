<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="csrf-token" content="{{ csrf_token() }}">
  <title>{{ config('app.name', 'LaraVue') }}</title>
  @vite(['resources/css/app.css', 'resources/js/app.js'])
  <script src="https://unpkg.com/htmx.org@1.9.12"></script>
  <script src="https://unpkg.com/hyperscript.org@0.9.12"></script>
</head>
<body class="min-h-screen">
  <main class="mx-auto flex max-w-6xl flex-col gap-8 px-6 py-10">
    <section class="lavue-card space-y-5">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div>
          <p class="text-sm uppercase tracking-[0.3em] text-cyan-300">LaraVue template repository</p>
          <h1 class="mt-2 text-4xl font-bold">Laravel + Vue + HTMX + hyperscript + Tailwind CSS</h1>
        </div>
        <span class="rounded-full border border-cyan-400/30 bg-cyan-400/10 px-4 py-2 text-sm text-cyan-200">
          Repository name: LaraVue
        </span>
      </div>

      <p class="max-w-3xl text-slate-300">
        This page demonstrates how the template repository describes itself, how the frontend is wired, and how a backend analytics service can be connected later.
      </p>

      <div class="grid gap-4 md:grid-cols-3">
        <article class="rounded-2xl bg-slate-950/60 p-4">
          <h2 class="font-semibold">Template usage</h2>
          <p class="mt-2 text-sm text-slate-300">Copy this shell into a project repository and tune it per application.</p>
        </article>
        <article class="rounded-2xl bg-slate-950/60 p-4">
          <h2 class="font-semibold">HTMX demo</h2>
          <button class="mt-2 rounded-lg bg-slate-800 px-3 py-2 text-sm" hx-get="/analytics/snippet" hx-target="#snippet-target" hx-swap="innerHTML">
            Load analytics snippet
          </button>
        </article>
        <article class="rounded-2xl bg-slate-950/60 p-4">
          <h2 class="font-semibold">hyperscript demo</h2>
          <button class="mt-2 rounded-lg bg-slate-800 px-3 py-2 text-sm"
                  _="on click toggle .ring-2 .ring-cyan-400 on me then put 'Hyperscript handled this interaction.' into #hs-result">
            Toggle behavior
          </button>
        </article>
      </div>
    </section>

    <div id="vue-app">
      <visitor-template-demo></visitor-template-demo>
    </div>

    <section class="grid gap-6 md:grid-cols-2">
      <article class="lavue-card">
        <h2 class="text-xl font-semibold">HTMX partial region</h2>
        <div id="snippet-target" class="mt-4 rounded-xl border border-dashed border-slate-700 p-4 text-slate-300">
          Click the button above to fetch a partial response.
        </div>
      </article>

      <article class="lavue-card">
        <h2 class="text-xl font-semibold">hyperscript result</h2>
        <div id="hs-result" class="mt-4 rounded-xl border border-dashed border-slate-700 p-4 text-slate-300">
          This area changes when the hyperscript button is clicked.
        </div>
      </article>
    </section>
  </main>
</body>
</html>
