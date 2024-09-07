// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'dart:html' as html;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImagePicker{


/// Picks multiple images and returns their URLs (for web) or file paths (for mobile).
Future<List<String>> pickImages() async {
  final ImagePicker picker = ImagePicker();
  List<String> imageUrls = [];

  if (kIsWeb) {
    final fileInput = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..multiple = true;
    fileInput.click();

   
    final completer = Completer<List<String>>();
    fileInput.onChange.listen((e) async {
      final files = fileInput.files;
      if (files != null) {
        List<String> base64Images = [];
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((e) {
            base64Images.add(reader.result as String);
            if (base64Images.length == files.length) {
              completer.complete(base64Images);
            }
          });
        }
      } else {
        completer.complete([]);
      }
    });
    return completer.future;
  } else {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      return pickedFiles.map((file) => file.path).toList();
    } else {
      return [];
    }
  }
}

}



class CustomHorizontalImageScroller extends StatefulWidget {
  final List<String>? webImageUrls; 
  final List<XFile>? mobileImageFiles; 

  const CustomHorizontalImageScroller({
    super.key,
    this.webImageUrls,
    this.mobileImageFiles,
  });

  @override
  _CustomHorizontalImageScrollerState createState() => _CustomHorizontalImageScrollerState();
}

class _CustomHorizontalImageScrollerState extends State<CustomHorizontalImageScroller> {
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debugging information to verify what data is present
  
    
    return kIsWeb
        ? (widget.webImageUrls == null || widget.webImageUrls!.isEmpty
            ? const Center(child: Text('No images selected.'))
            : Scrollbar(
                controller: _scrollController,
                trackVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: widget.webImageUrls!.map((url) {
                      return _buildImageWithDeleteButton(
                        url: url,
                        isWeb: true,
                        onDelete: () {
                          // Handle delete action for web images
                          setState(() {
                            widget.webImageUrls!.remove(url);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ))
        : (widget.mobileImageFiles == null
            ? const Center(child: Text('No images selected.'))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.mobileImageFiles!.map((file) {
                    return _buildImageWithDeleteButton(
                      url: file.path,
                      isWeb: false,
                      onDelete: () {
                        // Handle delete action for mobile images
                        setState(() {
                          widget.mobileImageFiles!.remove(file);
                        });
                      },
                    );
                  }).toList(),
                ),
              ));
  }

  Widget _buildImageWithDeleteButton({
    required String url,
    required bool isWeb,
    required VoidCallback onDelete,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: [
          // The image itself
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              height: 200,
              width: 100,
              child: isWeb
                  ? Image.network(url, fit: BoxFit.cover)
                  : Image.file(File(url), fit: BoxFit.cover),
            ),
          ),
          // Delete button overlay
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                color: Colors.red.withOpacity(0.6),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

