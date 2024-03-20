import 'dart:io';

import 'package:flutter/material.dart';
import 'package:md/src/get_it_initializer.dart';
import 'package:path_provider/path_provider.dart';

import '../md/data/repo/md_repo.dart';

class MDImage extends StatefulWidget {
  final String fileId;

  final BoxFit fit;
  final double? width, height;
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
    this.decoration,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  State<MDImage> createState() => _MDImageState();
}

class _MDImageState extends State<MDImage> {
  bool isExist = false;
  bool isLoading = true;
  late File file;

  String path = "";

  @override
  void initState() {
    super.initState();
    checkImage();
  }

  Future<void> checkImage() async {
    Directory? dir2 = await getDownloadsDirectory();
    Directory dir = Directory("${dir2!.path}/Media");
    if (!dir.existsSync()) {
      dir.createSync();
    }
    path = dir.path;
    File file0 = File("$path/${widget.fileId}.jpg");
    if (file0.existsSync()) {
      setState(() {
        isExist = true;
        file = file0;
        isLoading = false;
      });
    } else {
      try {
        file = await get<MDRepo>()
            .downloadFile(fileId: widget.fileId);
        setState(() {
          isExist = true;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration == null
          ? BoxDecoration(
              image: isExist
                  ? DecorationImage(
                      image: FileImage(file),
                      fit: widget.fit,
                      alignment: widget.alignment,
                    )
                  : null,
            )
          : widget.decoration!.copyWith(
              image: isExist
                  ? DecorationImage(
                      image: FileImage(file),
                      fit: widget.fit,
                      alignment: widget.alignment,
                    )
                  : null,
            ),
      child: isExist || isLoading ? null : const Center(child: Text("Error")),
    );
  }
}
