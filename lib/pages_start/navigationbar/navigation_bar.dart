import 'package:blb_entreprise/pages_auth/services/methodUser.dart';
import 'package:blb_entreprise/pages_client/home/accueil.dart';
import 'package:blb_entreprise/pages_entreprise/dashboard/Admin/dashboardClientAdmin.dart';
import 'package:blb_entreprise/pages_entreprise/dashboard/Entreprise/dashboardClients.dart';
import 'package:blb_entreprise/pages_entreprise/dashboard/Admin/dashboardUtilisateurs.dart';
import 'package:blb_entreprise/pages_entreprise/devis/devis_PDF.dart';
import 'package:blb_entreprise/pages_entreprise/qrcreater/qrgenerate.dart';
import 'package:blb_entreprise/pages_globales/qrscanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BLBNavigationBar extends StatefulWidget {
  const BLBNavigationBar({ Key? key }) : super(key: key);

  @override
  _BLBNavigationBarState createState() => _BLBNavigationBarState();
}

class _BLBNavigationBarState extends State<BLBNavigationBar> {

  // Sélecteur de page //
  int _selectedIndexClient = 0;
  int _selectedIndexEntreprise = 2;
  int _selectedIndexAdmin = 0;
  int _selectedIndexApple = 0;

  // Page de navigation Clients //
  final List<Widget> _childrenIndexClient = [
    const BLBAccueil(),
    const BLBQrScanner()
  ];

  // Page de navigation Entreprises //
  final List<Widget> _childrenIndexEntreprise = [
    const BLBGenerationQRCode(),
    const BLBDevisPDF(),
    const BLBDashboardClient(),
  ];

  // Page de navigation Admins //
  final List<Widget> _childrenIndexAdmin = [
    const BLBDashboardClientAdmin(),
    const BLBDashBoardUtilisateurs(),
  ];

  // Page de navigation Apple //
  final List<Widget> _childrenIndexApple = [
    const BLBAccueil(),
    const BLBGenerationQRCode(),
    const BLBDevisPDF(),
    const BLBDashboardClientAdmin(),
    const BLBDashBoardUtilisateurs()
  ];

  // Client Modèle //
  User? user = FirebaseAuth.instance.currentUser;
  final userRoleEntreprise = MethodUser(role: 'entreprise');
  final userRoleClient = MethodUser(role: 'client');
  final userRoleAdmin = MethodUser(role: 'admin');
  final userRoleApple = MethodUser(role: 'apple');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Object>>(
      stream: FirebaseFirestore.instance.collection('utilisateurs_inscrit').doc(user!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> role) {
        if (role.hasError) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: SpinKitCircle(
                color: Theme.of(context).hintColor,
                size: 60,
              ),
            ),
          );
        }
        if(role.connectionState == ConnectionState.waiting) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: SpinKitCircle(
                color: Theme.of(context).hintColor,
                size: 60,
              ),
            ),
          );
        }
        if(role.hasData) {
          if(role.data!['role'] == userRoleClient.role) {
            return Scaffold(
              body: _childrenIndexClient[_selectedIndexClient],
              bottomNavigationBar: CustomNavigationBar(
                currentIndex: _selectedIndexClient,
                elevation: 5,
                iconSize: 28,
                onTap: (index) => setState(() => _selectedIndexClient = index),
                selectedColor: Theme.of(context).hintColor,
                unSelectedColor: Theme.of(context).hintColor.withOpacity(0.5),
                backgroundColor: Theme.of(context).primaryColor,
                items: <CustomNavigationBarItem>[
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.home),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),
            );
          }
        }
        if(role.hasData) {
          if(role.data!['role'] == userRoleEntreprise.role) {
            return Scaffold(
              body: _childrenIndexEntreprise[_selectedIndexEntreprise],
              bottomNavigationBar: CustomNavigationBar(
                currentIndex: _selectedIndexEntreprise,
                elevation: 5,
                iconSize: 28,
                onTap: (index) => setState(() => _selectedIndexEntreprise = index),
                selectedColor: Theme.of(context).hintColor,
                unSelectedColor: Theme.of(context).hintColor.withOpacity(0.5),
                backgroundColor: Theme.of(context).primaryColor,
                items: <CustomNavigationBarItem>[
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.qr_code_2),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.picture_as_pdf),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.dashboard),
                  ),
                  // CustomNavigationBarItem(
                  //   icon: const Icon(Icons.message),
                  // ),
                ],
              ),
            );
          }
        }
        if(role.hasData) {
          if(role.data!['role'] == userRoleAdmin.role) {
            return Scaffold(
              body: _childrenIndexAdmin[_selectedIndexAdmin],
              bottomNavigationBar: CustomNavigationBar(
                currentIndex: _selectedIndexAdmin,
                elevation: 5,
                iconSize: 28,
                onTap: (index) => setState(() => _selectedIndexAdmin = index),
                selectedColor: Theme.of(context).hintColor,
                unSelectedColor: Theme.of(context).hintColor.withOpacity(0.5),
                backgroundColor: Theme.of(context).primaryColor,
                items: <CustomNavigationBarItem>[
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.dashboard),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.space_dashboard),
                  ),
                ],
              ),
            );
          }
        }
        if(role.hasData) {
          if(role.data!['role'] == userRoleApple.role) {
            return Scaffold(
              body: _childrenIndexApple[_selectedIndexApple],
              bottomNavigationBar: CustomNavigationBar(
                currentIndex: _selectedIndexApple,
                elevation: 5,
                iconSize: 28,
                onTap: (index) => setState(() => _selectedIndexApple = index),
                selectedColor: Theme.of(context).hintColor,
                unSelectedColor: Theme.of(context).hintColor.withOpacity(0.5),
                backgroundColor: Theme.of(context).primaryColor,
                items: <CustomNavigationBarItem>[
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.home),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.qr_code_2),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.picture_as_pdf),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.dashboard),
                  ),
                  CustomNavigationBarItem(
                    icon: const Icon(Icons.space_dashboard),
                  ),
                ],
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}