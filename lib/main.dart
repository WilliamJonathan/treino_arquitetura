import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treino_arquitetura/app/pages/cliente/stores/cliente_page_store.dart';
import 'package:treino_arquitetura/app/pages/consultar_cep/stores/consultar_cep_page_store.dart';
import 'package:treino_arquitetura/app/pages/exemplo/stores/exemplo_page_store.dart';
import 'package:treino_arquitetura/app/pages/splash_screen/splash_screen_page.dart';
import 'package:treino_arquitetura/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SplashScreenPage());

  await Future.delayed(const Duration(seconds: 2));

  const rotaInicial = AppRoutes.homePage;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExemploPageStore(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConsultarCepPageStore(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientePageStore(),
        ),
      ],
      child: const MyApp(rotaInicial: rotaInicial),
    ),
  );
}

/// Chave global para exibir SnackBars e diálogos fora do contexto de widget.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Widget raiz da aplicação.
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.rotaInicial});
  final String rotaInicial;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Treino Arquitetura',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 14, 66, 90),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: rotaInicial,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
