import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';
import '../../config/config.dart';
import '../../utilis/cliente_tarjeto.dart';

class SubirFotoPerfil extends StatefulWidget {

  const SubirFotoPerfil({Key? key,}) : super(key: key);

  @override
  _SubirFotoPerfilState createState() => _SubirFotoPerfilState();
}

class _SubirFotoPerfilState extends State<SubirFotoPerfil> {
  //Para storage
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;

  File? _imagenPerfil;
  String? _base64Imagen;
  late String _nombreUsuario = "Nohaynombreaun"; //se inicializa en el initState()



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    ClienteTarjeto? cliente = await storage.getCliente();
    setState(() {
      clienteTarjeto = cliente;
      _nombreUsuario = clienteTarjeto!.nombre!;
    });

    print(clienteTarjeto!.nombre );
  }

  //Esta metodo permite subir imagen desde el dipositivo
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Comprimir la imagen
      final File? compressedImage = await _compressImage(File(pickedFile.path));
      if (compressedImage != null) {
        print("Se comprimio la imagen");
        setState(() {
          _imagenPerfil = compressedImage;
        });
        _convertImageToBase64();
      }
    }
  }

  //Funcion para comprimir la imagen a 1 MB
  Future<File?> _compressImage(File file) async {
    final int targetSizeInBytes = 1 * 1024 * 1024; // 1 MB en bytes
    int quality = 100;
    File? compressedFile = file;

    while (await compressedFile!.length() > targetSizeInBytes && quality > 0) {
      quality -= 5;
      final String dir = (await getTemporaryDirectory()).path;
      final String targetPath = '$dir/temp.jpg';

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );

      if (result != null) {
        compressedFile = result as File?;
      }
    }
    return compressedFile;
  }

  //Metodo para convertir la imagen a base 64
  void _convertImageToBase64() async {
    if (_imagenPerfil != null) {
      final bytes = await _imagenPerfil!.readAsBytes();
      final base64String = base64Encode(bytes);

      // Determinar el tipo MIME de la imagen
      String mimeType = 'jpeg'; // Por defecto

      // Obtener la extensión del archivo
      String extension = _imagenPerfil!.path.split('.').last.toLowerCase();

      // Mapeo de extensiones a tipos MIME
      switch (extension) {
        case 'png':
          mimeType = 'png';
          break;
        case 'gif':
          mimeType = 'gif';
          break;
        case 'webp':
          mimeType = 'webp';
          break;
        case 'bmp':
          mimeType = 'bmp';
          break;
        case 'jpg':
        case 'jpeg':
        default:
          mimeType = 'jpeg';
      }

      // Crear la cadena base64 completa con el prefijo
      final fullBase64String = 'data:image/$mimeType;base64,$base64String';

      setState(() {
        _base64Imagen = fullBase64String;
      });

      print("La imagen en base64 es: $_base64Imagen");
      print("Longitud de la cadena base64: ${_base64Imagen?.length} caracteres");
      print("Tipo de imagen detectado: $mimeType");
    }
  }

  //Funcion para guardar en el storage la imagen e ir a la siguiente página
  Future<void> imagenEnStorage() async{
    if (_base64Imagen != null) {
      clienteTarjeto?.fotoPerfil = _base64Imagen;
      print("Si selecciono foto de perfil");
    }  else{
      clienteTarjeto?.fotoPerfil = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTYyIiBoZWlnaHQ9IjU2MiIgdmlld0JveD0iMCAwIDU2MiA1NjIiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxnIGNsaXAtcGF0aD0idXJsKCNjbGlwMF8yMzY5XzE4NTQpIj4KPHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0zNDcuMjcgMjUwLjk3OUMzMjguNTU5IDI2Ny4yNzkgMzA1LjQzNCAyNzcuNjY0IDI4MC44MjEgMjgwLjgyMUMyNDcuODIxIDI4NS4wMiAyMTQuNTAzIDI3NS45NTYgMTg4LjE3OSAyNTUuNjE2QzE2MS44NTUgMjM1LjI3OCAxNDQuNjc1IDIwNS4zMjUgMTQwLjQxIDE3Mi4zMzRDMTM3LjI1MyAxNDcuNzIxIDE0MS40NjYgMTIyLjcyNCAxNTIuNTE2IDEwMC41MDRDMTYzLjU2NSA3OC4yODUxIDE4MC45NTYgNTkuODQxMyAyMDIuNDg4IDQ3LjUwNTRDMjI0LjAxOSAzNS4xNjk3IDI0OC43MjYgMjkuNDk1NyAyNzMuNDgyIDMxLjIwMTJDMjk4LjIzOCAzMi45MDY4IDMyMS45MzQgNDEuOTE1MSAzNDEuNTcgNTcuMDg3MkMzNjEuMjA3IDcyLjI1OTQgMzc1LjkwNCA5Mi45MTM3IDM4My44MDIgMTE2LjQzOEMzOTEuNjk5IDEzOS45NjMgMzkyLjQ0NSAxNjUuMzAyIDM4NS45NDMgMTg5LjI0OUMzNzkuNDQgMjEzLjE5NyAzNjUuOTgyIDIzNC42NzkgMzQ3LjI3IDI1MC45NzlaTTMwMi4xMDQgODEuNDc3QzI4Ny4yOTEgNzQuMTEwNiAyNzAuNjI2IDcxLjMwMjIgMjU0LjIxNyA3My40MDY4QzIzMi4yMTMgNzYuMjI5MSAyMTIuMjMyIDg3LjY3NjcgMTk4LjY2OCAxMDUuMjMxQzE4NS4xMDUgMTIyLjc4NiAxNzkuMDcxIDE0NS4wMSAxODEuODkzIDE2Ny4wMTRDMTgzLjk5OCAxODMuNDIyIDE5MC45MjEgMTk4Ljg0IDIwMS43ODcgMjExLjMxNEMyMTIuNjUzIDIyMy43ODggMjI2Ljk3NSAyMzIuNzYgMjQyLjk0IDIzNy4wOTVDMjU4LjkwNiAyNDEuNDI5IDI3NS43OTggMjQwLjkzMyAyOTEuNDgyIDIzNS42NjhDMzA3LjE2NSAyMzAuNDAyIDMyMC45MzQgMjIwLjYwNSAzMzEuMDQ5IDIwNy41MTNDMzQxLjE2NCAxOTQuNDIyIDM0Ny4xNjkgMTc4LjYyNiAzNDguMzA2IDE2Mi4xMjJDMzQ5LjQ0MyAxNDUuNjE3IDM0NS42NiAxMjkuMTQ2IDMzNy40MzcgMTE0Ljc5MkMzMjkuMjEzIDEwMC40MzcgMzE2LjkxNyA4OC44NDM0IDMwMi4xMDQgODEuNDc3Wk0xNjEuMjI1IDM5My45NjJDMTkxLjczMiAzNTQuNDc3IDIzNi42NTcgMzI4LjcwNiAyODYuMTQxIDMyMi4zMDRDMzM1LjY0IDMxNi4wMSAzODUuNjE0IDMyOS42MSA0MjUuMDk4IDM2MC4xMTdDNDY0LjU4MyAzOTAuNjI0IDQ5MC4zNTQgNDM1LjU0OCA0OTYuNzU3IDQ4NS4wMzNDNDk3LjQ2MiA0OTAuNTM0IDQ5NS45NTMgNDk2LjA5IDQ5Mi41NjMgNTAwLjQ3OUM0ODkuMTcyIDUwNC44NjcgNDg0LjE3NyA1MDcuNzI5IDQ3OC42NzYgNTA4LjQzNUM0NzMuMTc1IDUwOS4xNCA0NjcuNjE4IDUwNy42MzEgNDYzLjIzIDUwNC4yNDFDNDU4Ljg0MSA1MDAuODUgNDU1Ljk3OSA0OTUuODU1IDQ1NS4yNzQgNDkwLjM1NEM0NTAuMzM1IDQ1MS44NDcgNDMwLjMwMiA0MTYuODc5IDM5OS41ODEgMzkzLjE0M0MzNjguODYgMzY5LjQwOCAzMjkuOTY5IDM1OC44NDcgMjkxLjQ2MiAzNjMuNzg2QzI1Mi45NTUgMzY4LjcyNSAyMTcuOTg4IDM4OC43NTkgMTk0LjI1MiA0MTkuNDc5QzE3MC41MTYgNDUwLjE5OSAxNTkuOTU2IDQ4OS4wOTEgMTY0Ljg5NSA1MjcuNTk5QzE2NS42IDUzMy4xIDE2NC4wOTIgNTM4LjY1NSAxNjAuNzAxIDU0My4wNDRDMTU3LjMxIDU0Ny40MzIgMTUyLjMxNCA1NTAuMjk0IDE0Ni44MTMgNTUxQzE0MS4zMTMgNTUxLjcwNSAxMzUuNzU3IDU1MC4xOTcgMTMxLjM2OCA1NDYuODA2QzEyNi45NzkgNTQzLjQxNSAxMjQuMTE3IDUzOC40MiAxMjMuNDEyIDUzMi45MTlDMTE3LjExOSA0ODMuNDIgMTMwLjcxOCA0MzMuNDQ2IDE2MS4yMjUgMzkzLjk2MloiIGZpbGw9IiNGNDI2MkYiLz4KPC9nPgo8cGF0aCBkPSJNMjM4Ljk3OCAyMDAuNDgyQzI2Mi40MzcgMjA3LjgyNCAzMDMuNDg0IDIwMS45MDMgMzE5LjU1NCAxNzYuNzIiIHN0cm9rZT0iI0Y0MjYyRiIgc3Ryb2tlLXdpZHRoPSIxNCIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+CjxlbGxpcHNlIGN4PSIyMjcuOTc4IiBjeT0iMTQwLjQ4MiIgcng9IjciIHJ5PSI5IiBmaWxsPSIjRjQyNjJGIi8+CjxlbGxpcHNlIGN4PSIyNzMuOTc4IiBjeT0iMTIyLjQ4MiIgcng9IjciIHJ5PSI5IiBmaWxsPSIjRjQyNjJGIi8+CjxkZWZzPgo8Y2xpcFBhdGggaWQ9ImNsaXAwXzIzNjlfMTg1NCI+CjxyZWN0IHdpZHRoPSI1MDEuODcxIiBoZWlnaHQ9IjUwMS44NzEiIGZpbGw9IndoaXRlIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDYzLjg0NzkpIHJvdGF0ZSgtNy4zMDg5NikiLz4KPC9jbGlwUGF0aD4KPC9kZWZzPgo8L3N2Zz4K";
      print("No selecciono foto de perfil");
    }

    await storage.saveCliente(clienteTarjeto!);

    Navigator.pushNamed(context, '/subirdatospersonales');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.white,
      body: PopScope( //Widget para manejar el retroceso de pantallas
        canPop: false, //no permitir retroceso
        child: SafeArea(
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
                        'Sube una foto de ti para conocernos mejor.',
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

                            //Container Imagen de Perfil
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: TarjetoColors.rojoPrincipal.withOpacity(0.20),
                                    blurRadius:10, // Desenfoque
                                    spreadRadius: 0.2, // Expansión de la sombra
                                    offset: Offset(0, 0), // Dirección (X, Y)
                                  )
                                ],
                                borderRadius: BorderRadius.circular(100),
                                color: TarjetoColors.fieldBackground,
                              ),

                              child: ClipOval(
                                  child: _imagenPerfil == null ? SvgPicture.asset(TarjetoImages.usersmile_rojo_icon) : Image.file(_imagenPerfil!, fit: BoxFit.cover,)
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Text(_nombreUsuario?? "NO HAY USUARIO",
                                style: TarjetoTextStyle.medianoTextColorMedium,
                              ),
                            ),

                            //Botón subir
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              width: 160,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: TarjetoColors.rojoHover,
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  side:  BorderSide(color: _imagenPerfil == null ? TarjetoColors.rojoPrincipal : TarjetoColors.verde, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                onPressed: () {
                                  _pickImage();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      width: 20,
                                      height: 20,
                                      child: SvgPicture.asset(_imagenPerfil == null ? TarjetoImages.upload_rojoPrincipal_icon : TarjetoImages.upload_verde_icon),
                                    ),

                                    Text(
                                      "Subir",
                                      style: _imagenPerfil == null ? TarjetoTextStyle.medianoRojoBold : TarjetoTextStyle.medianoVerdeBold,
                                    ),
                                  ],
                                ),
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
                          backgroundColor: _imagenPerfil != null ? TarjetoColors.rojoPrincipal : TarjetoColors.fieldBackground,
                          foregroundColor: TarjetoColors.fieldOutline,
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                                color:_imagenPerfil == null ? TarjetoColors.fieldOutline : TarjetoColors.rojoPrincipal,
                                width:_imagenPerfil == null ?  2 : 0
                            )
                          ),
                          elevation: 0,
                        ),
                        onPressed: (){
                          imagenEnStorage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text( _imagenPerfil != null ?
                              "Siguiente" : "Omitir",
                              style: _imagenPerfil != null ? TarjetoTextStyle.btnTextBlanco : TarjetoTextStyle.btnTextTextColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: SvgPicture.asset(_imagenPerfil != null ?  TarjetoImages.flechaDerechaIcon : TarjetoImages.flechaDerechaIconTextColor,
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
      ),
    );
  }
}
