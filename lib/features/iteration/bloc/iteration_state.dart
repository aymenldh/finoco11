// bloc/Iteration_state.dart

import 'package:finoco/core/models/iteration.dart';

abstract class IterationState {}

class IterationsLoading extends IterationState {}

class IterationsLoaded extends IterationState {
  final List<Iteration> iterations;

  IterationsLoaded(this.iterations);
}

class IterationsError extends IterationState {}
