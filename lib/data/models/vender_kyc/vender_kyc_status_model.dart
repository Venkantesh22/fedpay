class VenderKycStatusModel {
  final String? status;
  final String? kycStatus;
  final CorrectionRemarks? correctionRemarks;
  final dynamic lastRemark;

  VenderKycStatusModel({
    this.status,
    this.kycStatus,
    this.correctionRemarks,
    this.lastRemark,
  });

  factory VenderKycStatusModel.fromJson(Map<String, dynamic> json) =>
      VenderKycStatusModel(
        status: json["status"],
        kycStatus: json["kyc_status"],
        correctionRemarks: json["correction_remarks"] == null
            ? null
            : CorrectionRemarks.fromJson(json["correction_remarks"]),
        lastRemark: json["last_remark"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "kyc_status": kycStatus,
        "correction_remarks": correctionRemarks?.toJson(),
        "last_remark": lastRemark,
      };

  bool get isRegistrationStarted => kycStatus == "registration_started";
  bool get isKycSubmitted => kycStatus == "kyc_submitted";
  bool get isCorrectionRequired => kycStatus == "correction_required";
  bool get isApproved => kycStatus == "approved";
  bool get isRejected => kycStatus == "rejected";
}

class CorrectionRemarks {
  final List<String>? verifiedSections;
  final dynamic bankStatement;
  final dynamic cancelledCheque;
  final dynamic aadhaarFront;

  CorrectionRemarks({
    this.verifiedSections,
    this.bankStatement,
    this.cancelledCheque,
    this.aadhaarFront,
  });

  factory CorrectionRemarks.fromJson(Map<String, dynamic> json) =>
      CorrectionRemarks(
        verifiedSections: json["verified_sections"] == null
            ? []
            : List<String>.from(json["verified_sections"]!.map((x) => x)),
        bankStatement: json["bank_statement"],
        cancelledCheque: json["cancelled_cheque"],
        aadhaarFront: json["aadhaar_front"],
      );

  Map<String, dynamic> toJson() => {
        "verified_sections": verifiedSections == null
            ? []
            : List<dynamic>.from(verifiedSections!.map((x) => x)),
        "bank_statement": bankStatement,
        "cancelled_cheque": cancelledCheque,
        "aadhaar_front": aadhaarFront,
      };
}
