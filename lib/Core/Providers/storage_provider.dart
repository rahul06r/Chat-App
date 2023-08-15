import 'dart:io';

import 'package:chat_app/Core/Providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../TypeDef/failure.dart';
import '../TypeDef/typedef.dart';

final firebaseStorageProvider = Provider(
    (ref) => StorageRepository(firebaseStorage: ref.watch(storageProvider)));

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  //
  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
    // required Uint8List? webFile,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask;
      // if (kIsWeb) {
      //   uploadTask = ref.putData(webFile!);
      // } else {
      uploadTask = ref.putFile(file!);
      // }

      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
