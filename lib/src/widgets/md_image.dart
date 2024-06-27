import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../md_framework.dart';

class MDImage extends StatefulWidget {
  final String fileId;

  final BoxFit fit;
  final double? width, height;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Alignment alignment;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final BoxDecoration? decoration;

  const MDImage({
    Key? key,
    required this.fileId,
    this.width = 50,
    this.height = 50,
    this.errorBuilder,
    this.frameBuilder,
    this.loadingWidget,
    this.errorWidget,
    this.decoration,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  State<MDImage> createState() => _MDImageState();
}

class _MDImageState extends State<MDImage> {
  late Future<File> fileFuture;

  @override
  void initState() {
    super.initState();
    fileFuture = fetchFile();
  }

  Future<File> fetchFile() async {
    Directory? dir2 = await getDownloadsDirectory();
    Directory dir = Directory("${dir2!.path}/Media");
    if (!dir.existsSync()) {
      dir.createSync();
    }

    // Retrieve a list of all files in the directory
    List<FileSystemEntity> fileList = dir.listSync();

    // Iterate through the files and check if any match the desired files name
    String? fileId = widget.fileId;
    File? file;
    for (FileSystemEntity entity in fileList) {
      // Check if the files name matches without relying on extension
      if (entity is File && entity.path.contains("/$fileId.")) {
        file = File(entity.path);
        break;
      }
    }

    file = file ?? await MDRepo().downloadFile(fileId: fileId);
    if (file == null) {
      throw Exception('File not found');
    }
    return file;
  }

  Future<File> checkImage() async {
    Directory? dir2 = await getDownloadsDirectory();
    Directory dir = Directory("${dir2!.path}/Media");
    if (!dir.existsSync()) {
      dir.createSync();
    }
    bool value =
        await MDRepo().isImageCorrupted("${dir.path}/${widget.fileId}.jpg");
    File file;
    if (value) {
      try {
        try {
          File("${dir.path}/${widget.fileId}.jpg").delete();
        } catch (_) {}
        file = await MDRepo().downloadFile(fileId: widget.fileId);
        return file;
      } catch (e) {
        throw Exception('Error downloading file: $e');
      }
    } else {
      file = File("${dir.path}/${widget.fileId}.jpg");
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: fileFuture,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // throw Exception('Error downloading file: ${snapshot.error}');
          return widget.errorWidget ??
              Center(child: Text("Error: ${snapshot.error}"));

        } else {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: widget.decoration == null
                ? BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(snapshot.data!),
                      fit: widget.fit,
                      alignment: widget.alignment,
                    ),
                  )
                : widget.decoration!.copyWith(
                    image: DecorationImage(
                      image: FileImage(snapshot.data!),
                      fit: widget.fit,
                      alignment: widget.alignment,
                    ),
                  ),
          );
        }
      },
    );
  }
}
