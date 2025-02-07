import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:redin_app/ui/screens/menu_screen.dart';
import 'package:redin_app/utils/database/balance.dart';
import 'package:redin_app/utils/music/music_manager.dart';

/// Punto de entrada de la aplicación.
/// Configura la orientación de la pantalla, el estilo de la barra de estado,
/// y proporciona las instancias de [AudioManager] y [BalanceProvider] a toda la aplicación.
void main() {
  // Aseguramos que Flutter esté inicializado antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized();

  // Creamos una única instancia de AudioManager y la inicializamos
  final audioManager = AudioManager();
  audioManager.initialize();

  // Configuramos la orientación de la pantalla para que sea solo vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configuramos el estilo de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0C0C0C), 
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Iniciamos la aplicación con un MultiProvider para proporcionar dependencias
  runApp(
    MultiProvider(
      providers: [
        Provider<AudioManager>.value(value: audioManager),
        ChangeNotifierProvider(create: (context) => BalanceProvider()),
      ],
      child: const Redin(),
    ),
  );
}

/// Widget principal de la aplicación.
/// Define el tema y la pantalla inicial de la aplicación.
class Redin extends StatelessWidget {
  const Redin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Pantalla principal menu screen
      home: MenuScreen(),
    );
  }
}