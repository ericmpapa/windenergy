import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:windenergy/ui/couleurs.dart';

void afficherMessage(BuildContext context, String message, bool alerte){
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: alerte? couleurAlerte:couleurSucces,
      content: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}