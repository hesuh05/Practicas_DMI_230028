class ApiConfig {
  const ApiConfig._();

  static const coverrApiKey = String.fromEnvironment('COVERR_API_KEY');
  static const pixabayApiKey = String.fromEnvironment('PIXABAY_API_KEY');
}
