class ApiConstants {
  static const String supabaseUrl = 'https://lbawrbtggvaqzviufhie.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxiYXdyYnRnZ3ZhcXp2aXVmaGllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY5MTI4OTcsImV4cCI6MjA2MjQ4ODg5N30.6NAIhzi-bPGFgmEJ4oSUd553wT73SJD-nkt9-DjU67M';
  static const String mapboxAccessToken = 'YOUR_MAPBOX_ACCESS_TOKEN';

  // API Endpoints
  static const String baseUrl = '$supabaseUrl/rest/v1';
  static const String authUrl = '$supabaseUrl/auth/v1';

  // Storage Buckets
  static const String profileImagesBucket = 'profile-images';
  static const String kycDocumentsBucket = 'kyc-documents';
}