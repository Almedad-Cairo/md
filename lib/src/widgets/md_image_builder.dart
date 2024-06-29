import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../md_framework.dart';

class MDImageBuilder extends StatefulWidget {
  final String fileId;

  // builder
  final Widget Function(BuildContext context, File file) builder;

  // loadingWidget
  final Widget? loadingWidget;

  // errorWidget
  final Widget? Function(Object error)? errorWidget;

  const MDImageBuilder({
    Key? key,
    required this.fileId,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
  }) : super(key: key);

  @override
  State<MDImageBuilder> createState() => _MDImageBuilderState();
}

class _MDImageBuilderState extends State<MDImageBuilder> {
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
        }
        if (snapshot.hasError) {
          return widget.errorWidget != null
              ? widget.errorWidget!(snapshot.error!)!
              : const Center(
                  child: Text('Error loading image'),
                );
        }
        if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!);
        }
        return const Center(
          child: Text('Error loading image'),
        );
      },
    );
  }
}
