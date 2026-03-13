<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PostResource;
use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index()
    {
        return PostResource::collection(
            Post::query()->latest()->get()
        );
    }
    public function store(Request $request)
{
    $validated = $request->validate([
        'title' => 'required|string',
        'description' => 'required|string',
        'image_path' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
    ]);

    $imagePath = null;

    if ($request->file('image_path')) {
        $imagePath = $request->file('image_path')->store('posts', 'public');
    }

    $post = Post::create([
        'title' => $validated['title'],
        'description' => $validated['description'],
        'image_path' => $imagePath,
    ]);

    return new PostResource($post);
}


}


