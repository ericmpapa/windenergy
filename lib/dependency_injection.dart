import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windenergy/features/data/datasources/datasources.dart';
import 'package:windenergy/features/data/datasources/supabase_datasource.dart';
import 'package:windenergy/features/data/repositories/eolienne_repository_impl.dart';
import 'package:windenergy/features/domain/repositories/eolienne_repository.dart';
import 'package:windenergy/features/domain/usecases/authentification.dart';
import 'package:windenergy/features/domain/usecases/consulter_etat_eolienne.dart';
import 'package:windenergy/features/domain/usecases/consulter_liste_eoliennes.dart';
import 'package:windenergy/features/domain/usecases/gerer_eolienne.dart';
import 'package:windenergy/features/presentation/blocs/blocks.dart';

var sl = GetIt.instance;

void init() {

  // API, Base de données etc.
  sl.registerFactory<SupabaseClient>(() => Supabase.instance.client);

  // Datasources
  sl.registerFactory<DatabaseDatasource>(() => SupabaseDatasource(sl()));

  // Registres
  sl.registerFactory<EolienneRepository>(() => EolienneRepositoryImpl(sl()));

  // Cas d'utilisatons
  sl.registerFactory<Authentifier>(() => Authentifier(repository: sl()));
  sl.registerFactory<Enregistrer>(() => Enregistrer(repository: sl()));
  sl.registerFactory<AjouterEolienne>(() => AjouterEolienne(repository: sl()));
  sl.registerFactory<ConsulterEtatEolienne>(
    () => ConsulterEtatEolienne(repository: sl()),
  );
  sl.registerFactory<ConsulterListeEoliennes>(
    () => ConsulterListeEoliennes(repository: sl()),
  );

  sl.registerFactory<SupprimerEolienne>(
    () => SupprimerEolienne(repository: sl()),
  );

  // Blocs

  sl.registerFactory<AuthentifierBloc>(
    () => AuthentifierBloc(sl()),
  );

  sl.registerFactory<EnregistrerBloc>(
    () => EnregistrerBloc(sl()),
  );
  sl.registerFactory<AjouterEolienneBloc>(
    () => AjouterEolienneBloc(sl()),
  );
  sl.registerFactory<ConsulterEtatEolienneBloc>(
    () => ConsulterEtatEolienneBloc(sl()),
  );

  sl.registerFactory<ConsulterListeEoliennesBloc>(
    () => ConsulterListeEoliennesBloc(sl()),
  );

  sl.registerFactory<SupprimerEolienneBloc>(
    () => SupprimerEolienneBloc(sl()),
  );
}
