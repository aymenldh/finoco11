// bloc/Client_event.dart
import 'package:finoco/core/models/client.dart';

abstract class ClientEvent {}

class LoadClients extends ClientEvent {
  final String rechercheClient;

  LoadClients(this.rechercheClient);
}

class SearchForTransfert extends ClientEvent {
  final String rechercheClient;

  SearchForTransfert(this.rechercheClient);
}

class AddClient extends ClientEvent {
  final Client client;

  AddClient(this.client);
}

class UpdateClient extends ClientEvent {
  final Client client;

  UpdateClient(this.client);
}

class DeleteClient extends ClientEvent {
  final Client client;

  DeleteClient(this.client);
}
