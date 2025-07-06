import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mentorful/main.dart';

const int MAX_IMG_SIZE = 5 * 1024 * 1024; // 5 MB

Future<void> savePhoto(BuildContext context) async {
  File? img;
  XFile? imgData;

  final cameras = await availableCameras();
  final firstCam = cameras.first;

  CameraController controller = CameraController(firstCam, ResolutionPreset.medium);
  Future<void> initControllerFuture = controller.initialize();

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool processingImg = false;

          return DraggableScrollableSheet(
            initialChildSize: 1,
            maxChildSize: 1,
            minChildSize: 0.8,
            expand: true,
            shouldCloseOnMinExtent: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                // padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Column(
                      children: [
                        PreferredSize(
                          preferredSize: Size.fromHeight(80),
                          child: AppBar(
                            centerTitle: true,
                            toolbarHeight: 80,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            elevation: 4,
                            shadowColor: Color.fromRGBO(0, 0, 0, 0.5),
                            leading: Padding(
                              padding: EdgeInsets.only(top: 35, bottom: 5),
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(top: 50, bottom: 15),
                              child: Text("Mentorful.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          child: FutureBuilder(
                            future: initControllerFuture,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  return Center(child: CircularProgressIndicator());
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return const Text("Error loading camera");
                                  }

                                  if (imgData != null) {
                                    if (processingImg) {
                                      return Stack(
                                        children: [
                                          Center(child: CircularProgressIndicator()),
                                          Image.file(img!),
                                        ]
                                      );
                                    }
                                    return Image.file(img!);
                                  }
                                  return CameraPreview(controller);
                              }
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            imgData == null
                                ? IconButton(
                                    onPressed: () async {
                                      final imgSubmitted = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if (imgSubmitted == null) return;
                                      if (await File(imgSubmitted.path).length() > MAX_IMG_SIZE) {
                                        _showSizeError(context);
                                        return;
                                      }

                                      if (context.mounted) {
                                        setState(() {
                                          imgData = imgSubmitted;
                                          img = File(imgSubmitted.path);
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.photo_outlined),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        controller = CameraController(firstCam, ResolutionPreset.medium);
                                        await controller.initialize();
                                        setState(() {
                                          imgData = null;
                                          img = null;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.close, color: Colors.red),
                                  ),
                            imgData == null
                                ? FloatingActionButton(
                                    onPressed: () async {
                                      try {
                                        await initControllerFuture;
                                        final imgTaken = await controller.takePicture();
                                        if (context.mounted) {
                                          controller.dispose();
                                          setState(() {
                                            imgData = imgTaken;
                                            img = File(imgTaken.path);
                                          });
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    shape: CircleBorder(side: BorderSide(color: Colors.white, width: 5)),
                                    child: CircleAvatar(backgroundColor: Colors.white, radius: 20),
                                  ) : SizedBox(width: 50),
                            imgData != null ? IconButton(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        setState(() {
                                          processingImg = true;
                                        });

                                        var request = http.MultipartRequest('POST', Uri.parse('http://172.20.10.2:8000/rating/'));
                                        request.files.add(await http.MultipartFile.fromPath('image', img!.path));
                                        var res = await request.send();
                                        print(res);

                                        setState(() {
                                          processingImg = false;
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: Icon(Icons.check, color: Colors.lightGreen),
                                  ) : SizedBox(width: 50),
                          ],
                        ),
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
