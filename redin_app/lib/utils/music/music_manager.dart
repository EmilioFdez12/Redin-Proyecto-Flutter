import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

///
class AudioManager extends WidgetsBindingObserver {
  final AudioPlayer _backgroundMusic = AudioPlayer();
  final AudioPlayer _racePlayer = AudioPlayer();
  final AudioPlayer _victoryPlayer = AudioPlayer();
  final AudioPlayer _failPlayer = AudioPlayer();
  final AudioPlayer _roulettePlayer = AudioPlayer();

  double _backgroundMusicVolume = 1.0;

  AudioManager() {
    _initAppLifecycleListener();
  }

  // Inicializa el listener del ciclo de vida de la aplicación
  void _initAppLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void initialize() {
    print("AudioManager inicializado");
  }

  /// Reproduce la música de fondo
  Future<void> playBackgroundMusic() async {
    await _backgroundMusic.play(AssetSource('audio/casino.ogg'));
    _backgroundMusic.setReleaseMode(ReleaseMode.loop);
    _backgroundMusic.setVolume(_backgroundMusicVolume);
  }

  /// Baja el volumen de la música de fondo a 0
  Future<void> muteBackgroundMusic() async {
    _backgroundMusicVolume = _backgroundMusic.volume;
    await _backgroundMusic.setVolume(0);
  }

  /// Restaura el volumen de la música de fondo
  Future<void> unmuteBackgroundMusic() async {
    await _backgroundMusic.setVolume(_backgroundMusicVolume);
  }

  // Reproduce la música de la ruleta
  Future<void> playHorseMusic() async {
    await _racePlayer.play(AssetSource('audio/horse/horse_racing.ogg'));
  }

  // Detiene la música de la ruleta
  Future<void> stopHorseMusic() async {
    await _racePlayer.stop();
  }

  // Reproduce el sonido de victoria
  Future<void> playVictorySound() async {
    await _victoryPlayer.play(AssetSource('audio/roulette/win.ogg'));
  }

  //Reproduce la música de la ruleta
  Future<void> playRouletteBall() async {
    await _roulettePlayer.play(AssetSource('audio/roulette/ball_sound.ogg'));
    _roulettePlayer.setReleaseMode(ReleaseMode.loop);
  }

  // Detiene la música de la ruleta
  Future<void> stopRouletteMusic() async {
    await _roulettePlayer.stop();
  }

  // Reproduce la música de la ruleta
  Future<void> playFailSound() async {
    await _failPlayer.play(AssetSource('audio/fail_sound.ogg'));
  }

  // Libera los recursos
  void dispose() {
    _backgroundMusic.dispose();
    _racePlayer.dispose();
    _victoryPlayer.dispose();
    _roulettePlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_backgroundMusic.state != PlayerState.playing) {
          playBackgroundMusic();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        if (_backgroundMusic.state == PlayerState.playing) {
          muteBackgroundMusic();
        }
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
