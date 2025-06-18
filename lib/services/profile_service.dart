import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProfileService {
  static const String _baseUrl =
      'https://gowalletapp.com/php/update_profile.php';

  static Future<Map<String, dynamic>> updateProfile({
    required String phone,
    required String field,
    required dynamic value,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      request.fields['phone'] = phone;
      request.fields['field'] = field;

      if (imageFile != null && field == 'profile_image') {
        request.files.add(await http.MultipartFile.fromPath(
          'value',
          imageFile.path,
        ));
      } else {
        request.fields['value'] = value.toString();
      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseData = json.decode(responseString);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update profile'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while updating profile: $e'
      };
    }
  }
}
