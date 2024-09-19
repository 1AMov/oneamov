class Currency {
  String name;
  String symbol;
  String symbolNative;
  int decimalDigits;
  double rounding;
  String code;
  String namePlural;

  Currency(
      {required this.name,
      required this.symbol,
      required this.symbolNative,
      required this.decimalDigits,
      required this.rounding,
      required this.code,
      required this.namePlural});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "symbol": symbol,
      "symbolNative": symbolNative,
      "decimalDigits": decimalDigits,
      "rounding": rounding,
      "code": code,
      "namePlural": namePlural
    };
  }

  factory Currency.fromJson(Map<String, dynamic> doc) {
    return Currency(
        name: doc["name"],
        symbol: doc["symbol"],
        symbolNative: doc["symbolNative"],
        decimalDigits: doc["decimalDigits"],
        rounding: doc["rounding"],
        code: doc["code"],
        namePlural: doc["namePlural"]);
  }
}
