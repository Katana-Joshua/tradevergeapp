// lib/core/utils/image_utils.dart
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static final _picker = ImagePicker();

  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? quality,
  }) async {
    try {
      return await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? quality,
  }) async {
    try {
      return await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );
    } catch (e) {
      return [];
    }
  }
}