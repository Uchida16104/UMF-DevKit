<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class AnalyticsController extends Controller
{
    public function index(): View
    {
        return view('app');
    }

    public function snippet(): string
    {
        return <<<'HTML'
<div class="space-y-2">
  <p class="font-semibold text-cyan-300">Rendered from Laravel</p>
  <p>This partial can be swapped in by HTMX without replacing the whole page.</p>
</div>
HTML;
    }

    public function summary(Request $request): JsonResponse
    {
        return response()->json([
            'app' => 'LaraVue',
            'sample_mode' => true,
            'total_events' => 248,
            'unique_visitors' => 73,
            'top_route' => '/dashboard',
            'top_referrer' => 'https://example.com/',
            'consent_rate' => 0.84,
            'user_agent' => $request->userAgent(),
        ]);
    }
}
