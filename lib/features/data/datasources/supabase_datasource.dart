import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windenergy/core/exceptions/exceptions.dart';
import 'package:windenergy/core/resultat/resultat.dart';
import 'package:windenergy/features/data/datasources/datasources.dart';
import 'package:windenergy/features/data/models/models.dart';

class SupabaseDatasource extends DatabaseDatasource {
  SupabaseClient client;

  SupabaseDatasource(this.client);

  @override
  FutureResultat ajouterEolienne(String numeroSerie) async {
    try {
      await client.from('eoliennes').insert({
        "numero_serie": numeroSerie,
      }); // insère l'éoliènne dans la base de donnée

      var resultat = await client
          .from('eoliennes')
          .select()
          .eq(
            "numero_serie",
            numeroSerie,
          ); // selectionne la nouvelle éoliènne de la base de donnée. C'est important pour afficher le hash de sécurité dans l'interface.

      var eolienne = resultat[0];

      return Succes(eolienne);
    } catch (e) {
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    }
  }

  @override
  FutureResultat authentifier(String email, String motDePasse) async {
    try {
      var rep = await client.auth.signInWithPassword(
        password: motDePasse,
        email: email,
      ); // Authentifie l'utilisateur avec un mot de passe. Cette interaction se fait avec la table auth.users qui est une table système.
      if (rep.user != null) {
        // Dans le cas où nous avons besoin d'afficher le profil de l'utilisateur, il sera important de selection les informations de notre table utilisateurs en utilisant comme filtre le champ authId qui doit le même que rep.user!.id
        return Succes(true);
      }
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    } on AuthException {
      throw ServerException(message: "Les paramètres saisis sont incorrect");
    } catch (e) {
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    }
  }

  @override
  FutureResultat consulterEtatEolienne(String numeroSerie) async {
    try {
      var resultat = await client
          .from('eoliennes_view')
          .select()
          .eq('numero_serie', numeroSerie);
      var eolienne = resultat[0];
      return Succes(EolienneModel.fromJSON(eolienne));
    } catch (e) {
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    }
  }

  @override
  FutureResultat consulterListeEoliennes() async {
    try {
      var resultat = await client.from('eoliennes_view').select();
      var eoliennes = List<EolienneModel>.empty(growable: true);

      for (var json in resultat) {
        eoliennes.add(EolienneModel.fromJSON(json));
      }
      return Succes(eoliennes);
    } catch (e) {
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    }
  }

  @override
  FutureResultat enregistrer(
    String email,
    String nom,
    String prenom,
    String motDePasse,
  ) async {
    try {
      var rep = await client.auth.signUp(
        password: motDePasse,
        email: email,
        data: {'nom': nom, 'prenom': prenom},
      ); // Enregistre l'utilisateur avec un mot de passe. Comme nom et prenom ne sont pas des colonnes de la table auth.users, ils sont envoyés dans le champ data.
      if (rep.user != null) {
        // Dans le cas où nous avons besoin d'afficher le profil de l'utilisateur, il sera important de selection les informations de notre table utilisateurs en utilisant comme filtre le champ authId qui doit le même que rep.user!.id
        return Succes(true);
      }
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    } on AuthWeakPasswordException catch (e) {
      throw ServerException(message: "Le mot de passe est trop faible.");
    } on AuthException catch (e) {
      var message = "Une erreur s'est produite sur le serveur";
      if (e.code == "user_already_exists") {
        message = "Erreur. L'utilisateur existe déjà";
      } else if (e.code == "weak_password") {
        message = "Erreur. Le mot de passe est trop faible";
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    }
  }

  @override
  FutureResultat supprimerEolienne(String numeroSerie) async {
    try {
      await client.from('eoliennes').delete().eq(('id'), numeroSerie);
      return Succes(true);
    } catch (e) {
      throw ServerException(
        message: "Une erreur s'est produite sur le serveur",
      );
    }
  }
}
