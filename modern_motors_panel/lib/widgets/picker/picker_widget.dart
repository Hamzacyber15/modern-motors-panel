import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/widgets/picker/camera_view.dart';

enum Menu { preview, share, getLink, remove, download }

class PickerWidget extends StatefulWidget {
  final bool cameraAllowed;
  final bool galleryAllowed;
  final bool videoAllowed;
  final bool filesAllowed;
  final bool multipleAllowed;
  final bool memoAllowed;
  final List<AttachmentModel> attachments;
  final Widget child;
  final Function onFilesPicked;
  final List<String> allowedExtensions;
  const PickerWidget({
    required this.cameraAllowed,
    required this.galleryAllowed,
    required this.videoAllowed,
    required this.filesAllowed,
    required this.multipleAllowed,
    required this.memoAllowed,
    required this.attachments,
    required this.child,
    required this.onFilesPicked,
    this.allowedExtensions = const [],
    super.key,
  });

  @override
  State<PickerWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  List<AttachmentModel> attachments = [];

  @override
  void initState() {
    attachments = widget.attachments;
    super.initState();
  }

  void showCamera() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    XFile? file = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return CameraView(
            cameraAllowed: widget.cameraAllowed,
            videoAllowed: widget.videoAllowed,
          );
        },
      ),
    );
    if (file != null) {
      String path = '';
      File? attchFile;
      Uint8List? bytes;
      // ignore: unnecessary_null_comparison
      if (!kIsWeb && file.path != null) {
        path = file.path;
        attchFile = File(path);
      }
      String ext = file.name.split('.').last;
      if (kIsWeb) {
        bytes = await file.readAsBytes();
      }
      attachments.add(
        AttachmentModel(
          id: '',
          refID: "",
          refType: "",
          attachmentType: ext,
          url: path,
          duration: 0,
          file: attchFile,
          bytes: bytes,
        ),
      );
    }
    processFiles();
  }

  // void addMemo() async {
  //   AttachmentModel1? audioFile;
  //   if (Constants.bigScreen) {
  //     audioFile = await showGeneralDialog(
  //       transitionDuration: const Duration(milliseconds: 500),
  //       barrierDismissible: true,
  //       barrierLabel: "",
  //       context: context,
  //       pageBuilder: (_, __, ___) {
  //         return const SideBar(child: RecordAudio());
  //       },
  //     );
  //   } else {
  //     audioFile =
  //         await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //       return const RecordAudio();
  //     }));
  //   }
  //   if (audioFile != null) {
  //     attachments.add(audioFile);
  //   }
  //   processFiles();
  // }

  void addFile(FileType ft) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.multipleAllowed,
      type: ft,
      allowedExtensions: widget.allowedExtensions,
    );
    if (result != null) {
      for (PlatformFile file in result.files) {
        String path = '';
        File? attchFile;
        Uint8List? bytes;
        if (!kIsWeb && file.path != null) {
          path = file.path!;
          attchFile = File(path);
        }
        String ext = '';
        if (!kIsWeb && file.extension != null) {
          ext = file.extension!;
        }
        if (ext.isEmpty) {
          ext = file.name.split('.').last;
        }
        if (kIsWeb) {
          bytes = file.bytes;
        }
        attachments.add(
          AttachmentModel(
            id: '',
            refID: "",
            refType: "",
            attachmentType: ext,
            url: path,
            duration: 0,
            file: attchFile,
            bytes: bytes,
          ),
        );
      }
    }
    processFiles();
  }

  void processFiles() async {
    widget.onFilesPicked(attachments);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: widget.child,
      onSelected: (String item) {
        if (item == "camera") {
          showCamera();
        } else if (item == "photo&video") {
          addFile(FileType.media);
        } else if (item == "photo") {
          addFile(FileType.image);
        } else if (item == "video") {
          addFile(FileType.video);
        } else if (item == "documents") {
          addFile(FileType.any);
        }
        // else if (item == "memo") {
        //   addMemo();
        // }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (widget.cameraAllowed)
          const PopupMenuItem<String>(
            value: "camera",
            child: ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text('Camera'),
            ),
          ),
        if (widget.galleryAllowed && widget.videoAllowed)
          const PopupMenuItem<String>(
            value: "photo&video",
            child: ListTile(
              leading: Icon(Icons.browse_gallery_outlined),
              title: Text('Photo & Video Library'),
            ),
          ),
        if (widget.galleryAllowed && !widget.videoAllowed)
          const PopupMenuItem<String>(
            value: "photo",
            child: ListTile(
              leading: Icon(Icons.photo_album_rounded),
              title: Text('Photo Library'),
            ),
          ),
        if (!widget.galleryAllowed && widget.videoAllowed)
          const PopupMenuItem<String>(
            value: "video",
            child: ListTile(
              leading: Icon(Icons.video_collection_rounded),
              title: Text('Video Library'),
            ),
          ),
        if (widget.filesAllowed) const PopupMenuDivider(),
        if (widget.filesAllowed)
          PopupMenuItem<String>(
            value: "documents",
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text('document'.tr()),
            ),
          ),
        if (widget.memoAllowed) const PopupMenuDivider(),
        if (widget.memoAllowed)
          const PopupMenuItem<String>(
            value: "memo",
            child: ListTile(
              leading: Icon(Icons.audiotrack_rounded),
              title: Text('Record Memo'),
            ),
          ),
      ],
    );
  }
}
