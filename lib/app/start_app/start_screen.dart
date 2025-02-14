import 'package:flutter/material.dart';

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
              color: Color(0xFFF4262F),
              child: Column(
                children: [
                  Row(
                    //Logo corazon blanco
                    children: [
                      Container(
                        child: Image.asset("assets/images/logocorazonblanco.png"),
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
                        child: Image.asset("assets/images/tarjetas.png"),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
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
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),

                  Row(
                    // Boton unirse ahora
                    children: [
                      Expanded(
                          child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              "Únete ahora",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFFF4262F)),
                            ),
                          ),
                        ),
                            onTap: (){} //Aqui se pone la función del botón
                      )
                      )
                    ],
                  ),

                  Row(
                    // Boton Acceder a tarejeto
                    children: [
                      Expanded(
                          child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    "Acceder a tarjeto",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: (){} //Aqui se pone la función del botón
                          )
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
