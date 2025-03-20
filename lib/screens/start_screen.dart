import 'package:flutter/material.dart';
import 'package:tarjeto/config/config.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Container(
            // Container para el fondo
            padding: EdgeInsets.fromLTRB(0,60 , 0, 0),
            color: TarjetoColors.rojoPrincipal,
            child: Column(
              children: [
                Row(
                  //Logo corazon blanco
                  children: [
                    Container(
                      child: Image.asset(TarjetoImages.logoCorazonBlanco),
                      margin: EdgeInsets.fromLTRB(30, 25, 20, 0),
                      width: 70,
                    ),
                  ],
                ),
                Row(
                  //Imagen tarjetas desplegadas
                  children: [
                    Expanded(
                        child: Container(

                          padding: EdgeInsets.fromLTRB(140, 0, 0, 0),
                          child: Image.asset(TarjetoImages.pngTarjetas),
                        )),

                  ],
                ),
                Row(
                  // Titulo bienvenido a tarjeto
                  children: [
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                          child: Text(
                            "Bienvenido a tarjeto",
                            style: TarjetoTextStyle.tituloGrandeBlancoExtBold
                          )),
                    )
                  ],
                ),
                Row(
                  // Texto debajo del titulo
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: Text(
                          "Recibe recompensas al visitar tus lugares favoritos",
                          style: TarjetoTextStyle.medianoBlancoBold
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  // Boton unirse ahora
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TarjetoColors.white,
                            foregroundColor: TarjetoColors.rojoPrincipal,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            "Únete ahora",
                            style: TarjetoTextStyle.btnTextRojo,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  // Boton Acceder a tarejeto
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: TarjetoColors.white,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            side: const BorderSide(color: TarjetoColors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () {
                           Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            "Acceder a tarjeto",
                            style: TarjetoTextStyle.btnTextBlanco,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ]),

    );
  }
}
