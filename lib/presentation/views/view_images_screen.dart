import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../presentation/widgets/display_picture_widget.dart';

class ViewImagesScreen extends StatefulWidget {
  @override
  _ViewImagesScreenState createState() => _ViewImagesScreenState();
}

class _ViewImagesScreenState extends State<ViewImagesScreen> {
  late List<File> images;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List<File> allFiles = ModalRoute.of(context)!.settings.arguments as List<File>;
    
    // Filter the files to include only those with image extensions
    images = allFiles.where((file) {
      final ext = path.extension(file.path).toLowerCase();
      return ['.jpg', '.jpeg', '.png', '.gif'].contains(ext);
    }).toList();
  }

  void _deleteImage(int index) async {
    try {
      await images[index].delete();
    } catch (e) {
      print('Error deleting image: $e');
    }

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
          if (!images[index].existsSync() || images[index].statSync().type == FileSystemEntityType.directory) {
            return SizedBox.shrink();
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
                final imagePath = images[index].path;

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(imagePath: imagePath),
                  ),
                );

                _deleteImage(index);
              },
            ),
          );
        },
      ),
    );
  }
}
