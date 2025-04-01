import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:tarjeto/config/config.dart';
import 'package:tarjeto/screens/navegationbar/pantallas/expandir_tarjeta.dart';
import 'package:tarjeto/screens/navegationbar/widgets/TarjetaProgreso.dart';

import '../../utilis/cliente_tarjeto.dart';
import '../../utilis/cliente_tarjeto_storage.dart';
import '../../utilis/tarjeta.dart';

class Tarjetas extends StatefulWidget {
  const Tarjetas({Key? key}) : super(key: key);

  @override
  _TarjetasState createState() => _TarjetasState();
}

class _TarjetasState extends State<Tarjetas> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;
  List<TarjetaTarjeto>? listaTarjetas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarStorage().then((_){
      _obtenerTarjetas();
    });
  }


  Future<void> _cargarStorage() async{
    ClienteTarjeto? cliente = await storage.getCliente();
    setState(() {
      clienteTarjeto = cliente;
    });
  }

  Future<void> _obtenerTarjetas() async {
    ClienteTarjeto? clienteTarjeto = await storage.getCliente();

    if (clienteTarjeto == null || clienteTarjeto.token == null) {
      print("Error: Cliente o token no disponible.");
      return;
    }

    final String apiUrl = "https://api.tarjeto.app/api/cliente/tarjetas";
    final String token = clienteTarjeto.token!;

    final Map<String, String> headers = {
      "mobile-auth": "Bearer $token",
      "Cliente": "flutter"
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          List<dynamic> tarjetasData = responseData["data"]["tarjetas"];

          setState(() {
            listaTarjetas = tarjetasData.map((tarjeta) {
              return TarjetaTarjeto(
                negocioId: tarjeta["negocio_id"],
                nivel: tarjeta["nivel"],
                visitas: tarjeta["visitas"],
                ultimaVisita: DateTime.tryParse(tarjeta["ultimaVisita"]),
                rachaVisitasConsecutivas: tarjeta["rachaVisitasConsecutivas"],
                maximaRachaLograda: tarjeta["maximaRachaLograda"],
                idTarjeta: tarjeta["_id"],
                negocioNombre: tarjeta["negocio_nombre"],
                nivelNombre: tarjeta["nivel_nombre"],
                visitasProximoNivel: tarjeta["visitas_proximo_nivel"],
                proximoNivel: tarjeta["proximo_nivel"],
                beneficios: List<String>.from(tarjeta["beneficios"]),
                temporadaFin: DateTime.tryParse(tarjeta["temporada_fin"]),
              );
            }).toList();

          });

          print("Tarjetas obtenidas correctamente (${listaTarjetas!.length} tarjetas).");

        } else {
          print("Error en la API: ${responseData["message"]}");
        }
      } else if(response.statusCode == 204){
        print("El usuario no tiene tarjetas registradas");
        setState(() {
          listaTarjetas == null;
        });
      }else{
        print("Error al obtener tarjetas: Código ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.rojoPrincipal,
      body: SafeArea(
          child: Container(
            color: TarjetoColors.white,
            child: Padding(
                padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 9.5, 0, 0),
                    child: Row(
                      children: [
                        Text('Tus tarjetas', style: TarjetoTextStyle.tituloTextColorBold,),
                        Spacer(),
                        SvgPicture.asset(TarjetoImages.logoCorazonRojo, height: 32,),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  if (listaTarjetas == null)
                    Center(
                      child: CircularProgressIndicator(color: TarjetoColors.rojoHover),
                    )
                  else if (listaTarjetas!.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          "Aún no tienes tarjetas registradas.",
                          style: TarjetoTextStyle.chicoTextColorMedium,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: listaTarjetas!.length,
                        itemBuilder: (context, index) {
                          final tarjeta = listaTarjetas![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ExpandirTarjeta(tarjeta: listaTarjetas![index])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: TarjetaProgreso(tarjeta: tarjeta),
                            ),
                          );
                        },
                      ),
                    ),




                ],
              ),
            ),
          )
      ),
    );
  }
}
