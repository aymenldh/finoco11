import 'dart:io';

import 'package:finoco/core/models/attachements.dart';
import 'package:finoco/core/models/iteration.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'iteration_event.dart';
import 'iteration_state.dart';

class IterationBloc extends Bloc<IterationEvent, IterationState> {
  List<Iteration> _iterations = [];

  IterationBloc() : super(IterationsLoading()) {
    on<LoadIterations>((event, emit) async {
      emit(IterationsLoading());
      _iterations = await DatabaseHelper.instance
          .listIterationsByDossierAndType(
              event.idDossier, event.typeTransaction);
      emit(IterationsLoaded(List.from(_iterations)));
    });

    on<TransfereIteration>((event, emit) async {
      emit(IterationsLoading());
      final Iteration iteration =
          await DatabaseHelper.instance.getIterationById(event.idIteration);
      iteration.idFolder = event.idDossier;
      iteration.type = event.type;
      DatabaseHelper.instance
          .updateIteration(event.idIteration, iteration.toMap());
      emit(IterationsLoaded(List.from(_iterations)));
    });

    on<AddIteration>((event, emit) async {
      emit(IterationsLoading());
      int id = await DatabaseHelper.instance
          .insertIteration(event.iteration.toMap());
      for (var e in event.attachements) {
        File file = File(e.url!);
        try {
          final instant = DateTime.now().microsecondsSinceEpoch.toString() +
              e.url!.split('.').last;
          final ref = FirebaseStorage.instance.ref('uploads/$instant');
          await ref.putFile(file);
          final downloadUrl = await ref.getDownloadURL();
          if (downloadUrl.isNotEmpty) {
            var att = Attachements(
                idIteration: id,
                name: e.name,
                distName: instant,
                type: instant.split(".").last,
                url: downloadUrl);
            DatabaseHelper.instance.insertAttachment(att.toJson());
          }
        } on FirebaseException catch (e) {
          // final instant =
          //     DateTime.now().microsecondsSinceEpoch.toString() + '.log';
          // // Specify the file path
          // final directory = await getApplicationDocumentsDirectory();

          // final filePath = '${directory.path}/example.txt';

          // final file = File(filePath);

          // // Write the text to the file
          // await file.writeAsString(text);
          // final ref = FirebaseStorage.instance.ref('logs/$instant');
        }
      }
      _iterations = await DatabaseHelper.instance
          .listIterationsByDossierAndType(
              event.iteration.idFolder!, event.iteration.type!.name);
      emit(IterationsLoaded(List.from(_iterations)));
    });

    on<UpdateIteration>((event, emit) async {
      emit(IterationsLoading());
      var attachements = await DatabaseHelper.instance
          .getAttachmentsByIdIteration(event.iteration.id!);
      for (var attachement in attachements) {
        if (event.attachements
            .where((element) => element.id == attachement.id)
            .isEmpty) {
          final ref =
              FirebaseStorage.instance.ref('uploads/${attachement.distName}');
          await ref.delete();
          await DatabaseHelper.instance.deleteAttachment(attachement.id!);
        }
      }
      // event.attachements
      //     .where((element) => element.id == null)
      //     .forEach((element) async {
      //   await DatabaseHelper.instance.insertAttachment(element.toJson());
      // });

      await DatabaseHelper.instance
          .updateIteration(event.iteration.id!, event.iteration.toMap());
      _iterations = await DatabaseHelper.instance
          .listIterationsByDossierAndType(
              event.iteration.idFolder!, event.iteration.type!.name);
      emit(IterationsLoaded(List.from(_iterations)));
    });

    on<DeleteIteration>((event, emit) async {
      emit(IterationsLoading());
      var attachements = await DatabaseHelper.instance
          .getAttachmentsByIdIteration(event.iteration.id!);
      for (var attachement in attachements) {
        final ref =
            FirebaseStorage.instance.ref('uploads/${attachement.distName}');
        await ref.delete();
        await DatabaseHelper.instance.deleteAttachment(attachement.id!);
      }

      await DatabaseHelper.instance.deleteIteration(event.iteration.id!);
      synchroNavigatorKey.currentContext!
          .read<SyncBloc>()
          .add(LoadDatabaseStats());

      _iterations = await DatabaseHelper.instance
          .listIterationsByDossierAndType(
              event.iteration.idFolder!, event.iteration.type!.name);
      emit(IterationsLoaded(List.from(_iterations)));
    });
  }
}
