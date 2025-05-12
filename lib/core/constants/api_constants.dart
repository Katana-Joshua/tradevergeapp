import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get flutterwavePublicKey => dotenv.env['FLUTTERWAVE_PUBLIC_KEY'] ?? '';

  // API Endpoints
  static String get baseUrl => '$supabaseUrl/rest/v1';
  static String get authUrl => '$supabaseUrl/auth/v1';

  // Storage Buckets
  static const String profileImagesBucket = 'profile-images';
  static const String kycDocumentsBucket = 'kyc-documents';
}