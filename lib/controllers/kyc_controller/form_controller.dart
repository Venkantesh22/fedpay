import 'package:get/get.dart';
import 'package:lekra/data/repositories/form_repo.dart';

class FormController extends GetxController implements GetxService {
  final FormRepo formRepo;

  FormController({required this.formRepo});

  // ============================================================
  // KYC STEP CONFIGURATION
  // ============================================================

  static const int totalSteps = 9;

  /// Current step index.
  ///
  /// 0 = Basic
  /// 1 = Documents
  /// 2 = KYC Info
  /// 3 = Business
  /// 4 = Shop
  /// 5 = Selfie
  /// 6 = Bank
  /// 7 = Bank Document
  int selectedIndex = 0;

  /// Completion status for each step.
  final List<bool> completed = List<bool>.filled(totalSteps, false);

  // ============================================================
  // STEP NAMES
  // ============================================================

  static const List<String> stepNames = [
    'Basic',
    'Documents',
    'KYC Info',
    'Business',
    'Shop',
    'Selfie',
    'Bank',
    'Bank Doc',
    'Review',
  ];

  // ============================================================
  // NAVIGATION
  // ============================================================

  void selectIndex(int index) {
    if (index < 0 || index >= totalSteps) {
      return;
    }

    selectedIndex = index;
    update();
  }

  void nextStep() {
    if (selectedIndex >= totalSteps - 1) {
      return;
    }

    completed[selectedIndex] = true;
    selectedIndex++;

    update();
  }

  void previousStep() {
    if (selectedIndex <= 0) {
      return;
    }

    selectedIndex--;

    update();
  }

  // ============================================================
  // COMPLETION
  // ============================================================

  void setComplete(
    int index,
    bool value, {
    bool advanceIfTrue = false,
  }) {
    if (index < 0 || index >= totalSteps) {
      return;
    }

    completed[index] = value;

    if (advanceIfTrue && value && selectedIndex < totalSteps - 1) {
      selectedIndex++;
    }

    update();
  }

  void toggleComplete(int index) {
    if (index < 0 || index >= totalSteps) {
      return;
    }

    completed[index] = !completed[index];

    update();
  }

  void markAllComplete() {
    for (int i = 0; i < completed.length; i++) {
      completed[i] = true;
    }

    update();
  }

  bool isStepCompleted(int index) {
    if (index < 0 || index >= completed.length) {
      return false;
    }

    return completed[index];
  }

  bool get allStepsCompleted {
    return completed.every((step) => step);
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetForm() {
    selectedIndex = 0;

    for (int i = 0; i < completed.length; i++) {
      completed[i] = false;
    }

    update();
  }
}
