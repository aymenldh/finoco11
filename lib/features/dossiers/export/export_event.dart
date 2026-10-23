abstract class ExportEvent {}

class ExportDossier extends ExportEvent {
  final int idFolder;

  ExportDossier(this.idFolder);
}
