class ApiConfig {
  const ApiConfig._();

  static const pexelsApiKey = String.fromEnvironment('PEXELS_API_KEY');
  static const pixabayApiKey = String.fromEnvironment('PIXABAY_API_KEY');
  static const vimeoAccessToken = String.fromEnvironment('VIMEO_ACCESS_TOKEN');
}
