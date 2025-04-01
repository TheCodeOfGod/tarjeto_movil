import 'package:flutter/material.dart';
import 'package:tarjeto/config/config.dart';

class Lugares extends StatefulWidget {
  const Lugares({Key? key}) : super(key: key);

  @override
  _LugaresState createState() => _LugaresState();
}

class _LugaresState extends State<Lugares> {
  final List<Map<String, String>> lugares = [
    {
      'nombre': 'Hamburguesas Grill House',
      'url': 'https://maps.app.goo.gl/FeEbyco4k5JSorUw5',
    },
    {
      'nombre': 'Cafecito Central',
      'url': 'https://maps.app.goo.gl/kigb4qJ3AHpykJe39',
    },
    {
      'nombre': 'Tienda Orgánica Vida Verde',
      'url': 'https://maps.app.goo.gl/eSrNAGWLhnEm1QZu7',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.rojoPrincipal,
      body: SafeArea(
        child: Container(
          color: TarjetoColors.white,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: ListView.separated(
              itemCount: lugares.length + 1,
              separatorBuilder: (_, index) =>
              index == 0 ? const SizedBox(height: 25) : const SizedBox(height: 15),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Text(
                    'Lugares en tarjeto',
                    style: TarjetoTextStyle.tituloTextColorBold,
                  );
                }

                final lugar = lugares[index - 1];
                return Container(
                  decoration: BoxDecoration(
                    color: TarjetoColors.fieldBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: TarjetoColors.rojoPrincipal,
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.place, color: TarjetoColors.rojoPrincipal),
                    title: Text(
                      lugar['nombre']!,
                      style: TarjetoTextStyle.medianoTextColorBold,
                    ),
                    trailing: Icon(Icons.chevron_right, color: TarjetoColors.rojoPrincipal),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
