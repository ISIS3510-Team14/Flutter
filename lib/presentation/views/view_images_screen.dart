import 'package:flutter/material.dart';
import 'dart:io';
import '../../presentation/widgets/display_picture_widget.dart'; // Adjust the import based on your directory structure

class ViewImagesScreen extends StatefulWidget {
  @override
  _ViewImagesScreenState createState() => _ViewImagesScreenState();
}

class _ViewImagesScreenState extends State<ViewImagesScreen> {
  late List<File> images;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    images = ModalRoute.of(context)!.settings.arguments as List<File>;
  }

  void _deleteImage(int index) async {
    try {
      // Delete the image from storage
      await images[index].delete();
    } catch (e) {
      print('Error deleting image: $e'); // Handle any errors
    }

    // Remove the image from the list after deletion
    setState(() {
      images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temporary Images')),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          // Check if the path is a valid file before accessing it
          if (!images[index].existsSync() || images[index].statSync().type == FileSystemEntityType.directory) {
            return SizedBox.shrink(); // Skip the item if it's not a valid file
          }

          DateTime date = images[index].lastModifiedSync();

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: Image.file(
                images[index],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text('Image ${index + 1}'),
              subtitle: Text('${date.toLocal()}'.split(' ')[0]),
              onTap: () async {
                // Display the full image
                final imagePath = images[index].path;

                // Push to DisplayPictureScreen (from the imported widget)
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(imagePath: imagePath),
                  ),
                );

                // Delete the image after viewing
                _deleteImage(index);
              },
            ),
          );
        },
      ),
    );
  }
}
