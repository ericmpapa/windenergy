import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:windenergy/features/presentation/blocs/blocks.dart';
import 'package:windenergy/features/presentation/blocs/events.dart';
import 'package:windenergy/features/presentation/blocs/states.dart';
import 'package:windenergy/features/presentation/widgets/logo.dart';
import 'package:windenergy/features/presentation/widgets/windenergy_button.dart';
import 'package:windenergy/features/presentation/widgets/windenergy_textfield.dart';
import 'package:windenergy/ui/couleurs.dart';
import 'package:windenergy/ui/utils.dart';

class EnregistrerPage extends StatefulWidget {

  EnregistrerPage({super.key});

  @override
  State<EnregistrerPage> createState() => _EnregistrerPageState();
}

class _EnregistrerPageState extends State<EnregistrerPage> {
  final sl = GetIt.instance;

  final emailController = TextEditingController();

  final nomController = TextEditingController();

  final prenomController = TextEditingController();

  final motDePasseController = TextEditingController();

  final confirmerMotDePasseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: couleurFond,
        child: BlocProvider(
          // Est le widget qui permet d'interagir avec le bloc. Il est à l'écoute des évènements émis et change l'interface en fonction.
          create: (context) => sl<EnregistrerBloc>(),
          child: BlocListener<EnregistrerBloc, WindenergyState>(
            listener: (context, state) {
              if (state is EchecState) {
                afficherMessage(context, state.message, true);
              } else if (state is SuccesState) {
                afficherMessage(context, "Enregistrement réussi", false);
                Navigator.of(context).pushReplacementNamed('/liste_eolienne');
              }
            },
            child: BlocBuilder<EnregistrerBloc, WindenergyState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return afficherLoader(context);
                } else if (state is SuccesState) {
                  //Navigator.of(context).pushReplacementNamed('liste_eolienne');
                }
                return afficherFormulaire(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget afficherLoader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
      child: Column(
        children: [
          SizedBox(width: 25, height: 25, child: CircularProgressIndicator(
            color: couleurPrincipale,
          )),
          SizedBox(height: 10),
          Text(
            "connexion",
            style: GoogleFonts.inter(fontSize: 14, color: couleurPrincipale),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView afficherFormulaire(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        //constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(20),

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
            WindenergyTextField(hintText: "email", controller: emailController),
            SizedBox(height: 20),
            Text(
              "Nom",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: couleurPrincipale,
              ),
            ),
            SizedBox(height: 10),
            WindenergyTextField(hintText: "nom", controller: nomController),
            SizedBox(height: 20),
            Text(
              "Prenom",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: couleurPrincipale,
              ),
            ),
            SizedBox(height: 10),
            WindenergyTextField(
              hintText: "prenom",
              controller: prenomController,
            ),
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
            WindenergyTextField(
              hintText: "mot de passe",
              obscureText: true,
              controller: motDePasseController,
            ),
            SizedBox(height: 20),
            Text(
              "Confirmer mot de passe",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: couleurPrincipale,
              ),
            ),
            SizedBox(height: 10),
            WindenergyTextField(
              hintText: "confirmer mot de passe",
              obscureText: true,
              controller: confirmerMotDePasseController,
            ),

            SizedBox(height: 30),
            WindenergyButton(
              libelle: "s'enregistrer",
              onPressed: () {
                final email = emailController.text;
                final nom = nomController.text;
                final prenom = prenomController.text;
                final motDePasse = motDePasseController.text;
                final confirmerMotDePasse = confirmerMotDePasseController.text;
                if (email.isEmpty) {
                  afficherMessage(context, "Le champ E-mail est vide", true);
                } else if (nom.isEmpty) {
                  afficherMessage(context, "Le champ Nom est vide", true);
                } else if (prenom.isEmpty) {
                  afficherMessage(context, "Le champ Prenom est vide", true);
                } else if (motDePasse.isEmpty) {
                  afficherMessage(
                    context,
                    "Le champ Mot de passe est vide",
                    true,
                  );
                } else if (motDePasse != confirmerMotDePasse) {
                  afficherMessage(
                    context,
                    "Les mots de passe ne concordent pas",
                    true,
                  );
                } else {
                  BlocProvider.of<EnregistrerBloc>(context).add(
                    EnregistrerEvent(
                      email: email,
                      nom: nom,
                      prenom: prenom,
                      motDePasse: motDePasse,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              "déjà enregistré?",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: couleurPrincipale, fontSize: 14),
            ),
            SizedBox(height: 20),
            WindenergyButton(
              libelle: "se connecter",
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
