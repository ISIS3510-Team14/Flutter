import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';

class HeaderWidget extends StatelessWidget {
  final StorageService _storageService = StorageService();

  Future<String?> _loadUserProfilePicture() async {
    Map<String, dynamic>? credentials =
        await _storageService.getUserCredentials();
    return credentials?['picture'];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/logo (1).png',
          height: 50,
        ),
        FutureBuilder<String?>(
          future: _loadUserProfilePicture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.flutter_dash,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              );
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(snapshot.data!),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
