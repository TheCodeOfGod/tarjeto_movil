import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tarjeto/config/config.dart';

class VerificarCorreo extends StatefulWidget {
  const VerificarCorreo({Key? key}) : super(key: key);

  @override
  _VerificarCorreoState createState() => _VerificarCorreoState();
}

class _VerificarCorreoState extends State<VerificarCorreo> {
  TextEditingController pinController = TextEditingController();

  //bandera para saber si esta lleno el pin
  bool isPinComplete = false;

  //funcion para cambiar la bandera del pin si ya se llenaron los 6
  void _onPinChanged(String value) {
    setState(() {
      isPinComplete = value.length == 6;
    });
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
                            'Te enviamos un código a tu correo para confirmar que eres tú.',
                          style: TarjetoTextStyle.grandeTextColorMedium,
                    ),
                ),
            
                //Container ingresar codigo
                Container(
                  margin: EdgeInsets.all(25),
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
                        Text(
                          'Ingresa tu código',
                        style: TarjetoTextStyle.medianoNegroBold,
                        ),
            
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 40, 5, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: PinCodeTextField(
                            controller: pinController,
                            keyboardType: TextInputType.number,
                            appContext: context,
                            length: 6,
                            textStyle: TarjetoTextStyle.placeholderRojoInput,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              inactiveColor: TarjetoColors.fieldOutline,
                              activeColor: TarjetoColors.rojoHover,
                              inactiveFillColor: TarjetoColors.fieldBackground,
                              activeFillColor: TarjetoColors.rojoHover,
                              selectedColor: TarjetoColors.rojoHover,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onChanged: _onPinChanged,
                          )
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPinComplete ? TarjetoColors.rojoPrincipal : TarjetoColors.white,
                      foregroundColor: TarjetoColors.fieldOutline,
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isPinComplete ? () {
                      // Acción cuando el código está completo
                    } : null, // Desactiva el botón si no está completo
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Siguiente",
                          style: isPinComplete ? TarjetoTextStyle.btnTextBlanco : TarjetoTextStyle.btnTextTextColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: SvgPicture.asset(isPinComplete ? TarjetoImages.flechaDerechaIcon : TarjetoImages.flechaDerechaIconTextColor ,
                            width: 20,
                            height: 20,),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(25, 80, 25, 0),
                  decoration: BoxDecoration(
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: TarjetoColors.rojoPrincipal,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
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
