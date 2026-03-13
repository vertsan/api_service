import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Future<Welcome> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
  }

  Future<Welcome> _fetchPosts() async {
    // final url = Uri.parse('http://10.0.2.2:8000/api/posts');
    final url = Uri.parse('http://127.0.0.1:8000/api/posts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return welcomeFromJson(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load posts (${response.statusCode})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: FutureBuilder<Welcome>(
        future: _postsFuture,
        builder: (BuildContext context, AsyncSnapshot<Welcome> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Something went wrong while loading posts.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _postsFuture = _fetchPosts();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final Welcome? data = snapshot.data;
          if (data == null || data.data.isEmpty) {
            return const Center(child: Text('No posts found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: data.data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final Datum post = data.data[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  title: Text(
                    post.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        post.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Created: ${post.createdAt.toLocal().toString().split(".").first}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        post.imageUrl != null && post.imageUrl!.isNotEmpty
                        ? NetworkImage(post.imageUrl!)
                        : null,
                    child: post.imageUrl == null || post.imageUrl!.isEmpty
                        ? Text(
                            post.title.isNotEmpty
                                ? post.title[0].toUpperCase()
                                : '?',
                          )
                        : null,
                  ),
                  onTap: () {
                    // You can navigate to a detail page here if needed.
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
