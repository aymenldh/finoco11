// bloc/Devise_state.dart

import 'package:finoco/core/models/devise.dart';

abstract class DeviseState {}

class DevisesLoading extends DeviseState {}

class DevisesLoaded extends DeviseState {
  final List<Devise> devises;

  DevisesLoaded(this.devises);
}

class DevisesError extends DeviseState {}
