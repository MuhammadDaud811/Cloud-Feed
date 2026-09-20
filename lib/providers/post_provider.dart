import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/api_service.dart';

enum PostStatus {
  initial,
  loading,
  loaded,
  error,
}

class PostProvider extends ChangeNotifier {
  final ApiService apiService;

  PostProvider(this.apiService);

  List<Post> _posts = [];

  PostStatus _status = PostStatus.initial;

  String _errorMessage = '';

  bool _isOffline = false;

  List<Post> get posts => _posts;

  PostStatus get status => _status;

  String get errorMessage => _errorMessage;

  bool get isOffline => _isOffline;

  Future<void> fetchPosts() async {
    _status = PostStatus.loading;
    _errorMessage = '';

    notifyListeners();

    try {
      final connectivity =
      await Connectivity().checkConnectivity();

      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.mobile) &&
          !connectivity.contains(ConnectivityResult.ethernet)) {
        _isOffline = true;
        _status = PostStatus.error;
        _errorMessage =
        'You are offline. Please check your internet connection.';
        notifyListeners();
        return;
      }

      _isOffline = false;

      // Mock English Data
      final result = [
        const Post(
          id: 1,
          userId: 1,
          title: 'Welcome to CloudFeed',
          body: 'This is a sample post in English to demonstrate how the feed looks with real text.',
        ),
        const Post(
          id: 2,
          userId: 1,
          title: 'Flutter Development',
          body: 'Building beautiful user interfaces with Flutter is fast and productive thanks to its hot reload feature and extensive widget library.',
        ),
        const Post(
          id: 3,
          userId: 2,
          title: 'State Management',
          body: 'Choosing the right state management solution is crucial for building scalable Flutter applications. Provider is a great starting point.',
        ),
        const Post(
          id: 4,
          userId: 2,
          title: 'Clean Architecture',
          body: 'Separating your business logic from the UI makes your code more testable and easier to maintain in the long run.',
        ),
        const Post(
          id: 5,
          userId: 3,
          title: 'Cloud Services',
          body: 'Integrating cloud services into your mobile app allows for real-time data synchronization and user authentication.',
        ),
      ];

      _posts = result;

      _status = PostStatus.loaded;
    } on DioException catch (e) {
      _status = PostStatus.error;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        _isOffline = true;

        _errorMessage =
        'Unable to connect to the server. '
            'Please check your internet connection.';
      } else {
        _errorMessage =
        'Something went wrong while loading the posts.';
      }
    } catch (e) {
      _status = PostStatus.error;
      _errorMessage =
      'An unexpected error occurred.';
    }

    notifyListeners();
  }
}