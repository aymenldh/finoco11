import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dossier_event.dart';
import 'dossier_state.dart';

class DossierBloc extends Bloc<DossierEvent, DossierState> {
  List<Dossier> _dossiers = [];

  DossierBloc() : super(DossiersLoading()) {
    on<LoadDossiers>((event, emit) async {
      emit(DossiersLoading());
      _dossiers = await DatabaseHelper.instance
          .getDossiersByClientAndStatus(event.idClient, event.statusFolder);
      emit(DossiersLoaded(List.from(_dossiers)));
    });

    on<LoadDossierForTransfert>((event, emit) async {
      emit(DossiersLoading());
      _dossiers =
          await DatabaseHelper.instance.getDossiersByClient(event.idClient);
      emit(DossiersLoaded(List.from(_dossiers)));
    });

    on<AddDossier>((event, emit) async {
      emit(DossiersLoading());
      await DatabaseHelper.instance.insertDossier(event.dossier.toJson());
      _dossiers = await DatabaseHelper.instance
          .getDossiersByClientAndStatus(event.dossier.idClient!, true);
      emit(DossiersLoaded(List.from(_dossiers)));
    });

    on<UpdateDossier>((event, emit) async {
      emit(DossiersLoading());
      await DatabaseHelper.instance
          .updateDossier(event.dossier.id!, event.dossier.toJson());
      _dossiers = await DatabaseHelper.instance
          .getDossiersByClientAndStatus(event.dossier.idClient!, true);
      emit(DossiersLoaded(List.from(_dossiers)));
    });

    on<DeleteDossier>((event, emit) async {
      emit(DossiersLoading());
      final iterations = await DatabaseHelper.instance
          .listIterationsByDossier(event.dossier.id!);
      for (var iteration in iterations) {
        await DatabaseHelper.instance.deleteIteration(iteration.id!);
        var attachements = await DatabaseHelper.instance
            .getAttachmentsByIdIteration(iteration.id!);
        for (var attachement in attachements) {
          final ref =
              FirebaseStorage.instance.ref('uploads/${attachement.distName}');
          await ref.delete();
          await DatabaseHelper.instance.deleteAttachment(attachement.id!);
        }
      }
      await DatabaseHelper.instance.deleteDossier(event.dossier.id!);
      synchroNavigatorKey.currentContext!
          .read<SyncBloc>()
          .add(LoadDatabaseStats());
      _dossiers = await DatabaseHelper.instance
          .getDossiersByClientAndStatus(event.dossier.idClient!, true);
      emit(DossiersLoaded(List.from(_dossiers)));
    });

    on<OuvrirDossier>((event, emit) async {
      emit(DossiersLoading());
      await DatabaseHelper.instance
          .updateDossier(event.dossier.id!, event.dossier.toJson());
      _dossiers = await DatabaseHelper.instance
          .getDossiersByClientAndStatus(event.dossier.idClient!, false);
      emit(DossiersLoaded(List.from(_dossiers)));
    });
  }
}
