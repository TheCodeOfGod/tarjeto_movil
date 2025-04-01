import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarjeto/config/config.dart';
import 'package:tarjeto/utilis/tarjeta.dart';

class TarjetaCard extends StatelessWidget {
  final TarjetaTarjeto tarjeta;

  const TarjetaCard({Key? key, required this.tarjeta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: TarjetoGradient.oroCardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Nombre del negocio
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tarjeta.negocioNombre ?? 'Nombre no disponible',
                    style: TarjetoTextStyle.tituloBlancoBold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Spacer(),

          // Icono QR
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 0, 20),
            child: Row(
              children: [
                SvgPicture.asset(TarjetoImages.qr_icon),
              ],
            ),
          ),

          // Footer con logo, punto y nivel
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(25, 15, 0, 15),
            decoration: BoxDecoration(
              gradient: TarjetoGradient.oroCardFooter,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Image.asset(TarjetoImages.logoBlancoConLetras, height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text('•', style: TarjetoTextStyle.normalBlancoMedium),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    tarjeta.nivelNombre != null
                        ? 'Nivel ${tarjeta.nivelNombre}'
                        : 'Sin nivel',
                    style: TarjetoTextStyle.normalBlancoMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
