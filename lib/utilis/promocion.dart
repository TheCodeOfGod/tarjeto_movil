class Promocion{
  String? negocio;
  String? titulo;
  String? descripcion;
  String? nivelRequerido;

  Promocion(
  {
    this.negocio,
    this.titulo,
    this.descripcion,
    this.nivelRequerido
  });

  factory Promocion.fromJson(Map<String, dynamic> json) {
    return Promocion(
      negocio: json['negocio'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      nivelRequerido: json['nivelRequerido'],
    );
  }
}