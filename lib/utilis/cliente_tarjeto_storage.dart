import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'cliente_tarjeto.dart';

class ClienteTarjetoStorage{
  static const String _keyCliente = "clienteTarjeto";

  // Guardar ClienteTarjeto
  Future<bool> saveCliente(ClienteTarjeto cliente) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = jsonEncode(cliente.toJson());
      return await prefs.setString(_keyCliente, jsonData);
    } catch (e) {
      print('Error al guardar cliente: $e');
      return false;
    }
  }

  // Obtener ClienteTarjeto
  Future<ClienteTarjeto?> getCliente() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonData = prefs.getString(_keyCliente);

      if (jsonData == null) return null;
      return ClienteTarjeto.fromJson(jsonDecode(jsonData));
    } catch (e) {
      print('Error al obtener cliente: $e');
      return null;
    }
  }

  // Eliminar ClienteTarjeto
  Future<bool> deleteCliente() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_keyCliente);
    } catch (e) {
      print('Error al eliminar cliente: $e');
      return false;
    }
  }
}