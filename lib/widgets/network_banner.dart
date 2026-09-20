import 'package:flutter/material.dart';

class NetworkBanner extends StatelessWidget {
  final bool offline;

  const NetworkBanner({
    super.key,
    required this.offline,
  });

  @override
  Widget build(BuildContext context) {
    if (!offline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud_off),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline — check your internet connection.',
            ),
          ),
        ],
      ),
    );
  }
}