// bloc/Attachements_event.dart
import 'package:finoco/core/models/attachements.dart';

abstract class AttachementsEvent {}

class LoadAttachementss extends AttachementsEvent {
  final int idIteration;

  LoadAttachementss(this.idIteration);
}

class AddAttachements extends AttachementsEvent {
  final String filePath;
  final String fileName;
  final int idIteration;
  AddAttachements(this.filePath, this.fileName, this.idIteration);
}

class DeleteAttachements extends AttachementsEvent {
  final Attachements attachements;

  DeleteAttachements(this.attachements);
}
