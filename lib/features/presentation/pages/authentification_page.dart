import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:windenergy/features/presentation/widgets/logo.dart';
import 'package:windenergy/features/presentation/widgets/windenergy_button.dart';
import 'package:windenergy/features/presentation/widgets/windenergy_textfield.dart';
import 'package:windenergy/ui/couleurs.dart';

class AuthentificationPage extends StatelessWidget {
  const AuthentificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(20),
        color: couleurFond,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Logo(),
            SizedBox(height: 50),
            Text(
              "E-mail",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: couleurPrincipale,
              ),
            ),
            SizedBox(height: 10),
            WindenergyTextField(hintText: "email"),
            SizedBox(height: 20),
            Text(
              "Mot de passe",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: couleurPrincipale,
              ),
            ),
            SizedBox(height: 10),
            WindenergyTextField(hintText: "mot de passe", obscureText: true),
            SizedBox(height: 30),
            WindenergyButton(libelle: "s'authentifier", onPressed: () {}),
            SizedBox(height: 20),
            Text(
              "Pas encore enregistré?",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: couleurPrincipale, fontSize: 14),
            ),
            SizedBox(height: 20),
            WindenergyButton(
              libelle: "s'enregistrer",
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/enregistrer');
              },
            ),
          ],
        ),
      ),
    );
  }
}
