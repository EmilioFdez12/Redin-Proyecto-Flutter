import 'package:flutter/material.dart';
import 'package:redin_app/utils/database/crud.dart';

/// Proveedor de saldo que gestiona el estado del saldo del usuario.
/// Esta clase se encarga de cargar, actualizar y notificar cambios en el saldo.
/// Utiliza la clase [Crud] para interactuar con la base de datos.
class BalanceProvider extends ChangeNotifier {
  int _balance = 0;
  final Crud _dbHelper = Crud();

  /// Constructor de la clase [BalanceProvider].
  /// Cargamos el saldo inicial desde la base de datos al iniciar.
  BalanceProvider() {
    _loadBalance();
  }

  /// Getter para obtener el saldo actual.
  int get balance => _balance;

  /// Carga el saldo desde la base de datos y notifica a los listeners.
  Future<void> _loadBalance() async {
    _balance = await _dbHelper.getBalance(); // Obtiene el saldo de la base de datos
    notifyListeners(); // Notifica a los listeners que el saldo ha cambiado
  }

  /// Añade una cantidad específica de monedas al saldo actual.
  /// 
  /// [amount]: La cantidad de monedas a añadir.
  Future<void> addCoins(int amount) async {
    _balance += amount;
    await _dbHelper.updateBalance(_balance); 
    notifyListeners();
  }

  /// Resta una cantidad específica de monedas del saldo actual.
  /// 
  /// [amount]: La cantidad de monedas a restar.
  Future<void> subtractCoins(int amount) async {
    if (_balance >= amount) {
      _balance -= amount;
      await _dbHelper.updateBalance(_balance);
      notifyListeners();
    }
  }
}