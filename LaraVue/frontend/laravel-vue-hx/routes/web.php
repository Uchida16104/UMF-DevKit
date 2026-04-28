<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

Route::get('/', function () {
    return view('app');
});

Route::get('/analytics/snippet', function () {
    return <<<'HTML'
<div class="space-y-2">
  <p class="font-semibold text-cyan-300">Sample analytics snippet</p>
  <p>Partial responses keep the page fast and easy to reason about.</p>
</div>
HTML;
});

Route::get('/api/visitor-summary', function (Request $request) {
    $sample = [
        'active_sessions' => 12,
        'page_views' => 248,
        'top_route' => '/pricing',
        'top_referrer' => 'https://example.com/',
        'consent_rate' => 0.84,
    ];

    return response()->json($sample);
});
