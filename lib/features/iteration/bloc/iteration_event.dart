// bloc/Iteration_event.dart
import 'package:finoco/core/models/attachements.dart';
import 'package:finoco/core/models/iteration.dart';
import 'package:finoco/core/models/type_transaction.dart';

abstract class IterationEvent {}

class LoadIterations extends IterationEvent {
  final String typeTransaction;
  final int idDossier;
  LoadIterations(this.typeTransaction, this.idDossier);
}

class TransfereIteration extends IterationEvent {
  final int idIteration;
  final int idDossier;
  final TypeTransaction type;
  TransfereIteration(this.idIteration, this.idDossier, this.type);
}

class AddIteration extends IterationEvent {
  final Iteration iteration;
  final List<Attachements> attachements;
  AddIteration(this.iteration, this.attachements);
}

class UpdateIteration extends IterationEvent {
  final Iteration iteration;
  final List<Attachements> attachements;
  UpdateIteration(this.iteration, this.attachements);
}

class DeleteIteration extends IterationEvent {
  final Iteration iteration;
  DeleteIteration(this.iteration);
}
