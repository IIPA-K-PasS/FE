class BillEntity {
  final String billType;
  final int amount;
  final String usagePeriod;
  final String rawText;

  BillEntity({
    required this.billType,
    required this.amount,
    required this.usagePeriod,
    required this.rawText
  });
}
