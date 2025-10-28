enum BillCategory { electricity, water, gas }

String billCategoryToParam(BillCategory c) {
  switch (c) {
    case BillCategory.electricity:
      return 'ELECTRICITY';
    case BillCategory.water:
      return 'WATER';
    case BillCategory.gas:
      return 'GAS';
  }
}

class BillsSummary {
  final int year;
  final int month;
  final int totalAmount;
  final int difference;

  BillsSummary({
    required this.year,
    required this.month,
    required this.totalAmount,
    required this.difference,
  });

  factory BillsSummary.fromJson(Map<String, dynamic> json) {
    return BillsSummary(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toInt(),
      difference: (json['difference'] as num).toInt(),
    );
  }
}

class MonthlyTrendPoint {
  final int month; // 1..12
  final int fee;

  MonthlyTrendPoint({required this.month, required this.fee});

  factory MonthlyTrendPoint.fromJson(Map<String, dynamic> json) {
    return MonthlyTrendPoint(
      month: (json['month'] as num).toInt(),
      fee: (json['fee'] as num).toInt(),
    );
  }
}

class MonthlyReportDetail {
  final BillCategory category;
  final int year;
  final int month;
  final int currentMonthFee;
  final int previousMonthFee;
  final Map<String, dynamic> additionalInfo;
  final List<MonthlyTrendPoint> monthlyTrend;

  MonthlyReportDetail({
    required this.category,
    required this.year,
    required this.month,
    required this.currentMonthFee,
    required this.previousMonthFee,
    required this.additionalInfo,
    required this.monthlyTrend,
  });

  factory MonthlyReportDetail.fromJson(Map<String, dynamic> json) {
    final String rawCategory = json['category'] as String;
    final BillCategory cat = rawCategory == 'ELECTRICITY'
        ? BillCategory.electricity
        : rawCategory == 'WATER'
            ? BillCategory.water
            : BillCategory.gas;

    final List<dynamic> trendList = json['monthlyTrend'] as List<dynamic>? ?? [];
    return MonthlyReportDetail(
      category: cat,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      currentMonthFee: (json['currentMonthFee'] as num).toInt(),
      previousMonthFee: (json['previousMonthFee'] as num).toInt(),
      additionalInfo: (json['additionalInfo'] as Map<String, dynamic>? ?? {}),
      monthlyTrend: trendList
          .map((e) => MonthlyTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}


