class ApiConstants {
  static const String baseURL =
      "https://api.flutter-community.com/api/v1/advice";

  static const Map<String, String> baseHeader = {
    "content-type": "application/json"
  };

  static const generalFailureMessage =
      "Ups, something went wrong, please try again";
  static const serverFailureMessage = "Ups, API Error, please try again";
  static const cacheFailureMessage = "Ups, cache failed, please try again";
}
