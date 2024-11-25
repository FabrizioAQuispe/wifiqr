import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreenn extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreenn(this.cameras);
  @override
  State<CameraScreenn> createState() => _CameraScreennState();
}

class _CameraScreennState extends State<CameraScreenn> {
  late CameraController controller;
  bool isControllerInitialized = false;
  String qrValue = "Codigo QR";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  //Metodo para escanear el qr
  // void scanQR() async {
  //   final String? cameraResultQR = await scanner.scan();

  //   if (cameraResultQR != null) {
  //     setState(() {
  //       qrValue = cameraResultQR;
  //     });
  //   }
  // }

  //Metodo para inicializar el controllador de la camara
  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) {
      debugPrint("No cameras available.");
      return;
    }

    controller = CameraController(
      widget.cameras[0], // Usa la primera cámara disponible.
      ResolutionPreset.max,
    );

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {
          isControllerInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  //Metodo para
  // Widget para mostrar la vista previa de la cámara
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isControllerInitialized
          ? Stack(
              children: [
                //Vista previa de la cámara en la posición completa del widget
                Positioned.fill(child: CameraPreview(controller)),
                //Iconos de cerrar flash y logo de brisas

                // Íconos en la parte superior
                Positioned(
                  top: 40, // Distancia desde la parte superior de la pantalla
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Ícono de cerrar
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),

                      // Espaciador de 5 cm (50 px)
                      const SizedBox(width: 5),

                      // Ícono de flash
                      IconButton(
                        icon: const Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          debugPrint("Flash toggled");
                        },
                      ),

                      // Espaciador de 15 cm (150 px)
                      const SizedBox(width: 50),

                      // Imagen random
                      GestureDetector(
                        onTap: () {
                          debugPrint("Random image clicked");
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJZ3xG4m4-X91Nth4ZYApIIa-U3gmTLcozpw&s'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Icono para abrira la galeria de la imagen
                Positioned(
                  bottom: 20,
                  left: MediaQuery.of(context).size.width / 2 - 90,
                  child: IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () {
                      // Abrir la galeria de la imagen
                      debugPrint("Gallery opened");
                    },
                  ),
                ),
                //Icono para capturar la imagen
                Positioned(
                    width: 50,
                    bottom: 20,
                    right: MediaQuery.of(context).size.width / 2 - 40,
                    child: IconButton(
                        onPressed: () {
                          // scanQR();
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 50,
                        ))),

                //Realizamos la vista previa para el cuadrado de la camara
                Positioned(
                  top: MediaQuery.of(context).size.height / 3 - 20,
                  left: MediaQuery.of(context).size.width / 4 - 70,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 + 150,
                    height: MediaQuery.of(context).size.height / 2 - 90,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                //Texto a mostrar del valor del QR
                Positioned(
                  bottom: 100,
                  left: MediaQuery.of(context).size.width / 2 - 100,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: Colors.black
                        .withOpacity(0.6), //Agregamos opacidad al texto
                    child: Text(
                      qrValue,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    controller.dispose(); // Libera el controlador para evitar fugas de memoria.
    super.dispose();
  }
}
