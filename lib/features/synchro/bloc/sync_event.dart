import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UploadToFirebase extends SyncEvent {}

class DownloadFromFirebase extends SyncEvent {}

class LoadDatabaseStats extends SyncEvent {}
