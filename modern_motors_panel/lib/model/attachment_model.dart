// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

// class AttachmentModel {
//   String id;
//   String refID;
//   String attachmentFor;
//   String attachmentType;
//   String caption;
//   String name;
//   String createdBy;
//   String url;
//   int duration;
//   DateTime createdAt;
//   File? file;
//   Uint8List? bytes;
//   AttachmentModel(
//     this.id,
//     this.refID,
//     this.attachmentFor,
//     this.attachmentType,
//     this.name,
//     this.caption,
//     this.createdBy,
//     this.url,
//     this.duration,
//     this.createdAt, {
//     this.file,
//     this.bytes,
//   });

//   factory AttachmentModel.fromFirestore(
//       DocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data();
//     Timestamp createdAt = data!['createdAt'] ?? Timestamp.now();
//     int duration = data['duration'] ?? 0;
//     return AttachmentModel(
//       doc.id,
//       data['refID'],
//       data['attachmentFor'],
//       data['attachmentType'],
//       data['name'],
//       data['caption'],
//       data['createdBy'],
//       data['url'],
//       duration,
//       createdAt.toDate(),
//     );
//   }

//   Map<String, dynamic> toFirestore(String downloadURL) {
//     return {
//       'refID': refID,
//       'attachmentFor': attachmentFor,
//       'attachmentType': attachmentType,
//       'name': name,
//       'caption': caption,
//       'createdBy': createdBy,
//       'createdAt': FieldValue.serverTimestamp(),
//       'url': downloadURL,
//       'duration': duration,
//     };
//   }

//   static Future<AttachmentModel?> getAttachmentByID(
//       String path, String id) async {
//     try {
//       return getReference(path, id).get().then((value) {
//         return AttachmentModel.fromFirestore(value);
//       });
//     } catch (e) {
//       return null;
//     }
//   }

//   static String getID(String path) {
//     return FirebaseFirestore.instance.collection(path).doc().id;
//   }

//   static DocumentReference<Map<String, dynamic>> getReference(
//       String path, String id) {
//     return FirebaseFirestore.instance.collection(path).doc(id);
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AttachmentModel {
  String id;
  String refID;
  String refType;
  String attachmentType;
  int duration;
  String url;
  String? caption;
  File? file;
  Uint8List? bytes;
  AttachmentModel({
    required this.id,
    required this.refID,
    required this.refType,
    required this.attachmentType,
    required this.duration,
    required this.url,
    this.caption = "",
    this.file,
    this.bytes,
  });

  factory AttachmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    ///int duration = data!['duration'] ?? 0;
    return AttachmentModel(
      id: doc.id,
      url: data!['url'] ?? "",
      refID: data['refID'] ?? "",
      refType: data['refType'] ?? "",
      attachmentType: data['attachmentType'] ?? "",
      duration: data['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore(String downloadURL) {
    return {
      'refID': refID,
      'refType': refType,
      'attachmentType': attachmentType,
      'duration': duration,
      'url': downloadURL,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /*
  Future<String> saveAttachment(String path, String id) async {
    try {
      bool result = await uploadToStorage();
      if (result) {
        await getReference(path, id).set(toFirestore());
        return "success";
      } else {
        return "failed";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> uploadToStorage() async {
    try {
      SettableMetadata metadata = SettableMetadata(
        customMetadata: <String, String>{
          'fileFor': attachmentFor,
        },
      );
      return FirebaseStorage.instance
          .ref()
          .child(url)
          .putFile(file!, metadata)
          .then((p0) async {
        return true;
      });
    } on FirebaseException catch (e) {
      log(e.toString());
      return false;
    }
  }
*/
  static Future<AttachmentModel?> getAttachmentByID(
    String path,
    String id,
  ) async {
    try {
      return getReference(path, id).get().then((value) {
        return AttachmentModel.fromFirestore(value);
      });
    } catch (e) {
      return null;
    }
  }

  static String getID(String path) {
    return FirebaseFirestore.instance.collection(path).doc().id;
  }

  static DocumentReference<Map<String, dynamic>> getReference(
    String path,
    String id,
  ) {
    return FirebaseFirestore.instance.collection(path).doc(id);
  }
}
