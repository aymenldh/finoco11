// bloc/Attachements_state.dart

import 'package:finoco/core/models/attachements.dart';

abstract class AttachementsState {}

class AttachementssLoading extends AttachementsState {}

class AttachementssLoaded extends AttachementsState {
  final List<Attachements> attachements;

  AttachementssLoaded(this.attachements);
}

class AttachementssError extends AttachementsState {}
