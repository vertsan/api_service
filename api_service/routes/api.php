<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\PostController;
use App\Http\Resources\PostResource;
use App\Models\Post;


Route::apiResource('posts', PostController::class);

