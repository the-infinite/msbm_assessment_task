class CountryFlags {
  static const String ng = "assets/image/region/ng.svg";
  static const String tg = "assets/image/region/tg.svg";
  static const String uk = "assets/image/region/gb.svg";
  static const String usa = "assets/image/region/us.svg";
}

/// A class that represents a country as would be selectable in our country code
/// picker.
class Country {
  final String name;
  final String shortCode;
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
    required this.shortCode,
    required this.dialCode,
    required this.flag,
  });
}

