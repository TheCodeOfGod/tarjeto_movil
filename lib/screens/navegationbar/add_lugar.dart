import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tarjeto/config/config.dart';
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

class AddLugar extends StatefulWidget {
  const AddLugar({Key? key}) : super(key: key);

  @override
  _AddLugarState createState() => _AddLugarState();
}

class _AddLugarState extends State<AddLugar> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;
  String? idCodigo;

  @override
  void initState() {
    super.initState();
    _cargarStorage();
  }

  Future<void> _cargarStorage() async {
    ClienteTarjeto? cliente = await storage.getCliente();
    setState(() {
      clienteTarjeto = cliente;
      idCodigo = cliente!.publicID;
      print(cliente.publicID);
      print(cliente.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.rojoPrincipal,
      body: SafeArea(
        child: Container(
          color: TarjetoColors.white,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
            child: Column(
              children: [
                Text(
                  'Escanea este código cuando visites un lugar Tarjeto',
                  textAlign: TextAlign.center,
                  style: TarjetoTextStyle.grandeTextColorBold,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: TarjetoColors.rojoPrincipal,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Container(
                        width: 270,
                        height: 370,
                        decoration: BoxDecoration(
                          color: TarjetoColors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              size: 40,
                              color: TarjetoColors.rojoPrincipal,
                            ),
                            const SizedBox(height: 20),
                            QrImageView(
                              data: "$idCodigo",
                              size: 180,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Tu código Tarjeto',
                              style: TarjetoTextStyle.normalTextColorNormal

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
