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
    // TODO: implement initState
    super.initState();
    _cargarStorage();
  }
  Future<void> _cargarStorage() async{
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

  backgroundColor: TarjetoColors.white,
  //appBar: AppBar(title: Text('Generador de Qr')),
  body: SafeArea(
    child:

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(

              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
                    child: Text('Escanea este código en el dispositivo nexo del establecimiento que visites :)',
                      style: TarjetoTextStyle.grandeTextColorBold,),
                ),

                Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: TarjetoColors.rojoPrincipal,
                        borderRadius: BorderRadius.circular(45)
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: TarjetoColors.white,
                            borderRadius: BorderRadius.circular(35)
                        ),
                        child: QrImageView(
                          data: "$idCodigo",
                          size: 250,
                        ),
                      ),
                    ),
              ],
            ),
          ),


  )

);
}
}
