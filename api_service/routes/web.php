<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\api\PostController;


Route::get('/', function () {
    return view('welcome');
});


Route::post('/posts', [PostController::class, 'store']);
Route::get('/posts', [PostController::class, 'index']);
