// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class BLBGenerationQRCode extends StatefulWidget {
  const BLBGenerationQRCode({ Key? key }) : super(key: key);

  @override
  _BLBGenerationQRCodeState createState() => _BLBGenerationQRCodeState();
}

class _BLBGenerationQRCodeState extends State<BLBGenerationQRCode> {

  // Controlleur de capture d'écran //
  final _captureEcran = ScreenshotController();

  // Controlleur de texte nom et prénom //
  final _controllerNomPrenom = TextEditingController();
  // Controlleur numéro de plomb //
  final _controllerNumeroPlomb = TextEditingController();
  // Controlleur entreprise client //
  final _controllerEntrepriseClient = TextEditingController();

  // Key formulaire //
  final _keyControllerForm = GlobalKey<FormState>();

  // Variable qui stocke les données du code QR //
  var dataNomPrenom;
  var dataPlomb;
  var dataEntrepriseClient;
  var dataBLBEntreprise = 'Entreprise de déménagement : BLB Transfert';
  var dataNomField = 'Nom et prénom : ';
  var dataPlombField = "Numéros de plomb : ";
  var dataEntrepriseClientFied = "Entreprise du client : ";

  // Fonction Formulaire //
  Future<void> qrcodeForm() async {
    final _formState = _keyControllerForm.currentState;
    if (_formState!.validate()) {
      _formState.save();
      try {
        setState(() {
          dataNomPrenom = _controllerNomPrenom.text;
          dataPlomb = _controllerNumeroPlomb.text;
          dataEntrepriseClient = _controllerEntrepriseClient.text;
        });
        fToast.showToast(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Theme.of(context).shadowColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: Theme.of(context).hintColor,),
                const SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Text(
                    "QR code généré avec succès !",
                    style: TextStyle(
                      color: Theme.of(context).hintColor
                    ),
                  ),
                )
              ],
            ),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 4)
        );
        _formState.reset();
      } catch (e) {
        // ignore: avoid_print
        print(e.hashCode);
      }
    }
  }

  // Permission galerie téléphone //
  set permissionGranted(bool permissionGranted) {}

  // Fonction capture d'écran //
  void _takeScreenShot() {
    // ignore: unused_local_variable
    var _imageFile;
    _captureEcran.capture().then((image) async {
      setState(() {
        _imageFile = image;
      });
      // ignore: unused_local_variable
      final result = await ImageGallerySaver.saveImage(image!);
      fToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Theme.of(context).shadowColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: Theme.of(context).hintColor,),
              const SizedBox(
                width: 12.0,
              ),
              Flexible(
                child: Text(
                  "QR code enregistré avec succès !",
                  style: TextStyle(
                    color: Theme.of(context).hintColor
                  ),
                ),
              )
            ],
          ),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 4)
      );
    });
  }

  // Toast Message
  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        title: const Text('Créateur de QR Codes'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              left: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05,
            ),
          child: Form(
            key: _keyControllerForm,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Scanner');
                  },
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: Theme.of(context).primaryColor,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double?>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).primaryColor)
                      )
                    ),
                  ),
                  label: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Scanner un QR code',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18
                      ),
                    ),
                  )
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Veuillez compléter ce champ.';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  controller: _controllerNomPrenom,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Color.fromRGBO(23, 74, 150, 1),
                        size: 22,
                      ),
                      splashRadius: 15,
                      tooltip: "Effacer le texte",
                      onPressed: () {
                        // ignore: unnecessary_null_comparison
                        if (_controllerNomPrenom != null) {
                          _controllerNomPrenom.clear();
                        }
                        return;
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    labelText: 'Nom et prénom du client',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                    hintText: 'Entrer un nom et un prénom',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Veuillez compléter ce champ.';
                    }
                    return null;
                  },
                  controller: _controllerNumeroPlomb,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Color.fromRGBO(23, 74, 150, 1),
                        size: 22,
                      ),
                      splashRadius: 15,
                      tooltip: "Effacer le texte",
                      onPressed: () {
                        // ignore: unnecessary_null_comparison
                        if (_controllerNumeroPlomb != null) {
                          _controllerNumeroPlomb.clear();
                        }
                        return;
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.format_list_numbered,
                      color: Theme.of(context).primaryColor,
                    ),
                    labelText: 'Numéro de plomb',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                    hintText: 'Entrer un numéro de plomb',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Veuillez compléter ce champ.';
                    }
                    return null;
                  },
                  controller: _controllerEntrepriseClient,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Color.fromRGBO(23, 74, 150, 1),
                        size: 22,
                      ),
                      splashRadius: 15,
                      tooltip: "Effacer le texte",
                      onPressed: () {
                        // ignore: unnecessary_null_comparison
                        if (_controllerEntrepriseClient != null) {
                          _controllerEntrepriseClient.clear();
                        }
                        return;
                      },
                    ),
                    prefixIcon: Icon(
                      Icons.business,
                      color: Theme.of(context).primaryColor,
                    ),
                    labelText: 'Entreprise du client',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                    hintText: 'Renseigner une entreprise',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                ElevatedButton(
                  onPressed: () {
                    if(_keyControllerForm.currentState!.validate()) {
                      qrcodeForm();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double?>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).primaryColor)
                      )
                    ),
                  ),
                  child: Text(
                    'Créer le QR code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18
                    ),
                  )
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Screenshot(
                  controller: _captureEcran,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        QrImage(
                          data: "${dataBLBEntreprise}\n${dataNomField}$dataNomPrenom\n${dataPlombField}$dataPlomb\n${dataEntrepriseClientFied}$dataEntrepriseClient",
                          version: QrVersions.auto,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Theme.of(context).primaryColor,
                          size: 200.0,
                        ),
                        Text(
                          (() {
                            if (dataPlomb == null) {
                              return "QR code non défini";
                            } else {
                              return "${dataPlombField}$dataPlomb";
                            }
                          })(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                ElevatedButton(
                  onPressed: () async {
                    if (await Permission.storage.request().isGranted) {
                      setState(() {
                        permissionGranted = true;
                      });
                      _takeScreenShot();
                    } else if (await Permission.storage
                        .request()
                        .isPermanentlyDenied) {
                      await openAppSettings();
                    } else if (await Permission.storage
                        .request()
                        .isDenied) {
                      setState(() {
                        permissionGranted = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double?>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).primaryColor)
                      )
                    ),
                  ),
                  child: Text(
                    'Télécharger le QR code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}