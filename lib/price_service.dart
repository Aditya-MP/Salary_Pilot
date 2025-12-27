import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PriceService {
  static final PriceService _instance = PriceService._internal();
  factory PriceService() => _instance;
  PriceService._internal();

  final StreamController<Map<String, dynamic>> _priceController = StreamController.broadcast();
  Stream<Map<String, dynamic>> get priceStream => _priceController.stream;

  final Map<String, Map<String, dynamic>> _assets = {
    'Reliance Green Energy': {'price': 6720.0, 'change': 18.0},
    'Solana Green Lending': {'price': 4650.0, 'change': 3.2},
    'Cardano ESG Pool': {'price': 3200.0, 'change': 1.5},
    'SBI Magnum ESG': {'price': 2100.0, 'change': -0.8},
    'Digital Gold': {'price': 320.0, 'change': 0.9},
  };

  bool _isRunning = false;
  Timer? _timer;

  void startGlobalUpdates() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      final updatedPrices = <String, dynamic>{};
      
      _assets.forEach((name, data) {
        final randomChange = (Random().nextDouble() - 0.5) * 3; // -1.5% to +1.5%
        final newPrice = data['price']! * (1 + randomChange / 100);
        final newChange = data['change']! + randomChange;
        
        _assets[name] = {
          'price': newPrice,
          'change': newChange,
        };
        
        updatedPrices[name] = {
          'price': newPrice.round(),
          'change': newChange.toStringAsFixed(1),
        };
      });
      
      _priceController.add(updatedPrices);
    });
  }

  void stopUpdates() {
    _isRunning = false;
    _timer?.cancel();
  }

  Map<String, dynamic> getCurrentPrices() {
    final prices = <String, dynamic>{};
    _assets.forEach((name, data) {
      prices[name] = {
        'price': data['price']!.round(),
        'change': data['change'].toStringAsFixed(1),
      };
    });
    return prices;
  }
}