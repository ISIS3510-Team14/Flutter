import 'package:flutter/material.dart';

class GreenPoints extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<dynamic> categories;
  final Map<String, String> categoryRoutes = {
    'Paper': '/paper',
    'Glass': '/glass',
    'Organic': '/organic',
    'Metal': '/metal',
    'Other': '/other',
  };

  GreenPoints({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/backarrow.png',
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.network(
                imagePath,
                width: 400,
                errorBuilder: (context, error, stackTrace) {
                  // This will display a local asset as a fallback in case of an error
                  return Center(
                    child: Image.asset(
                      'assets/default_image.jpeg',
                      width: 250,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      final route = categoryRoutes[category];
                      if (route != null) {
                        Navigator.pushNamed(context, route);
                      } else {
                        print('No route defined for $category');
                      }
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
            )
          ],
        ),
      ),
    );
  }
}
