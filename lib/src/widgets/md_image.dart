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
    fileFuture = checkImage();
  }

  Future<File> checkImage() async {
    Directory? dir2 = await getDownloadsDirectory();
    Directory dir = Directory("${dir2!.path}/Media");
    if (!dir.existsSync()) {
      dir.createSync();
    }
    File file = File("${dir.path}/${widget.fileId}.jpg");
    if (!file.existsSync()) {
      try {
        file = await MDRepo().downloadFile(fileId: widget.fileId);
      } catch (e) {
        throw Exception('Error downloading file: $e');
      }
    }
    return file;
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
