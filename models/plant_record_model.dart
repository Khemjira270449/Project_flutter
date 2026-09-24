class plantRecordModel {
  String plantId;
  String plantName;
  String month;
  String disease;
  String treatmentProducts; 
  String paidStatus; // 'Paid' หรือ 'Unpaid'
  String? referenceId;

  static const CollectionName = 'plant_records';

  plantRecordModel({
    required this.plantId,
    required this.plantName,
    required this.month,
    required this.disease,
    required this.treatmentProducts,
    required this.paidStatus,
    this.referenceId,
  });

  factory plantRecordModel.fromJson(Map<String, dynamic> json) {
    return plantRecordModel(
      plantId: json['plantId'] ?? '',
      plantName: json['plantName'] ?? '',
      month: json['month'] ?? '',
      disease: json['disease'] ?? '',
      treatmentProducts: json['treatmentProducts'] ?? '',
      paidStatus: json['paidStatus'] ?? 'Unpaid',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantId': plantId,
      'plantName': plantName,
      'month': month,
      'disease': disease,
      'treatmentProducts': treatmentProducts,
      'paidStatus': paidStatus,
    };
  }
}