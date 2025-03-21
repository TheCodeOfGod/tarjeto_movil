import 'package:flutter/material.dart';
import 'package:tarjeto/config/config.dart';
import 'package:tarjeto/screens/login/login_screen.dart';

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
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
            color: TarjetoColors.rojoPrincipal,
            child: Column(
              children: [
                Row(
                  //Logo corazón blanco
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 25, 20, 0),
                      width: 70,
                      child: Image.asset(TarjetoImages.logoCorazonBlanco),
                    ),
                  ],
                ),
                Row(
                  //Imagen tarjetas desplegadas
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(140, 0, 0, 0),
                        child: Image.asset(TarjetoImages.pngTarjetas),
                      ),
                    ),
                  ],
                ),
                Row(
                  // Título "Bienvenido a Tarjeto"
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                        child: Text(
                          "Bienvenido a tarjeto",
                          style: TarjetoTextStyle.tituloGrandeBlancoExtBold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  // Texto debajo del título
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: Text(
                          "Recibe recompensas al visitar tus lugares favoritos",
                          style: TarjetoTextStyle.medianoBlancoBold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  // Botón "Únete ahora"
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
                    ),
                  ],
                ),
                Row(
                  // Botón "Acceder a Tarjeto"
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
                            Navigator.of(context).push(_createRoute());
                          },
                          child: Text(
                            "Acceder a tarjeto",
                            style: TarjetoTextStyle.btnTextBlanco,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(position: animation.drive(tween), child: child);
    }
  );
}