import 'package:get/get.dart';
import 'package:lekra/data/repositories/kyc_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycController extends GetxController implements GetxService {
  final KycRepo kycRepo;
  final SharedPreferences sharedPreferences;

  KycController({required this.kycRepo, required this.sharedPreferences});
}
