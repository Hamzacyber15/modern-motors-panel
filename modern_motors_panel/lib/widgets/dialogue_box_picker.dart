// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/attachment_model.dart';
import 'package:modern_motors_panel/widgets/pdf/pdf_viewer.dart';
import 'package:modern_motors_panel/widgets/picker/camera_view.dart';

class DialogueBoxPicker extends StatefulWidget {
  final Function onFilesPicked;
  final bool? oneAttachment;
  final bool? uploadDocument;
  final bool? showOldRow;
  const DialogueBoxPicker({
    required this.onFilesPicked,
    this.oneAttachment = false,
    this.uploadDocument = true,
    this.showOldRow = true,
    super.key,
  });

  @override
  State<DialogueBoxPicker> createState() => _DialogueBoxPickerState();
}

class _DialogueBoxPickerState extends State<DialogueBoxPicker> {
  List<AttachmentModel> displayPicture = [];
  bool loading = false;

  void _takePhoto(Function setState) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    XFile? file = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return CameraView(cameraAllowed: true, videoAllowed: false);
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
      displayPicture.add(
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
      processFiles();
    }
    //processFiles();
  }

  void _pickImageFromGallery(Function sState) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      //allowedExtensions: widget.allowedExtensions,
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
        displayPicture.add(
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
    setState(() {});
    processFiles();
  }

  void addFile(Function setState) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
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
        if (displayPicture.isEmpty) {
          displayPicture.add(
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
        } else {
          if (mounted) {
            Constants.showMessage(
              context,
              "More than 1 attachment cannot be uploaded",
            );
          }
        }
      }
    }
    processFiles();
  }

  Widget _buildPlatformAwareImage(AttachmentModel item) {
    // final isPdf = item.attachmentType.toLowerCase() == 'pdf';
    // if (isPdf) {
    //   return GestureDetector(
    //     onTap: () {
    //       if (isPdf) {
    //         if (item.attachmentType.isEmpty) {
    //           return;
    //         }
    //         AttachmentModel attachment = item;
    //         if (attachment.bytes == null) return;
    //         Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    //           return PDFViewer(attachment: attachment);
    //         }));
    //       } else {
    //         // Could open image preview if needed
    //       }
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.all(5.0),
    //       child: ClipRRect(
    //           borderRadius: BorderRadius.circular(10),
    //           child:
    //               //  isPdf
    //               //     ?
    //               Container(
    //             width: 100,
    //             height: 140,
    //             color: Colors.grey.shade200,
    //             child: Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: const [
    //                   Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
    //                   Text("PDF",
    //                       style: TextStyle(fontWeight: FontWeight.bold)),
    //                 ],
    //               ),
    //             ),
    //           )
    //           //.. :
    //           // _buildPlatformAwareImage(item),
    //           ),
    //     ),
    //   );
    // }
    // Try network URL first if available
    if (item.url.isNotEmpty) {
      return kIsWeb
          ? Image.network(item.url, height: 120, width: 120, fit: BoxFit.cover)
          : Image.file(
              File(item.url),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            );
    }

    // Fallback to bytes if available
    if (item.bytes != null) {
      return Image.memory(
        item.bytes!,
        height: 120,
        width: 120,
        fit: BoxFit.cover,
      );
    }

    // Fallback to attachment type if available
    if (item.attachmentType.isNotEmpty) {
      return kIsWeb
          ? Image.network(
              item.attachmentType,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            )
          : Image.file(
              File(item.attachmentType),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            );
    }

    // Default fallback image
    return Image.asset(
      'assets/images/logo.png',
      height: 120,
      width: 120,
      fit: BoxFit.cover,
    );
  }

  void processFiles() async {
    widget.onFilesPicked(displayPicture);
  }

  // Widget _buildPdfThumbnail() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
  //         Text("PDF", style: TextStyle(fontSize: 10)),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildErrorWidget() {
    return Center(child: Text("More Than 1 image cannot be uploaded"));
  }

  // Widget _buildPlaceholderWidget() {
  //   return Center(
  //     child: Icon(Icons.image, color: Colors.grey),
  //   );
  // }

  // String _getImageUrlFromBytes(Uint8List bytes) {
  //   // Convert bytes to data URL for web
  //   if (kIsWeb) {
  //     return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  //   }
  //   // For mobile, we should have either URL or bytes saved to file
  //   return '';
  // }

  // void _removeImage(AttachmentModel attachment) {
  //   setState(() {
  //     displayPicture.remove(attachment);
  //   });
  //   processFiles();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton.icon(
                //       icon: Icon(Icons.camera_alt),
                //       label: Text("Take Photo"),
                //       onPressed: () => _takePhoto(setState),
                //     ),
                //     ElevatedButton.icon(
                //       icon: Icon(Icons.photo_library),
                //       label: Text("Choose from Gallery"),
                //       onPressed: () => _pickImageFromGallery(setState),
                //     ),
                //   ],
                // ),
                !widget.showOldRow!
                    ? Row(
                        children: [
                          // Camera Button
                          Expanded(
                            child: _buildCompactButton(
                              context: context,
                              icon: Icons.camera_alt_outlined,
                              label: "Camera",
                              onPressed: () => _takePhoto(setState),
                              isPrimary: false,
                            ),
                          ),
                          SizedBox(width: 8),
                          // Gallery Button
                          Expanded(
                            child: _buildCompactButton(
                              context: context,
                              icon: Icons.photo_library_outlined,
                              label: "Gallery",
                              onPressed: () => _pickImageFromGallery(setState),
                              isPrimary: true,
                            ),
                          ),
                          if (widget.uploadDocument!) ...[
                            SizedBox(width: 8),
                            // Document Button
                            Expanded(
                              child: _buildCompactButton(
                                context: context,
                                icon: Icons.description_outlined,
                                label: "Document",
                                onPressed: () => addFile(setState),
                                isPrimary: true,
                              ),
                            ),
                          ],
                        ],
                      )
                    : Row(
                        children: [
                          // Camera Button
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: FilledButton.tonalIcon(
                                icon: Icon(Icons.camera_alt_outlined, size: 20),
                                label: Text("Camera"),
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLow,
                                ),
                                onPressed: () => _takePhoto(setState),
                              ),
                            ),
                          ),

                          // Gallery Button
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: FilledButton.icon(
                                icon: Icon(
                                  Icons.photo_library_outlined,
                                  size: 20,
                                ),
                                label: Text("Gallery"),
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                                onPressed: () =>
                                    _pickImageFromGallery(setState),
                              ),
                            ),
                          ),
                          if (widget.uploadDocument!)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: FilledButton.icon(
                                  icon: Icon(
                                    Icons.document_scanner_sharp,
                                    size: 20,
                                  ),
                                  label: Text("Document"),
                                  style: FilledButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                  onPressed: () => addFile(setState),
                                ),
                              ),
                            ),
                        ],
                      ),
                const SizedBox(height: 15),
                if (loading) CircularProgressIndicator(),
                //Text(displayPicture.length.toString()),
                if (displayPicture.isNotEmpty)
                  Column(
                    children: [
                      if (displayPicture.isNotEmpty)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 150,
                            minWidth: double.infinity,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 8,
                              runSpacing: 8,
                              children: displayPicture.map((item) {
                                final isPdf =
                                    item.attachmentType.toLowerCase() == 'pdf';

                                return SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    children: [
                                      // Image/PDF Display
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: isPdf
                                              ? InkWell(
                                                  onTap: () {
                                                    AttachmentModel attachment =
                                                        item;
                                                    if (attachment.bytes ==
                                                        null) {
                                                      return;
                                                    }

                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) {
                                                          return PDFViewer(
                                                            attachment:
                                                                attachment,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    color: Colors.grey.shade200,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                            Icons
                                                                .picture_as_pdf,
                                                            size: 40,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                            "PDF",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : _buildPlatformAwareImage(item),
                                        ),
                                      ),

                                      // Delete Button
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              displayPicture.remove(item);
                                            });
                                            processFiles();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 3,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                // if (displayPicture.length == 1) _buildErrorWidget()

                // SizedBox(
                //   height: 150,
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     physics: const ClampingScrollPhysics(),
                //     scrollDirection: Axis.horizontal,
                //     itemCount: displayPicture.length,
                //     itemBuilder: (context, index) {
                //       final item = displayPicture[index];
                //       final isPdf =
                //           item.attachmentType.toLowerCase() == 'pdf';

                //       return Stack(
                //         children: [
                //           // Padding(
                //           //   padding: const EdgeInsets.all(5.0),
                //           //   child: ClipRRect(
                //           //     borderRadius: BorderRadius.circular(10),
                //           //     child: _buildPlatformAwareImage(item),
                //           //   ),
                //           // ),
                //           GestureDetector(
                //             onTap: () {
                //               if (isPdf) {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (_) =>
                //                             // PdfViewerWidget(
                //                             //   bytes: item.bytes,
                //                             // ),
                //                             Container()
                //                         // Container()),
                //                         //PdfView(url: item.url)
                //                         ));
                //               } else {
                //                 // Could open image preview if needed
                //               }
                //             },
                //             child: Padding(
                //               padding: const EdgeInsets.all(5.0),
                //               child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(10),
                //                 child: isPdf
                //                     ? Container(
                //                         width: 100,
                //                         height: 140,
                //                         color: Colors.grey.shade200,
                //                         child: Center(
                //                           child: Column(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                             children: const [
                //                               Icon(Icons.picture_as_pdf,
                //                                   size: 40,
                //                                   color: Colors.red),
                //                               Text("PDF",
                //                                   style: TextStyle(
                //                                       fontWeight:
                //                                           FontWeight.bold)),
                //                             ],
                //                           ),
                //                         ),
                //                       )
                //                     : _buildPlatformAwareImage(item),
                //               ),
                //             ),
                //           ),
                //           Positioned(
                //             top: 0,
                //             right: 0,
                //             child: GestureDetector(
                //               onTap: () {
                //                 setState(() {
                //                   displayPicture.removeAt(index);
                //                 });
                //               },
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   color: Colors.red,
                //                   shape: BoxShape.circle,
                //                   boxShadow: [
                //                     BoxShadow(
                //                       color: Colors.black.withOpacity(0.3),
                //                       blurRadius: 3,
                //                       spreadRadius: 1,
                //                     ),
                //                   ],
                //                 ),
                //                 padding: const EdgeInsets.all(4),
                //                 child: const Icon(
                //                   Icons.close,
                //                   color: Colors.white,
                //                   size: 16,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildCompactButton({
  required BuildContext context,
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
  required bool isPrimary,
}) {
  return FilledButton.icon(
    icon: Icon(icon, size: 18),
    label: Text(
      label,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    ),
    style: FilledButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: isPrimary
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundColor: isPrimary
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      minimumSize: Size(0, 44),
    ),
    onPressed: onPressed,
  );
}
