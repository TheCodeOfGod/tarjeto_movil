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
  String _nombreUsuario = "Nohaynombreaun"; //se inicializa en el initState()

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
      setState(() {
        _base64Imagen = base64String;
      });
    }

    print("La imagen en base64 es: $_base64Imagen");
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
                                child: _imagenPerfil == null ? SvgPicture.asset(TarjetoImages.profileIcon) : Image.file(_imagenPerfil!, fit: BoxFit.cover,)
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
                        ),
                        elevation: 0,
                      ),
                      onPressed: (){},
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


    );
  }
}
