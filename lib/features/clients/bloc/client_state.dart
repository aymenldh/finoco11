// bloc/Client_state.dart

import 'package:finoco/core/models/client.dart';

abstract class ClientState {}

class ClientsLoading extends ClientState {}

class ClientsLoaded extends ClientState {
  final List<Client> client;

  ClientsLoaded(this.client);
}

class ClientsError extends ClientState {}
