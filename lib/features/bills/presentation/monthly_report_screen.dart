import 'package:flutter/material.dart';
import '../../bills/data/bills_api_service.dart';
import '../../bills/data/models/bill_models.dart';

class MonthlyReportScreen extends StatefulWidget {
  final int year;
  final int month;

  const MonthlyReportScreen({super.key, required this.year, required this.month});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  BillCategory _category = BillCategory.electricity;
  MonthlyReportDetail? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final d = await BillsApiService.fetchReportDetail(
        year: widget.year,
        month: widget.month,
        category: _category,
      );
      if (mounted) setState(() { _detail = d; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = '리포트를 불러올 수 없어요'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('월별 상세 리포트'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF6F7F9),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Colors.teal))
            : _error != null
                ? Center(child: Text(_error!))
                : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final detail = _detail!;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _CategoryTabs(
          category: _category,
          onChanged: (c) { setState(() { _category = c; }); _load(); },
        ),
        const SizedBox(height: 16),
        _CurrentFeeSection(year: detail.year, month: detail.month, amount: detail.currentMonthFee, category: _category),
        const SizedBox(height: 16),
        _CompareBar(previous: detail.previousMonthFee, current: detail.currentMonthFee, category: _category),
        const SizedBox(height: 16),
        _CategorySpecific(additionalInfo: detail.additionalInfo, category: _category),
        const SizedBox(height: 16),
        _LineTrend(trend: detail.monthlyTrend, category: _category),
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final BillCategory category;
  final ValueChanged<BillCategory> onChanged;
  const _CategoryTabs({required this.category, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, BillCategory c, Color color) {
      final bool selected = c == category;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(c),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? color.withOpacity(0.15) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? color : Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  c == BillCategory.electricity ? Icons.bolt : c == BillCategory.water ? Icons.water_drop : Icons.local_fire_department,
                  color: selected ? color : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(color: selected ? color : Colors.grey[700], fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip('전기', BillCategory.electricity, Colors.orange),
        const SizedBox(width: 10),
        chip('수도', BillCategory.water, Colors.blue),
        const SizedBox(width: 10),
        chip('가스', BillCategory.gas, Colors.red),
      ],
    );
  }
}

class _CurrentFeeSection extends StatelessWidget {
  final int year; final int month; final int amount; final BillCategory category;
  const _CurrentFeeSection({required this.year, required this.month, required this.amount, required this.category});

  @override
  Widget build(BuildContext context) {
    final title = '${month}월 ${_label(category)} 요금';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 6),
        Text(_format(amount), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
      ],
    );
  }

  String _label(BillCategory c){
    switch(c){
      case BillCategory.electricity: return '전기';
      case BillCategory.water: return '수도';
      case BillCategory.gas: return '가스';
    }
  }

  String _format(int v){
    return '${_comma(v)}원';
  }

  String _comma(int v){
    final s = v.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m)=>',');
  }
}

class _CompareBar extends StatelessWidget {
  final int previous; final int current; final BillCategory category;
  const _CompareBar({required this.previous, required this.current, required this.category});
  @override
  Widget build(BuildContext context) {
    final Color color = category==BillCategory.electricity? Colors.orange : category==BillCategory.water? Colors.blue : Colors.red;
    final max = [previous, current].reduce((a,b)=>a>b?a:b).toDouble();
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('전월 대비 사용량', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: CustomPaint(
            painter: _BarChartPainter(
              previous: previous.toDouble(),
              current: current.toDouble(),
              max: max,
              previousColor: Colors.grey[400]!,
              currentColor: color,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ]),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final double previous;
  final double current;
  final double max;
  final Color previousColor;
  final Color currentColor;

  _BarChartPainter({
    required this.previous,
    required this.current,
    required this.max,
    required this.previousColor,
    required this.currentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    final Paint barPaint = Paint()..style = PaintingStyle.fill;

    // Y축 격자선과 라벨 그리기
    final double stepY = max / 4; // 4개 구간으로 나누기
    for (int i = 0; i <= 4; i++) {
      final double y = size.height - (i * size.height / 4);
      final double value = i * stepY;
      
      // 격자선 그리기
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      
      // Y축 라벨 그리기
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(value / 1000).toStringAsFixed(0)}k',
          style: TextStyle(color: Colors.grey[600], fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-30, y - textPainter.height / 2));
    }

    // 막대 그래프 그리기 (얇게 조정)
    const double leftMargin = 10;
    const double rightMargin = 10;
    final double chartWidth = size.width - leftMargin - rightMargin;
    final double barWidth = 100; // 얇은 막대

    // 두 막대의 중심 위치 (좌우 1/3, 2/3 지점)
    final double center1 = leftMargin + chartWidth * 0.28;
    final double center2 = leftMargin + chartWidth * 0.80;

    // 지난달 막대
    final double previousHeight = (previous / max * (size.height - 40)).clamp(2, size.height - 40);
    barPaint.color = previousColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center1 - barWidth / 2, size.height - previousHeight - 20, barWidth, previousHeight),
        const Radius.circular(8),
      ),
      barPaint,
    );

    // 이번달 막대
    final double currentHeight = (current / max * (size.height - 40)).clamp(2, size.height - 40);
    barPaint.color = currentColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center2 - barWidth / 2, size.height - currentHeight - 20, barWidth, currentHeight),
        const Radius.circular(8),
      ),
      barPaint,
    );

    // 라벨 그리기
    final labelPainter1 = TextPainter(
      text: const TextSpan(
        text: '지난달',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter1.layout();
    labelPainter1.paint(canvas, Offset(center1 - labelPainter1.width / 2, size.height - 15));

    final labelPainter2 = TextPainter(
      text: const TextSpan(
        text: '이번달',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter2.layout();
    labelPainter2.paint(canvas, Offset(center2 - labelPainter2.width / 2, size.height - 15));
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.previous != previous ||
        oldDelegate.current != current ||
        oldDelegate.max != max ||
        oldDelegate.previousColor != previousColor ||
        oldDelegate.currentColor != currentColor;
  }
}

class _CategorySpecific extends StatelessWidget {
  final Map<String, dynamic> additionalInfo; final BillCategory category;
  const _CategorySpecific({required this.additionalInfo, required this.category});
  @override
  Widget build(BuildContext context) {
    switch(category){
      case BillCategory.electricity:
        final stageText = additionalInfo['stageText'] ?? '현재 1단계 사용 중이에요. 다음 단계까지 여유 있어요!';
        final progress = (additionalInfo['stageProgress'] as num?)?.toDouble() ?? 0.35;
        return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('누진 단계 현황', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(stageText, style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress, minHeight: 10, backgroundColor: Colors.grey[200], color: Colors.green),
        ]));
      case BillCategory.water:
        final tip1 = additionalInfo['tip1'] ?? '지난달보다 절약하셨어요! 샤워 시간을 5분 줄이면 더 좋아요.';
        final tip2 = additionalInfo['tip2'] ?? '설거지통을 사용하면 월 최대 절약이 가능해요.';
        return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('AI 절약 꿀팁', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _bullet(tip1),
          const SizedBox(height: 8),
          _bullet(tip2),
        ]));
      case BillCategory.gas:
        final next = additionalInfo['nextInspection'] ?? '3개월 후';
        final last = additionalInfo['lastInspection'] ?? '2025년 5월 15일';
        return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('안전 점검 관리', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('다음 점검 예정일은 $next 입니다.'),
          Text('최근 점검일: $last'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2023), lastDate: DateTime(2030));
                if (picked != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('점검 완료: ${picked.year}-${picked.month}-${picked.day}')));
                }
              },
              child: const Text('점검 완료 기록하기'),
            ),
          ),
        ]));
    }
  }

  Widget _card({required Widget child}){
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _bullet(String text){
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.tips_and_updates, color: Colors.blue, size: 20),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
    ]);
  }
}

class _LineTrend extends StatelessWidget {
  final List<MonthlyTrendPoint> trend; final BillCategory category;
  const _LineTrend({required this.trend, required this.category});
  @override
  Widget build(BuildContext context) {
    final Color color = category==BillCategory.electricity? Colors.orange : category==BillCategory.water? Colors.blue : Colors.red;
    final int max = trend.isEmpty ? 0 : trend.map((e)=>e.fee).reduce((a,b)=>a>b?a:b);
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('최근 6개월 요금 변화', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: CustomPaint(
            painter: _LineChartPainter(points: trend, color: color, maxY: (max*1.2).toDouble()),
            child: const SizedBox.expand(),
          ),
        ),
      ]),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<MonthlyTrendPoint> points; final Color color; final double maxY;
  _LineChartPainter({required this.points, required this.color, required this.maxY});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()..color = Colors.grey[300]!..strokeWidth = 1;
    final Paint linePaint = Paint()..color = color..strokeWidth = 3..style = PaintingStyle.stroke;
    final Paint dotPaint = Paint()..color = color;

    // Y축 격자선과 라벨 그리기
    for (int i = 0; i <= 4; i++) {
      final double y = size.height - (i * size.height / 4);
      final double value = i * maxY / 4;
      
      // 격자선 그리기
      canvas.drawLine(Offset(40, y), Offset(size.width, y), gridPaint);
      
      // Y축 라벨 그리기
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(value / 1000).toStringAsFixed(0)}k',
          style: TextStyle(color: Colors.grey[600], fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    // X축 격자선과 라벨 그리기
    if (points.isNotEmpty) {
      final double stepX = (size.width - 40) / (points.length - 1);
      for (int i = 0; i < points.length; i++) {
        final double x = 40 + stepX * i;
        
        // X축 격자선 그리기
        canvas.drawLine(Offset(x, 0), Offset(x, size.height - 20), gridPaint);
        
        // X축 라벨 그리기
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${points[i].month}월',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - 15));
      }
    }

    // 라인 차트 그리기
    if (points.isEmpty) return;
    
    final double stepX = (size.width - 40) / (points.length - 1);
    final Path path = Path();
    
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final double x = 40 + stepX * i;
      final double y = size.height - 20 - (p.fee / maxY * (size.height - 40)).clamp(0, size.height - 40);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      
      // 데이터 포인트 그리기
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
    
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color || oldDelegate.maxY != maxY;
  }
}


