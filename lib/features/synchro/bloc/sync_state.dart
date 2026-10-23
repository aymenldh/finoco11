import 'package:equatable/equatable.dart';
import 'package:finoco/core/models/tables_stats.dart';

abstract class SyncState extends Equatable {
  @override
  List<Object> get props => [];
}

class SyncInitial extends SyncState {}

class SyncInProgress extends SyncState {}

class SyncSuccess extends SyncState {
  final TablesStats localStats;
  final TablesStats remoteStats;

  SyncSuccess({this.localStats, this.remoteStats});
}

class SyncFailure extends SyncState {
  final String message;
  SyncFailure(this.message);
}
