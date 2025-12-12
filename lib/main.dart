import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windenergy/features/presentation/pages/ajouter_eolienne.dart';
import 'package:windenergy/features/presentation/pages/authentification_page.dart';
import 'package:windenergy/features/presentation/pages/enregistrer_page.dart';
import 'package:windenergy/features/presentation/pages/liste_eoliennes.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(url: dotenv.get("SUPABASE_URL"), anonKey: dotenv.get("SUPABASE_KEY"));
  di.init();
  runApp(
    MaterialApp(
      title: 'windenergy',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => AuthentificationPage(),
        '/enregistrer': (BuildContext context) => EnregistrerPage(),
        '/liste_eolienne': (BuildContext context) => ListeEoliennesPage(),
        '/eolienne': (BuildContext context) => Container(),
        '/ajouter_eolienne': (BuildContext context) => AjouterEoliennePage(),
      },
    ),
  );
}
