<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Post;

class PostSeeder extends Seeder
{
    public function run(): void
    {
        if ($this->command) {
            $this->command->info('PostSeeder: starting...');
        }

        $posts = [
            [
                'title' => 'Welcome to the API',
                'description' => 'This is a sample post seeded into the database.',
                'image_path' => 'images/sample1.jpg',
            ],
            [
                'title' => 'Getting Started',
                'description' => 'Use this API to list posts and build your Flutter app.',
                'image_path' => 'images/sample2.jpg',
            ],
            [
                'title' => 'Another Post',
                'description' => 'Seeding makes development faster.',
                'image_path' => 'images/sample3.jpg',
            ],
        ];

        foreach ($posts as $data) {
            Post::updateOrCreate(
                ['title' => $data['title']],
                $data
            );
        }

        if ($this->command) {
            $count = Post::count();
            $this->command->info("PostSeeder: done. Total posts now: {$count}");
        }
    }
}
