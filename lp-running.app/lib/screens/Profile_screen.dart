import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> userProfileFuture;

  @override
  void initState() {
    super.initState();
    userProfileFuture = fetchUserProfile();
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    await Future.delayed(const Duration(seconds: 2)); 
    return {
      'photoUrl': 'https://example.com/photo.jpg', 
      'name': 'User Name',
      'email': 'user@example.com',
      'phone': '(11) 99999-9999',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 3,
      pageTitle: 'Profile',
      child: FutureBuilder<Map<String, dynamic>>(
        future: userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          }

          final userProfile = snapshot.data!;
          final photoUrl = userProfile['photoUrl'] ?? '';
          final name = userProfile['name'] ?? 'Name not available';
          final email = userProfile['email'] ?? 'Email not available';
          final phone = userProfile['phone'] ?? 'Phone not available';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photoUrl),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  phone,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
