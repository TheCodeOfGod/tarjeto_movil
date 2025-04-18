import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarjeto/config/config.dart';
import 'package:tarjeto/screens/navegationbar/add_lugar.dart';
import 'package:tarjeto/screens/navegationbar/inicio.dart';
import 'package:tarjeto/screens/navegationbar/lugares.dart';
import 'package:tarjeto/screens/navegationbar/ofertas.dart';
import 'package:tarjeto/screens/navegationbar/tarjetas.dart';
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

class NavigationBarPrincipal extends StatefulWidget {
  const NavigationBarPrincipal({Key? key}) : super(key: key);


  @override
  _NavigationBarPrincipalState createState() => _NavigationBarPrincipalState();
}

class _NavigationBarPrincipalState extends State<NavigationBarPrincipal> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;
  bool isLoading = true;

  //Variable para el navigation bar
  int currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarCliente();
  }

  Future<void> cargarCliente() async {
    // Cargar el cliente desde SharedPreferences
    ClienteTarjeto? cliente = await storage.getCliente();
    cliente?.pantalla = "/navigationbarprincipal"; // se cambia elatributo pantalla

    await storage.saveCliente(cliente!);
      setState(() {
        clienteTarjeto = cliente;
        isLoading = false;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.white,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: TarjetoColors.rojoPrincipal,
            indicatorColor: TarjetoColors.fieldBackground,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontFamily: 'Nunito', color: TarjetoColors.white,
            fontWeight: FontWeight.w600)
          ),
        ),

        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },

          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            //Inicio
            NavigationDestination(
              selectedIcon: SvgPicture.asset(TarjetoImages.homered_icon,
              width: 22,
              height: 22,),
              icon: SvgPicture.asset(TarjetoImages.homewhite_icon,
              width: 22, height: 22),
              label: 'Inicio',
            ),

            //Ofertas
            NavigationDestination(
              selectedIcon: SvgPicture.asset(TarjetoImages.offerred_icon,
                width: 24,
                height: 24,),
              icon: SvgPicture.asset(TarjetoImages.offerwhite_icon,
                  width: 24, height: 24),
              label: 'Ofertas',
            ),

            //Agregar lugar
            NavigationDestination(
              selectedIcon: SvgPicture.asset(TarjetoImages.add_place_newred_icon,
                width: 24,
                height: 24,),
              icon: SvgPicture.asset(TarjetoImages.add_place_newwhite_icon,
                  width: 30, height: 30),
              label: 'Añadir',
            ),

            //Logros
            NavigationDestination(
              selectedIcon: SvgPicture.asset(TarjetoImages.badgered_icon,
                width: 24,
                height: 24,),
              icon: SvgPicture.asset(TarjetoImages.badgewhite_icon,
                  width: 24, height: 24),
              label: 'Tarjetas',
            ),

            //Lugares
            NavigationDestination(
              selectedIcon: SvgPicture.asset(TarjetoImages.locationred_icon,
                width: 24,
                height: 24,),
              icon: SvgPicture.asset(TarjetoImages.locationwhite_icon,
                  width: 24, height: 24),
              label: 'Lugares',
            ),


          ],
        ),
      ),

      body:
      PopScope(//Widget para manejar el retroceso de pagina
        canPop: false, //no permitir retroceso de pagina
        child: <Widget>[
          /// Inicio page
          Inicio(),
        
          /// Ofertas Page
          Ofertas(),
        
          /// Añadir lugar page
          AddLugar(),
        
          /// Tarjetas page
          Tarjetas(),
        
          /// Lugares page
          Lugares(),
        
        
        ][currentPageIndex],
      ),
    );
  }
}
