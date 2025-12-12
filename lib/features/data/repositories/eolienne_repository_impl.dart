import 'package:windenergy/core/exceptions/exceptions.dart';
import 'package:windenergy/core/resultat/resultat.dart';
import 'package:windenergy/features/data/datasources/datasources.dart';
import 'package:windenergy/features/domain/repositories/eolienne_repository.dart';

class EolienneRepositoryImpl extends EolienneRepository {
  DatabaseDatasource databaseDatasource;

  EolienneRepositoryImpl(this.databaseDatasource);

  @override
  FutureResultat ajouterEolienne(String numeroSerie) async {
    try {
      return await databaseDatasource.ajouterEolienne(numeroSerie);
    } on ServerException catch (e) {
      return Echec(message: e.message);
    }
  }

  @override
  FutureResultat authentifier(String email, String motDePasse) async {
    try {
      return await databaseDatasource.authentifier(email, motDePasse);
    } on ServerException catch (e) {
      return Echec(message: e.message);
    }
  }

  @override
  FutureResultat consulterEtatEolienne(String numeroSerie) async {
    try {
      return await databaseDatasource.consulterEtatEolienne(numeroSerie);
    } on ServerException catch (e) {
      return Echec(message: e.message);
    }
  }

  @override
  FutureResultat consulterListeEoliennes() async {
    try {
      return await databaseDatasource.consulterListeEoliennes();
    } on ServerException catch (e) {
      return Echec(message: e.message);
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
      return await databaseDatasource.enregistrer(
        email,
        nom,
        prenom,
        motDePasse,
      );
    } on ServerException catch (e) {
      return Echec(message: e.message);
    }
  }

  @override
  FutureResultat supprimerEolienne(String numeroSerie) async {
    try {
      return await databaseDatasource.supprimerEolienne(numeroSerie);
    } on ServerException catch (e) {
      return Echec(message: e.message);
    }
  }
}
