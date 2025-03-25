import 'package:flutter/material.dart';
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

class CargaPagina extends StatefulWidget {
  const CargaPagina({Key? key}) : super(key: key);

  @override
  _CargaPaginaState createState() => _CargaPaginaState();
}

class _CargaPaginaState extends State<CargaPagina> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    // Intenta cargar datos existentes
    ClienteTarjeto? cliente = await storage.getCliente();
    print("Datos del cliente: $cliente");

    if (cliente == null) {
      print("Se creo un nuevo cliente");
      // Si no hay datos guardados, crear nuevo cliente
      cliente = ClienteTarjeto(
        pantalla: "/bienvenida"
      );

      // Guardar el nuevo cliente
      await storage.saveCliente(cliente);
    }

    // Actualizar estado
    if (mounted) {
      setState(() {
        clienteTarjeto = cliente;
        isLoading = false;
      });

      // Navegar a la pantalla correspondiente después de cargar
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed(
            clienteTarjeto?.pantalla ?? "/bienvenida"
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('cargando'),
      ),

    );
  }
}
