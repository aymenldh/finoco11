// bloc/Dossier_event.dart
import 'package:finoco/core/models/dossier.dart';

abstract class DossierEvent {}

class LoadDossiers extends DossierEvent {
  final bool statusFolder;
  final int idClient;

  LoadDossiers(this.statusFolder, this.idClient);
}

class LoadDossierForTransfert extends DossierEvent {
  final int idClient;

  LoadDossierForTransfert(this.idClient);
}

class AddDossier extends DossierEvent {
  final Dossier dossier;

  AddDossier(this.dossier);
}

class UpdateDossier extends DossierEvent {
  final Dossier dossier;

  UpdateDossier(this.dossier);
}

class DeleteDossier extends DossierEvent {
  final Dossier dossier;

  DeleteDossier(this.dossier);
}

class OuvrirDossier extends DossierEvent {
  final Dossier dossier;

  OuvrirDossier(this.dossier);
}

class FermerDossier extends DossierEvent {
  final Dossier dossier;

  FermerDossier(this.dossier);
}
