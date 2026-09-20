import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../widgets/network_banner.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CloudFeed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<PostProvider>().fetchPosts();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              NetworkBanner(
                offline: provider.isOffline,
              ),

              Expanded(
                child: _buildContent(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(PostProvider provider) {
    if (provider.status == PostStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.status == PostStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 70,
              ),

              const SizedBox(height: 16),

              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: provider.fetchPosts,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.posts.isEmpty) {
      return const Center(
        child: Text(
          'No posts available.',
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(
                isWide ? 24 : 16,
              ),
              itemCount: provider.posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: provider.posts[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}