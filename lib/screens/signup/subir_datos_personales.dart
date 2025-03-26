import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

import '../../config/config.dart';

class SubirDatosPersonales extends StatefulWidget {
  const SubirDatosPersonales({Key? key}) : super(key: key);

  @override
  _SubirDatosPersonalesState createState() => _SubirDatosPersonalesState();
}

class _SubirDatosPersonalesState extends State<SubirDatosPersonales> {

  TextEditingController edadController = TextEditingController();
  TextEditingController ciudadController = TextEditingController();

  List<bool> isSelected = [false, false, false];
  bool _edadFill = false;
  bool _ciudadFill = false;
  bool _generoFill = false;
  bool _fillData = false;

  final List<String> ciudades = [
    'Chihuahua',
    // Agrega más ciudades según necesites
  ];

  Future<void> _subirdatosStorage() async{
    String? genero;

    if (isSelected[0]) {
      genero = "Masculino";
      print("El genero es Masculino");
    }
    if (isSelected[1]) {
      genero = "Femenino";
      print("El genero es Femenino");
    }
    if (isSelected[2]) {
      genero = "Otro";
      print("El genero es Otro");
    }

    ClienteTarjetoStorage storage = ClienteTarjetoStorage();
    ClienteTarjeto? clienteTarjeto = await storage.getCliente();

    clienteTarjeto?.edad = int.tryParse(edadController.text);
    clienteTarjeto?.ciudad = ciudadController.text;
    clienteTarjeto?.genero = genero;

    await storage.saveCliente(clienteTarjeto!);

    Navigator.pushNamed(context, '/subircategorias');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.white,
      body: SafeArea(
          bottom: false,
          child: Container(color: TarjetoColors.white,

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      child: Image.asset(TarjetoImages.logoRojoConLetras),
                      width: 200,
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child:
                    Text(
                      'Queremos mejorar tu experiencia. Cuéntanos un poco más sobre ti.',
                      style: TarjetoTextStyle.grandeTextColorMedium,
                    ),
                  ),

                  //Container gris principal
                  Container(
                    margin: const EdgeInsets.all(25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: TarjetoColors.fieldBackground,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius:10, // Desenfoque
                              spreadRadius: 0.2, // Expansión de la sombra
                              offset: Offset(0, 0), // Dirección (X, Y)
                            )
                          ],
                          color: TarjetoColors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [

                          //Texto ingresar código
                          Row(
                            children: [
                              Text(
                                'Tu perfil',
                                style: TarjetoTextStyle.medianoRojoBold,
                              ),
                            ],
                          ),

                          //Input edad
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: TarjetoColors.fieldOutline, width: 2),
                              color: TarjetoColors.fieldBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: edadController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              cursorColor: TarjetoColors.fieldOutline,
                              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                              decoration: InputDecoration(
                                labelStyle: TarjetoTextStyle.placeholderInput,
                                hintText: 'Tu edad',
                                hintStyle: TarjetoTextStyle.placeholderInput,
                                prefixIcon: Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: SvgPicture.asset(
                                      TarjetoImages.daily_textcolor_icon,
                                      width: 25,
                                      height: 25,
                                    )),
                                border: InputBorder.none,
                              ),
                              onChanged: _validarEdad,
                            ),
                          ),

                          //Input ciudad
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: TarjetoColors.fieldOutline, width: 2),
                              color: TarjetoColors.fieldBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButtonFormField<String>(
                              dropdownColor: TarjetoColors.fieldBackground,
                              value: ciudadController.text.isEmpty ? null : ciudadController.text,
                              hint: Text(
                                  'Tu ciudad',
                                  style: TarjetoTextStyle.placeholderInput
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: SvgPicture.asset(
                                      TarjetoImages.city_textcolor_icon,
                                      width: 25,
                                      height: 25,
                                    )
                                ),

                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              ),
                              items: ciudades.map((String ciudad) {
                                return DropdownMenuItem<String>(
                                  value: ciudad,
                                  child: Text(ciudad),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  ciudadController.text = newValue;
                                  _validarCiudad(newValue);
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor selecciona una ciudad';
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: TarjetoColors.fieldOutline, width: 2),
                              color: TarjetoColors.fieldBackground,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Selecciona tu género', style: TarjetoTextStyle.placeholderInput,),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ToggleButtons(
                                      borderRadius: BorderRadius.circular(8),
                                      borderColor: TarjetoColors.fieldOutline,
                                      selectedBorderColor: TarjetoColors.rojoHover,
                                      fillColor: TarjetoColors.rojoPrincipal,
                                      color: TarjetoColors.fieldOutline,
                                      selectedColor: TarjetoColors.white,
                                      splashColor: TarjetoColors.rojoPrincipal,
                                      borderWidth: 2,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text("Masculino"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text("Femenino"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          child: Text("Otro"),
                                        ),
                                      ],
                                      isSelected: isSelected,
                                      onPressed: (int index) {
                                        setState(() {
                                          for (int i = 0; i < isSelected.length; i++) {
                                            isSelected[i] = (i == index);
                                          }
                                          _generoFill = true;
                                          _fillData = _ciudadFill == true && _edadFill == true && _generoFill == true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),



                  // Botón siguiente
                  Container(
                    margin: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _fillData ? TarjetoColors.rojoPrincipal : TarjetoColors.fieldBackground,
                        foregroundColor: TarjetoColors.fieldOutline,
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 0,
                      ),
                      onPressed: (){
                        _subirdatosStorage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                          "Continuar",
                            style: _fillData ? TarjetoTextStyle.btnTextBlanco : TarjetoTextStyle.btnTextTextColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: SvgPicture.asset(_fillData ?  TarjetoImages.flechaDerechaIcon : TarjetoImages.flechaDerechaIconTextColor,
                              width: 20,
                              height: 20,),
                          )
                        ],
                      ),
                    ),
                  ),



                ],
              ),
            ),
          )
      ),


    );
  }


  void _validarCiudad(String value) {
    setState(() {
      _ciudadFill = value.length >= 1;
      _fillData = _ciudadFill == true && _edadFill == true && _generoFill == true;
    });
  }

  void _validarEdad(String value) {
    setState(() {
      _edadFill = value.length >= 1;
      _fillData = _ciudadFill == true && _edadFill == true && _generoFill == true;
    });
  }
}
