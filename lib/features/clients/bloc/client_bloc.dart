import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  List<Client> _clients = [];

  ClientBloc() : super(ClientsLoading()) {
    on<LoadClients>((event, emit) async {
      emit(ClientsLoading());
      if (event.rechercheClient.isEmpty) {
        _clients = await DatabaseHelper.instance.getClientsByArchiver(false);
      } else {
        _clients =
            await DatabaseHelper.instance.searchClients(event.rechercheClient);
      }
      _clients.sort((a, b) =>
          a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      emit(ClientsLoaded(List.from(_clients)));
    });

    on<SearchForTransfert>((event, emit) async {
      emit(ClientsLoading());

      _clients = await DatabaseHelper.instance
          .searchClients(event.rechercheClient, limit: 3);
      _clients.sort((a, b) =>
          a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      emit(ClientsLoaded(List.from(_clients)));
    });

    on<AddClient>((event, emit) async {
      emit(ClientsLoading());
      await DatabaseHelper.instance.insertClient(event.client.toJson());
      _clients = await DatabaseHelper.instance.getClientsByArchiver(false);
      _clients.sort((a, b) =>
          a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      synchroNavigatorKey.currentContext!
          .read<SyncBloc>()
          .add(LoadDatabaseStats());
      emit(ClientsLoaded(List.from(_clients)));
    });

    on<UpdateClient>((event, emit) async {
      emit(ClientsLoading());
      await DatabaseHelper.instance
          .updateClient(event.client.id!, event.client.toJson());
      _clients = await DatabaseHelper.instance.getClientsByArchiver(false);
      _clients.sort((a, b) =>
          a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      synchroNavigatorKey.currentContext!
          .read<SyncBloc>()
          .add(LoadDatabaseStats());
      emit(ClientsLoaded(List.from(_clients)));
    });
    on<DeleteClient>((event, emit) async {
      emit(ClientsLoading());
      await DatabaseHelper.instance.deleteDossier(event.client.id!);

      final dossiers =
          await DatabaseHelper.instance.getDossiersByClient(event.client.id!);

      for (var dossier in dossiers) {
        await DatabaseHelper.instance.deleteIteration(dossier.id!);
        final iterations =
            await DatabaseHelper.instance.listIterationsByDossier(dossier.id!);
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
      }

      await DatabaseHelper.instance.deleteClient(event.client.id!);
      synchroNavigatorKey.currentContext!
          .read<SyncBloc>()
          .add(LoadDatabaseStats());

      _clients = await DatabaseHelper.instance.getClientsByArchiver(false);
      _clients.sort((a, b) =>
          a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
      emit(ClientsLoaded(List.from(_clients)));
    });
  }
}
