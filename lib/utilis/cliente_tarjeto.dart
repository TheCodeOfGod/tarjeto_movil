class ClienteTarjeto {
  // Datos de usuario
  String? nombre;
  String? email;
  String? token;
  bool? verificado;

  // Datos personales
  int? edad;
  String? genero;
  String? fotoPerfil;

  // Datos de ubicación
  String? ciudad;
  String? codigoPostal;

  // Categorias favoritas
  List<dynamic>? categoriasFavoritas;

  // Tarjetas
  List<dynamic>? tarjetas;

  // Para saber a que pantalla dirigir
  String pantalla = "/bienvenida";

  //datos del cliente
  String? publicID;


  ClienteTarjeto({
    this.nombre,
    this.email,
    this.token,
    this.verificado,
    this.edad,
    this.genero,
    this.fotoPerfil,
    this.ciudad,
    this.codigoPostal,
    this.categoriasFavoritas,
    this.tarjetas,
    this.pantalla = "/bienvenida",
    this.publicID,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'token': token,
      'verificado': verificado,
      'edad': edad,
      'genero': genero,
      'fotoPerfil': fotoPerfil,
      'ciudad': ciudad,
      'codigoPostal': codigoPostal,
      'categoriasFavoritas': categoriasFavoritas,
      'tarjetas': tarjetas,
      'pantalla': pantalla,
      'publicID' : publicID
    };
  }

  // Crear objeto desde JSON
  factory ClienteTarjeto.fromJson(Map<String, dynamic> json) {
    return ClienteTarjeto(
      nombre: json['nombre'],
      email: json['email'],
      token: json['token'],
      verificado: json['verificado'],
      edad: json['edad'],
      genero: json['genero'],
      fotoPerfil: json['fotoPerfil'],
      ciudad: json['ciudad'],
      codigoPostal: json['codigoPostal'],
      categoriasFavoritas: json['categoriasFavoritas'] != null
          ? List<dynamic>.from(json['categoriasFavoritas'])
          : null,
      tarjetas:
      json['tarjetas'] != null ? List<dynamic>.from(json['tarjetas']) : null,
      pantalla: json['pantalla'] ?? "/bienvenida",
      publicID: json['publicID'],
    );
  }

  @override
  String toString() {
    return 'ClienteTarjeto{nombre: $nombre, email: $email, token: $token, verificado: $verificado, edad: $edad, genero: $genero, ciudad: $ciudad, codigoPostal: $codigoPostal, categoriasFavoritas: $categoriasFavoritas, tarjetas: $tarjetas, pantalla: $pantalla, publicID: $publicID}';
  }

}