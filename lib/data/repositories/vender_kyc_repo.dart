import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VenderKycRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  VenderKycRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> venderKycBasicDetails({
    required Map<String, dynamic> data,
  }) async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.postData(
      AppConstants.postVenderKycBasicDetails,
      "venderKycBasicDetails",
      data,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
    );
  }

  Future<Response> venderKycDocumentDetails({
    required Map<String, dynamic> data,
  }) async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.postData(
      AppConstants.postVenderKycDocumentDetails,
      "venderKycDocumentDetails",
      data,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
    );
  }

  Future<Response> venderKycBusinessInfo({
    required Map<String, dynamic> data,
  }) async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.postData(
      AppConstants.postVenderKycBusinessInfo,
      "venderKycBusinessInfo",
      data,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
    );
  }

  // ============================================================
  // LIVE SHOP VERIFICATION - MULTIPART
  // ============================================================

  Future<Response> venderKycLiveShopVerification({
    required String documentType,
    required String latitude,
    required String longitude,
    required String documentFilePath,
  }) async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    final formData = FormData({
      'document_type': documentType,
      'latitude': latitude,
      'longitude': longitude,
      'document_file': MultipartFile(
        documentFilePath,
        filename: documentFilePath.split('/').last,
      ),
    });

    return await apiClient.postData(
      AppConstants.postVenderKycLiveShopVerification,
      "venderKycLiveShopVerification",
      formData,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
    );
  }

  Future<Response> venderKycBankDetails({
    required Map<String, dynamic> data,
  }) async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.postData(
      AppConstants.postVenderKycBankDetails,
      "venderKycBankDetails",
      data,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
    );
  }

  // ============================================================
  // KYC DOCUMENT UPLOAD
  // ============================================================

  Future<Response> venderKycKYCDocUpload({
    required FormData data,
  }) async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.postData(
      AppConstants.postVenderKycKYCDocUpload,
      'venderKycKYCDocUpload',
      data,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
    );
  }

  Future<Response> venderKycStatus() async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.getData(
      AppConstants.getVenderKycStatus,
      "venderKycStatus",
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> venderKycDetail() async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.getData(
      AppConstants.venderKycDetail,
      "venderKycDetail",
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> venderKycFinalSubmit({
    required Map<String, dynamic> data,
  }) async {
    final apiToken = sharedPreferences.getString(AppConstants.apiToken) ?? '';

    return await apiClient.postData(
      AppConstants.postVenderKycFinalSubmit,
      "venderKycFinalSubmit",
      data,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
    );
  }
}
