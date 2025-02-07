import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Clase que maneja la lógica del juego de cartas BlackJack.
/// Esta clase se encarga de gestionar las manos del jugador y del crupier,
/// y de realizar las operaciones para el desarrollo del juego.
class BlackJackGameLogic {
  /// Lista que almacena las cartas del jugador.
  List<String> playerHand = [];

  /// Lista que almacena las cartas del crupier.
  List<String> dealerHand = [];

  /// Indica si la partida ha terminado.
  bool gameOver = false;

  /// Almacena el resultado de la partida (ganar, perder, empate, etc.).
  String result = '';

  /// Indica si la carta oculta del crupier debe mostrarse.
  bool showDealerCard = false;

  /// Indica si es el turno del crupier.
  bool isDealerTurn = false;

  /// Indica si se está realizando el reparto inicial de cartas.
  bool isInitialDealing = true;

  /// Método para obtener una carta aleatoria de una baraja virtual.
  /// Utiliza la API de Random.org para generar un índice aleatorio que
  /// corresponde a una carta en la baraja.
  ///
  /// Devuelve un `String` que representa la carta obtenida.
  Future<String> drawCard() async {
    // Clave de la API
    const String apiK = '76bf02dd-2a49-4870-bd59-e631847b7a43'; 
    // URL de la API
    const String url = 'https://api.random.org/json-rpc/4/invoke'; 

    final Map<String, dynamic> requestBody = {
      "jsonrpc": "2.0",
      "method": "generateIntegers",
      "params": {
        "apiKey": apiK,
        "n": 1,
        "min": 0,
        "max": 51,
        "replacement": false,
        "base": 10
      },
      "id": 1
    };

    // Realiza la solicitud HTTP POST a la API
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    // Si la solicitud es exitosa, procesamos la respuesta
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
       // Obtenemos el índice de la carta
      final int cardIndex = data['result']['random']['data'][0];
      // Devolvemos la carta correspondiente al índice
      return _getCardFromIndex(cardIndex); 
    } else {
      throw Exception('Failed to load card');
    }
  }

  /// Método privado que convierte un índice en una carta específica.
  ///
  /// [index]: El índice de la carta en la baraja (0-51).
  /// Devuelve un `String` que representa la carta.
  String _getCardFromIndex(int index) {
    // Lista que representa una baraja de 52 cartas
    List<String> deck = [
      '2_of_diamonds', '3_of_diamonds', '4_of_diamonds', '5_of_diamonds', '6_of_diamonds',
      '7_of_diamonds', '8_of_diamonds', '9_of_diamonds', '10_of_diamonds', 'jack_of_diamonds',
      'queen_of_diamonds', 'king_of_diamonds', 'ace_of_diamonds', '2_of_hearts', '3_of_hearts',
      '4_of_hearts', '5_of_hearts', '6_of_hearts', '7_of_hearts', '8_of_hearts', '9_of_hearts',
      '10_of_hearts', 'jack_of_hearts', 'queen_of_hearts', 'king_of_hearts', 'ace_of_hearts',
      '2_of_clubs', '3_of_clubs', '4_of_clubs', '5_of_clubs', '6_of_clubs', '7_of_clubs',
      '8_of_clubs', '9_of_clubs', '10_of_clubs', 'jack_of_clubs', 'queen_of_clubs', 'king_of_clubs',
      'ace_of_clubs', '2_of_spades', '3_of_spades', '4_of_spades', '5_of_spades', '6_of_spades',
      '7_of_spades', '8_of_spades', '9_of_spades', '10_of_spades', 'jack_of_spades',
      'queen_of_spades', 'king_of_spades', 'ace_of_spades',
    ];
    return deck[index];
  }

  /// Calcula el valor total de una mano de cartas.
  ///
  /// [hand]: La lista de cartas de la mano a evaluar.
  /// Devuelve un `int` que representa el valor total de la mano.
  int calculateHandValue(List<String> hand) {
    int value = 0; 
    int aces = 0;

    // Recorremos cada carta en la mano
    for (var card in hand) {
      if (card.startsWith('ace')) {
        aces++;
        value += 11;
      } else if (card.startsWith('10') ||
          card.startsWith('jack') ||
          card.startsWith('queen') ||
          card.startsWith('king')) {
        value += 10;
      } else {
        value += int.parse(card[0]);
      }
    }

    // Ajustamos el valor de los ases si el total supera 21
    while (value > 21 && aces > 0) {
      value -= 10;
      aces--;
    }

    return value;
  }

  /// Verifica si el jugador tiene un Blackjack (21 con dos cartas).
  void checkForBlackjack() {
    if (calculateHandValue(playerHand) == 21 && playerHand.length == 2) {
      gameOver = true; // Finaliza el juego
      result = 'Blackjack! ¡Ganaste!'; // Establece el resultado
    }
  }

  /// Inicia una nueva partida, repartiendo las cartas iniciales.
  ///
  /// [onCardDrawn]: Callback que se ejecuta cada vez que se reparte una carta.
  Future<void> startGame(Function onCardDrawn) async {
    isInitialDealing = true;

    // Repartimos las cartas con animación y de una en una 
    playerHand.add(await drawCard());
    onCardDrawn();
    await Future.delayed(const Duration(milliseconds: 500));

    dealerHand.add(await drawCard());
    onCardDrawn();
    await Future.delayed(const Duration(milliseconds: 500));

    playerHand.add(await drawCard());
    onCardDrawn();
    await Future.delayed(const Duration(milliseconds: 500));

    dealerHand.add(await drawCard());
    onCardDrawn();
    isInitialDealing = false;
    // Verifica si el jugador tiene Blackjack
    checkForBlackjack(); 
  }

  /// Permite pedir una carta más siempre que se pueda 
  Future<void> hit() async {
    if (!gameOver && !isDealerTurn && !isInitialDealing) {
      playerHand.add(await drawCard());
      if (calculateHandValue(playerHand) > 21) {
        // Finalizamos el juego si el jugador se pasa de 21
        gameOver = true; 
        result = 'Te pasaste de 21. ¡Perdiste!';
      }
    }
  }

  /// Permite que el jugador se plante y pase el turno al crupier.
  Future<void> stand() async {
    if (!gameOver && !isDealerTurn && !isInitialDealing) {
       // Es el turno del crupier
      isDealerTurn = true;
      showDealerCard = true;

      // El crupier pide cartas hasta que su mano tenga un valor de al menos 17
      while (calculateHandValue(dealerHand) < 17) {
        // Espera antes de pedir otra carta
        await Future.delayed(const Duration(seconds: 1)); 
        dealerHand.add(await drawCard());
      }

      // Calculamos los valores finales de las manos
      int playerValue = calculateHandValue(playerHand);
      int dealerValue = calculateHandValue(dealerHand);

      // Determinamos el resultado de la partida
      if (dealerValue > 21) {
        result = 'El crupier se pasó. ¡Ganaste!';
      } else if (playerValue > dealerValue) {
        result = '¡Ganaste!';
      } else if (playerValue == dealerValue) {
        result = 'Empate.';
      } else {
        result = 'Perdiste.';
      }

      // Terminamos el juego
      gameOver = true; 
      isDealerTurn = false;
    }
  }
}