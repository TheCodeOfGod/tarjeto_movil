import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarjeto/config/config.dart';

import '../../../utilis/tarjeta.dart';

class TarjetaProgreso extends StatelessWidget {
  final TarjetaTarjeto tarjeta;

  const TarjetaProgreso({Key? key, required this.tarjeta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int visitas = tarjeta.visitas ?? 0;
    final int visitasRequeridas = tarjeta.visitasProximoNivel ?? 1;
    final double progreso = (visitas / visitasRequeridas).clamp(0.0, 1.0);
    final int porcentaje = (progreso * 100).round();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double doradoWidth = totalWidth * progreso;

        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: TarjetoColors.fieldBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: Stack(
            children: [
              // Fondo dorado proporcional
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: doradoWidth,
                  decoration: BoxDecoration(
                    gradient: TarjetoGradient.oroCardFooter,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(20),
                      right: Radius.circular(progreso == 1.0 ? 20 : 0),
                    ),
                  ),
                ),
              ),

              // Contenido
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Nombre del negocio (SIEMPRE visible, independiente del dorado)
                    Expanded(
                      child: Text(
                        tarjeta.negocioNombre ?? "Negocio",
                        style: TarjetoTextStyle.medianoBlancoBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Porcentaje y visitas
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "$porcentaje%",
                          style: TarjetoTextStyle.tituloBlancoBold,

                        ),
                        Text(
                          "$visitas/$visitasRequeridas visitas",
                          style: TextStyle(
                            fontSize: 12,
                            color: TarjetoColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}