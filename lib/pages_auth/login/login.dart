import 'dart:async';
import 'package:blb_entreprise/pages_auth/services/methodFirebase.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BLBLoginPage extends StatefulWidget {
  const BLBLoginPage({ Key? key }) : super(key: key);

  @override
  _BLBLoginPageState createState() => _BLBLoginPageState();
}

class _BLBLoginPageState extends State<BLBLoginPage> {

  // Clé globale du formulaire //
  final _loginFormKey = GlobalKey<FormState>();
  final _motdepasseoublieKeyForm = GlobalKey<FormState>();

  // Variable de modification du formulaire //
  // ignore: unused_field
  late String _email, _motdepasse, emailMotdepasseOublie;
  TextEditingController email = TextEditingController();
  final TextEditingController _emailMotdepasseOublie = TextEditingController();

  // Affichage du mot de passe //
  bool passwordVisibility = false;

  // Affichage des méthodes //
  // Firebase activé par défaut au démarrage de l'application //
  bool firebaseMethodConnexion = true;
  bool motdepasseoublie = false;

  // Toast Message
  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  // Méthode connexion à Firebase //
  void login()  {
    final formState = _loginFormKey.currentState;
    if(formState!.validate()) {
      formState.save();
      try {
        if(_email.isNotEmpty && _motdepasse.isNotEmpty && _motdepasse.length > 6 && EmailValidator.validate(_email)) {
          MethodFirebase().connexionClientToFirebase(_email, _motdepasse).then((value) {
            formState.reset();
            Navigator.pushNamedAndRemoveUntil(context, 'NavigationBar', ModalRoute.withName('/'));
          }).catchError((error) {
            // Message d'erreur lors de la connexion//
            fToast.showToast(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Theme.of(context).errorColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close, color: Theme.of(context).hintColor,),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Flexible(
                      child: Text(
                        "La connexion a échoué, veuillez réessayer ou vérifier votre connexion internet.",
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
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  // Méthode Réinitialisation du mot de passe
  void motdepasseOublie() {
    try {
      MethodFirebase().resetPasswordForEmail(_emailMotdepasseOublie.text).whenComplete(() => {
        // Message de succès lors de la réinitialisation du mot de passe //
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
                    "Un e-mail de réinitialisation de mot de passe a été envoyé à l'adresse ${_emailMotdepasseOublie.text}",
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
        ),
        Timer(
          const Duration(seconds: 1),
          () => setState(() {
            // Désactivation du formulaire de réinitialisation du mot de passe
            motdepasseoublie = false;
            // Activation des méthodes de connexion
            firebaseMethodConnexion = true;
          }),
        )
      }).catchError((onError) {
        // Message d'erreur lors de la réinitialisation du mot de passe //
        fToast.showToast(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Theme.of(context).errorColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, color: Theme.of(context).hintColor,),
                const SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Text(
                    "Échec de l'envoi de l'e-mail, veuillez réessayer.",
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
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _loginFormKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.13),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/iconSignIn.png',
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                    firebaseMethodConnexion ? Column(
                      children: [
                        TextFormField(
                          controller: email,
                          validator: (input) {
                              if (input!.isNotEmpty) {
                                return EmailValidator.validate(input)
                                    // ignore: unnecessary_statements
                                    ? null
                                    : "Veuillez saisir une adresse mail valide";
                              }
                              if (input.isEmpty) {
                              return 'Veuillez saisir une adresse mail';
                              }
                              return null;
                            },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-@.]+$'))
                          ],
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSaved: (input) => _email = input!,
                          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
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
                                color: Theme.of(context).hintColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).hintColor,
                            ),
                            labelText: 'Adresse mail',
                            labelStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 18,
                            ),
                            hintText: 'exemple@gmail.com',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).hintColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                        TextFormField(
                          obscureText: !passwordVisibility,
                            validator: (input) {
                              if (input!.isEmpty) {
                              return 'Veuillez saisir un mot de passe';
                              } else if (input.isNotEmpty && input.length < 6) {
                                return 'Veuillez saisir un mot de passe plus long';
                              }
                              return null;
                            },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-=@,\.;<>?/:=+%*()!#&§%]+$'))
                          ],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSaved: (input) => _motdepasse = input!,
                          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
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
                                  color: Theme.of(context).hintColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(
                                Icons.password_outlined,
                                color: Theme.of(context).hintColor,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                  () => passwordVisibility = !passwordVisibility,
                                ),
                                child: Icon(
                                  passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              labelText: 'Mot de passe',
                              labelStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 18,
                              ),
                              hintText: 'Minimum 6 caractères',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).hintColor.withOpacity(0.6),
                              ),
                            ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                            onTap: () {
                              setState(() {
                                // Activation du formulaire de réinitialisation mot de passe
                                motdepasseoublie = true;
                                // Désactivation des méthodes de connexion
                                firebaseMethodConnexion = false;
                              });
                            },
                            child: Text(
                              'Mot de passe oublié ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).hintColor.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                        ElevatedButton(
                            onPressed: () async {
                              if (_loginFormKey.currentState!.validate()) {
                                return login();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: Theme.of(context).hintColor,
                                  )
                                )
                              ),
                              elevation: MaterialStateProperty.all(0),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              child: Text(
                                'Se connecter à BLB',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18,
                                ),
                              ),
                            )
                        ),
                      ],
                    ) : Container(),
                    motdepasseoublie ? Form(
                      key: _motdepasseoublieKeyForm,
                      child: Column(
                        children: [
                          Text(
                            'Réinitialisation du mot de passe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          TextFormField(
                            controller: _emailMotdepasseOublie,
                            validator: (input) {
                                if (input!.isNotEmpty) {
                                  return EmailValidator.validate(input)
                                      // ignore: unnecessary_statements
                                      ? null
                                      : "Veuillez saisir une adresse mail valide";
                                }
                                if (input.isEmpty) {
                                return 'Veuillez saisir une adresse mail';
                                }
                                return null;
                              },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-@.]+$'))
                            ],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onSaved: (input) => emailMotdepasseOublie = input!,
                            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
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
                                  color: Theme.of(context).hintColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).hintColor,
                              ),
                              labelText: 'Adresse mail',
                              labelStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 18,
                              ),
                              hintText: 'exemple@gmail.com',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).hintColor.withOpacity(0.6),
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_motdepasseoublieKeyForm.currentState!.validate()) {
                                    return motdepasseOublie();
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).primaryColor
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: Theme.of(context).hintColor,
                                      )
                                    )
                                  )
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(12),
                                  child: Text(
                                    'Réinitialiser',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              ),
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    // Désactivation du formulaire de réinitialisation mot de passe
                                    motdepasseoublie = false;
                                    // Activation des méthodes de connexion
                                    firebaseMethodConnexion = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 35,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ) : Container(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    Text(
                      'Vous n\'avez pas encore de compte ?',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, 'RegisterPage', ModalRoute.withName('/'));
                      },
                      child: Text(
                        'Inscrivez-vous ici',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  ],
                ),
              )
            ),
          ),
        ),
      )
    );
  }
}