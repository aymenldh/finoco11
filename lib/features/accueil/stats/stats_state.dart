import 'package:equatable/equatable.dart';
import 'package:finoco/core/models/statistiques.dart';

abstract class StatsState extends Equatable {
  @override
  List<Object> get props => [];
}

class StatsInitial extends StatsState {}

class StatsInProgress extends StatsState {}

class StatsSuccess extends StatsState {
  final Statistiques statistiques;

  StatsSuccess(this.statistiques);
}

class StatsFailure extends StatsState {
  final String message;
  StatsFailure(this.message);
}
