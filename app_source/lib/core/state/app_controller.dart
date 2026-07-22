import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/market_pair.dart';
import '../data/demo_data.dart';
import '../network/api_client.dart';
import '../network/api_config.dart';

class AppController extends ChangeNotifier {
  AppController({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;
  bool initialized = false;
  bool signedIn = false;
  bool loading = false;
  bool demoMode = !ApiConfig.isConfigured;
  String? error;
  String userName = 'Demo Trader';
  String userEmail = 'demo@sttrading.app';
  List<MarketPair> signals = DemoData.signals();
  List<MarketPair> history = DemoData.signals();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    signedIn = prefs.getBool('signedIn') ?? false;
    userName = prefs.getString('userName') ?? userName;
    userEmail = prefs.getString('userEmail') ?? userEmail;
    initialized = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      if (demoMode) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        userName = email.split('@').first;
        userEmail = email;
      } else {
        final result = await _api.login(email, password);
        final user = (result['user'] as Map?)?.cast<String, dynamic>();
        userName = user?['displayName']?.toString() ?? email.split('@').first;
        userEmail = user?['email']?.toString() ?? email;
      }
      signedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('signedIn', true);
      await prefs.setString('userName', userName);
      await prefs.setString('userEmail', userEmail);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    signedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('signedIn', false);
    notifyListeners();
  }

  Future<void> refreshSignals() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      if (demoMode) {
        await Future<void>.delayed(const Duration(milliseconds: 650));
        signals = DemoData.signals();
      } else {
        history = await _api.history();
        signals = history.take(12).toList();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> runScan({
    required double minimumConfidence,
    required String market,
  }) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      if (demoMode) {
        await Future<void>.delayed(const Duration(milliseconds: 900));
        signals = DemoData.signals()
            .where((item) =>
                (market == 'ALL' || item.market == market) &&
                item.confidence >= minimumConfidence)
            .toList();
      } else {
        signals = await _api.scan(
          minimumConfidence: minimumConfidence,
          market: market,
        );
        history = [...signals, ...history];
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
