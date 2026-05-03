import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppCurrency { thb, usd }

extension AppCurrencyX on AppCurrency {
  String get code {
    switch (this) {
      case AppCurrency.thb:
        return 'THB';
      case AppCurrency.usd:
        return 'USD';
    }
  }

  String get symbol {
    switch (this) {
      case AppCurrency.thb:
        return '฿';
      case AppCurrency.usd:
        return '\$';
    }
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, AppCurrency>(
  CurrencyNotifier.new,
);

class CurrencyNotifier extends Notifier<AppCurrency> {
  @override
  AppCurrency build() => AppCurrency.thb;

  void setCurrency(AppCurrency c) => state = c;
}
