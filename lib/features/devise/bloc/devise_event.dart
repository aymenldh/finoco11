// bloc/Devise_event.dart
import 'package:finoco/core/models/devise.dart';

abstract class DeviseEvent {}

class LoadDevises extends DeviseEvent {
  LoadDevises();
}

class AddDevise extends DeviseEvent {
  final Devise devise;

  AddDevise(this.devise);
}

class DeleteDevise extends DeviseEvent {
  final int devise;

  DeleteDevise(this.devise);
}
