import 'package:flutter/material.dart';
import 'package:tarjeto/app/start_app/carga_pagina.dart';
import 'package:tarjeto/config/config.dart';
import 'package:tarjeto/screens/login/login_screen.dart';
import 'package:tarjeto/screens/navegationbar/navigation_bar_principal.dart';
import 'package:tarjeto/screens/signup/signup.dart';
import 'package:tarjeto/screens/signup/subir_foto_perfil.dart';
import 'package:tarjeto/screens/signup/verificar_correo.dart';
import 'package:tarjeto/screens/start_screen.dart';


class AppStart extends StatelessWidget {

  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        textSelectionTheme: TextSelectionThemeData(
          cursorColor: TarjetoColors.rojoPrincipal,
          selectionColor: TarjetoColors.rojoPrincipal.withOpacity(0.5),
          selectionHandleColor: TarjetoColors.rojoPrincipal,
        ),
          fontFamily: "Nunito"),

      debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const CargaPagina(),
          '/bienvenida': (context) => const StartScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const Signup(),
          '/verificarcorreo': (context) => const VerificarCorreo(),
           '/subirfotoperfil': (context) => const SubirFotoPerfil(),
          '/navigationbarprincipal': (context) => const NavigationBarPrincipal()
        },

    );
  }
}
