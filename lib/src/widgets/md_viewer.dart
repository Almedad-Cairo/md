import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../md_framework.dart';

class MDViewer extends StatefulWidget {
  final String fileId;

  final BoxFit fit;
  final double? width, height;
  final Alignment alignment;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final bool save;

  const MDViewer({
    Key? key,
    required this.fileId,
    this.width = 50,
    this.height = 50,
    this.errorBuilder,
    this.frameBuilder,
    this.textStyle,
    this.decoration,
    this.save = false,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  State<MDViewer> createState() => _MDViewerState();
}

class _MDViewerState extends State<MDViewer> {
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

    file = file ?? await MD<MDRepo>().downloadFile(fileId: fileId);
    if (file == null) {
      throw Exception('File not found');
    }
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.save) {
          File file = await fileFuture;

          String path = '/storage/emulated/0/Tasks';

          // create a directory if not exists
          Directory dir = Directory(path);
          if (!dir.existsSync()) {
            dir.createSync();
          }

          await file.copy('$path/${file.path.split('/').last}').then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File saved successfully'),
              ),
            );


          });
          debugPrint('files path: $path/${file.path.split('/').last}');
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: widget.decoration,
        child: FutureBuilder<File>(
          future: fileFuture,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error"));
            } else {
              return widget.save
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(snapshot.data!.path.split('/').last,
                            style: widget.textStyle ??
                                const TextStyle(fontSize: 12)),
                        // text Tap to save
                        Text('Tap to save',
                            style: widget.textStyle ??
                                const TextStyle(fontSize: 12)),
                      ],
                    )
                  : Text(snapshot.data!.path.split('/').last,
                      style: widget.textStyle ?? const TextStyle(fontSize: 12));
            }
          },
        ),
      ),
    );
  }
}
