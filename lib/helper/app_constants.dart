import 'package:msbm_assessment_test/helper/regions.dart';

class AppConstants {
  // It cannot be statically initialized.
  AppConstants._();

  /// The name of the app.
  static const String appName = 'MSBM Assessment Test';

  // This should always match the build number.
  static const double appVersion = 1;

  // This is fine.
  static const String fontFamily = 'Archivo';

  /// The base URL of the production server.
  static const String liveBaseUrl = 'https://api.msbm.org.uk';
  static const String testBaseUrl = 'https://dev.api.msbm.org.uk';

  /// This is fine.
  static const String latitude = "X-MSBM-Latitude";
  static const String longitude = "X-MSBM-Longitude";
  static const String localization = "X-MSBM-Locale";
  static const String device = "X-MSBM-Device";
  static const String session = "X-MSBM-Auth";

  /// The list of countries that this version of the app has service in.
  static const servedRegions = [
    // The country here.
    Country(
      name: "Togo",
      shortCode: "TG",
      dialCode: "+228",
      flag: CountryFlags.tg,
    ),

    // The country there.
    Country(
      name: "Nigeria",
      shortCode: "NG",
      dialCode: "+234",
      flag: CountryFlags.ng,
    ),

    // The country there.
    Country(
      name: "United Kingdom",
      shortCode: "UK",
      dialCode: "+44",
      flag: CountryFlags.uk,
    ),

    // The country there.
    Country(
      name: "United States of America",
      shortCode: "USA",
      dialCode: "+1",
      flag: CountryFlags.usa,
    ),
  ];
}
