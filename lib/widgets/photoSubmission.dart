import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorful/main.dart';

const int MAX_IMG_SIZE = 5 * 1024 * 1024; // 5 MB

Future<void> savePhoto(BuildContext context) async {
  File? img;
  XFile? imgData;

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.8,
            minChildSize: 0.25,
            expand: false,
            shouldCloseOnMinExtent: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          height: img == null ? 250 : null,
                          child: img != null
                              ? Stack(
                                  children: [
                                    ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(img!)),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black.withValues(alpha: 0.5),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              img = null;
                                            });
                                          },
                                          icon: Icon(Icons.close, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Text("Image preview will be displayed here"),
                        ),
                        img != null ? SizedBox(height: 18) : Container(),
                        img != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context).colorScheme.secondary,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Uploading Photo"),
                                            content: Text("You will be navigated back once the photo is uploaded"),
                                          );
                                        },
                                      );

                                      final savedImg = await img!.copy(
                                        "${appDir.path}/submitted_photo_${DateTime.now().toString()}.jpg",
                                      );
                                      prefs.setString("savedImg", savedImg.path);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.upload_outlined),
                                    label: Text("Upload"),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 36),
                        IconButton(
                          onPressed: () async {
                            final returnedImg = await ImagePicker().pickImage(source: ImageSource.camera);

                            if (returnedImg == null) return;
                            if (await File(returnedImg.path).length() > MAX_IMG_SIZE) _showSizeError(context);

                            setState(() {
                              imgData = returnedImg;
                              img = File(returnedImg.path);
                            });
                          },
                          icon: Icon(Icons.photo_camera_outlined),
                        ),
                        SizedBox(height: 18),
                        IconButton(
                          onPressed: () async {
                            final returnedImg = await ImagePicker().pickImage(source: ImageSource.gallery);

                            if (returnedImg == null) return;
                            if (await File(returnedImg.path).length() > MAX_IMG_SIZE) _showSizeError(context);

                            setState(() {
                              imgData = returnedImg;
                              img = File(returnedImg.path);
                            });
                          },
                          icon: Icon(Icons.photo_outlined),
                        ),
                        SizedBox(height: 36),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

void _showSizeError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("File size exceeds 5 MB. Please select a smaller photo.", style: TextStyle(color: Colors.white)),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}
