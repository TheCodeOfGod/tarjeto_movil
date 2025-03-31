class TarjetaTarjeto{
  String? negocioId;
  int? nivel;
  int? visitas;
  DateTime? ultimaVisita;
  int? rachaVisitasConsecutivas;
  int? maximaRachaLograda;
  String? idTarjeta;
  String? negocioNombre;
  String? nivelNombre;
  int? visitasProximoNivel;
  String? proximoNivel;
  List<String>? beneficios;
  DateTime? temporadaFin;

  TarjetaTarjeto({
    this.negocioId,
    this.nivel,
    this.visitas,
    this.ultimaVisita,
    this.rachaVisitasConsecutivas,
    this.maximaRachaLograda,
    this.idTarjeta,
    this.negocioNombre,
    this.nivelNombre,
    this.visitasProximoNivel,
    this.proximoNivel,
    this.beneficios,
    this.temporadaFin
  });
}