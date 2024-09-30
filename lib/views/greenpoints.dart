import 'package:flutter/material.dart';

class GreenPoints extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<String> categories;

  const GreenPoints({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/backarrow.png', // Replace with your custom back arrow image
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0), // Add padding to the entire view
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add padding around the image
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.asset(
                imagePath,
                width: 400,
                //fit:  middle,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Categories as blue clickable text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle category tap
                    },
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
