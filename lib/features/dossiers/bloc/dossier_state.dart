// bloc/Dossier_state.dart

import 'package:finoco/core/models/dossier.dart';

abstract class DossierState {}

class DossiersLoading extends DossierState {}

class DossiersLoaded extends DossierState {
  final List<Dossier> dossiers;

  DossiersLoaded(this.dossiers);
}

class DossiersError extends DossierState {}
