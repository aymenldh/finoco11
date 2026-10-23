import 'dart:io';

import 'package:finoco/core/models/attachements.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_event.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttachementsBloc extends Bloc<AttachementsEvent, AttachementsState> {
  List<Attachements> _attachementss = [];

  AttachementsBloc() : super(AttachementssLoading()) {
    on<LoadAttachementss>((event, emit) async {
      emit(AttachementssLoading());
      if (event.idIteration == null) {
        emit(AttachementssLoaded([]));
      } else {
        _attachementss = await DatabaseHelper.instance
            .getAttachmentsByIdIteration(event.idIteration);
        emit(AttachementssLoaded(List.from(_attachementss)));
      }
    });

    on<DeleteAttachements>((event, emit) async {
      emit(AttachementssLoading());
      final ref = FirebaseStorage.instance
          .ref('uploads/${event.attachements.distName}');
      await ref.delete();
      await DatabaseHelper.instance.deleteAttachment(event.attachements.id!);
      _attachementss = await DatabaseHelper.instance
          .getAttachmentsByIdIteration(event.attachements.idIteration!);
      emit(AttachementssLoaded(List.from(_attachementss)));
    });

    on<AddAttachements>((event, emit) async {
      emit(AttachementssLoading());

      File file = File(event.filePath);
      try {
        final instant = DateTime.now().microsecondsSinceEpoch.toString() +
            event.fileName.split('.').last;
        final ref = FirebaseStorage.instance.ref('uploads/$instant');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        if (downloadUrl.isNotEmpty) {
          var att = Attachements(
              idIteration: event.idIteration,
              name: event.fileName,
              distName: instant,
              type: event.filePath.split(".").last,
              url: downloadUrl);
          await DatabaseHelper.instance.insertAttachment(att.toJson());
        } else {
          emit(AttachementssError());
        }
      } on FirebaseException catch (e) {
        emit(AttachementssError());
      }
      _attachementss = await DatabaseHelper.instance
          .getAttachmentsByIdIteration(event.idIteration);
      emit(AttachementssLoaded(List.from(_attachementss)));
    });
  }
}
