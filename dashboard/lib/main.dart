import 'package:dashboard/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'const.dart';
import 'graphql/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load dot env
  await dotenv.load(fileName: ".env");
  hasuraServer = dotenv.env['HASURA_URL']!;
  hasuraWebSocketServer = dotenv.env['HASURA_WS_URL']!;
  hasuraAdminSecret = dotenv.env['HASURA_ADMIN_SECRET']!;

  // init hive
  await initHiveForFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: Config.initClient(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Web Dashboard Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
