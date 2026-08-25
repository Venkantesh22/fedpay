
class VenderKycDetails {
    final int? id;
    final int? userId;
    final String? status;
    final String? firstName;
    final String? lastName;
    final String? mobileNumber;
    final String? email;
    final String? shopName;
    final String? shopAddress;
    final String? pinCode;
    final String? city;
    final String? state;
    final String? aadhaarNumber;
    final String? panNumber;
    final dynamic gstin;
    final dynamic tradeLicenceNumber;
    final dynamic msmeRegistrationNumber;
    final String? businessCategory;
    final String? natureOfBusiness;
    final String? businessDescription;
    final DateTime? businessStartDate;
    final String? expectedMonthlyVolume;
    final String? ownershipType;
    final String? shopLatitude;
    final String? shopLongitude;
    final String? shopLivePhotoPath;
    final String? selfLivePhotoPath;
    final String? accountHolderName;
    final String? bankName;
    final String? accountNumber;
    final String? ifscCode;
    final String? branchName;
    final String? accountType;
    final String? bankRegisteredMobile;
    final bool? declarationAccepted;
    final dynamic declarationAcceptedAt;
    final dynamic submittedAt;
    final dynamic approvedAt;
    final dynamic approvedBy;
    final dynamic rejectedAt;
    final dynamic rejectedBy;
    final dynamic rejectionReason;
    final dynamic correctionRemarks;
    final dynamic lastRemark;
    final String? source;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<Document>? documents;

    VenderKycDetails({
        this.id,
        this.userId,
        this.status,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.email,
        this.shopName,
        this.shopAddress,
        this.pinCode,
        this.city,
        this.state,
        this.aadhaarNumber,
        this.panNumber,
        this.gstin,
        this.tradeLicenceNumber,
        this.msmeRegistrationNumber,
        this.businessCategory,
        this.natureOfBusiness,
        this.businessDescription,
        this.businessStartDate,
        this.expectedMonthlyVolume,
        this.ownershipType,
        this.shopLatitude,
        this.shopLongitude,
        this.shopLivePhotoPath,
        this.selfLivePhotoPath,
        this.accountHolderName,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.branchName,
        this.accountType,
        this.bankRegisteredMobile,
        this.declarationAccepted,
        this.declarationAcceptedAt,
        this.submittedAt,
        this.approvedAt,
        this.approvedBy,
        this.rejectedAt,
        this.rejectedBy,
        this.rejectionReason,
        this.correctionRemarks,
        this.lastRemark,
        this.source,
        this.createdAt,
        this.updatedAt,
        this.documents,
    });

    factory VenderKycDetails.fromJson(Map<String, dynamic> json) => VenderKycDetails(
        id: json["id"],
        userId: json["user_id"],
        status: json["status"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        shopName: json["shop_name"],
        shopAddress: json["shop_address"],
        pinCode: json["pin_code"],
        city: json["city"],
        state: json["state"],
        aadhaarNumber: json["aadhaar_number"],
        panNumber: json["pan_number"],
        gstin: json["gstin"],
        tradeLicenceNumber: json["trade_licence_number"],
        msmeRegistrationNumber: json["msme_registration_number"],
        businessCategory: json["business_category"],
        natureOfBusiness: json["nature_of_business"],
        businessDescription: json["business_description"],
        businessStartDate: json["business_start_date"] == null ? null : DateTime.parse(json["business_start_date"]),
        expectedMonthlyVolume: json["expected_monthly_volume"],
        ownershipType: json["ownership_type"],
        shopLatitude: json["shop_latitude"],
        shopLongitude: json["shop_longitude"],
        shopLivePhotoPath: json["shop_live_photo_path"],
        selfLivePhotoPath: json["self_live_photo_path"],
        accountHolderName: json["account_holder_name"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        branchName: json["branch_name"],
        accountType: json["account_type"],
        bankRegisteredMobile: json["bank_registered_mobile"],
        declarationAccepted: json["declaration_accepted"],
        declarationAcceptedAt: json["declaration_accepted_at"],
        submittedAt: json["submitted_at"],
        approvedAt: json["approved_at"],
        approvedBy: json["approved_by"],
        rejectedAt: json["rejected_at"],
        rejectedBy: json["rejected_by"],
        rejectionReason: json["rejection_reason"],
        correctionRemarks: json["correction_remarks"],
        lastRemark: json["last_remark"],
        source: json["source"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        documents: json["documents"] == null ? [] : List<Document>.from(json["documents"]!.map((x) => Document.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "status": status,
        "first_name": firstName,
        "last_name": lastName,
        "mobile_number": mobileNumber,
        "email": email,
        "shop_name": shopName,
        "shop_address": shopAddress,
        "pin_code": pinCode,
        "city": city,
        "state": state,
        "aadhaar_number": aadhaarNumber,
        "pan_number": panNumber,
        "gstin": gstin,
        "trade_licence_number": tradeLicenceNumber,
        "msme_registration_number": msmeRegistrationNumber,
        "business_category": businessCategory,
        "nature_of_business": natureOfBusiness,
        "business_description": businessDescription,
        "business_start_date": businessStartDate == null ? null : "${businessStartDate!.year.toString().padLeft(4, '0')}-${businessStartDate!.month.toString().padLeft(2, '0')}-${businessStartDate!.day.toString().padLeft(2, '0')}",
        "expected_monthly_volume": expectedMonthlyVolume,
        "ownership_type": ownershipType,
        "shop_latitude": shopLatitude,
        "shop_longitude": shopLongitude,
        "shop_live_photo_path": shopLivePhotoPath,
        "self_live_photo_path": selfLivePhotoPath,
        "account_holder_name": accountHolderName,
        "bank_name": bankName,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "branch_name": branchName,
        "account_type": accountType,
        "bank_registered_mobile": bankRegisteredMobile,
        "declaration_accepted": declarationAccepted,
        "declaration_accepted_at": declarationAcceptedAt,
        "submitted_at": submittedAt,
        "approved_at": approvedAt,
        "approved_by": approvedBy,
        "rejected_at": rejectedAt,
        "rejected_by": rejectedBy,
        "rejection_reason": rejectionReason,
        "correction_remarks": correctionRemarks,
        "last_remark": lastRemark,
        "source": source,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
    };
}

class Document {
    final int? id;
    final int? merchantKycId;
    final String? documentType;
    final String? filePath;
    final String? fileName;
    final int? fileSize;
    final String? mimeType;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Document({
        this.id,
        this.merchantKycId,
        this.documentType,
        this.filePath,
        this.fileName,
        this.fileSize,
        this.mimeType,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        merchantKycId: json["merchant_kyc_id"],
        documentType: json["document_type"],
        filePath: json["file_path"],
        fileName: json["file_name"],
        fileSize: json["file_size"],
        mimeType: json["mime_type"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "merchant_kyc_id": merchantKycId,
        "document_type": documentType,
        "file_path": filePath,
        "file_name": fileName,
        "file_size": fileSize,
        "mime_type": mimeType,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };



  
}


