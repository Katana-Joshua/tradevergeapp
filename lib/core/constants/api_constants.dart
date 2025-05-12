class ApiConstants {
  static String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL');
  static String get supabaseAnonKey => const String.fromEnvironment('SUPABASE_ANON_KEY');
  static String get mapboxAccessToken => const String.fromEnvironment('MAPBOX_ACCESS_TOKEN');
  static String get googleMapsApiKey => const String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static String get flutterwavePublicKey => const String.fromEnvironment('FLUTTERWAVE_PUBLIC_KEY');

  // API Endpoints
  static String get baseUrl => '$supabaseUrl/rest/v1';
  static String get authUrl => '$supabaseUrl/auth/v1';

  // Storage Buckets
  static const String profileImagesBucket = 'profile-images';
  static const String kycDocumentsBucket = 'kyc-documents';
}