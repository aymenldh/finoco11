// bloc/Export_state.dart

import 'dart:io';

abstract class ExportState {}

class ExportsLoading extends ExportState {}

class ExportsLoaded extends ExportState {
  final File file;
  ExportsLoaded(this.file);
}

class ExportsError extends ExportState {}
