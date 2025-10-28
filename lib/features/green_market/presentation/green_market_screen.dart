import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GreenMarketScreen extends StatefulWidget {
  const GreenMarketScreen({super.key});

  @override
  State<GreenMarketScreen> createState() => _GreenMarketScreenState();
}

class _GreenMarketScreenState extends State<GreenMarketScreen> {
  final TextEditingController _pointController = TextEditingController();
  int _availablePoints = 1250; // 사용 가능한 포인트
  bool _isLoading = false;

  @override
  void dispose() {
    _pointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('그린 마켓'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용 가능한 포인트 카드
            _buildPointsCard(),
            
            const SizedBox(height: 30),
            
            // 포인트 교환 섹션
            _buildExchangeSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // 연한 녹색 배경
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '사용 가능한 내 포인트',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatPoints(_availablePoints)} P',
            style: TextStyle(
              fontSize: 28,
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '포인트 교환하기',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // 지역화폐로 교환 섹션
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '지역화폐로 교환',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                '1P = 1원으로 교환돼요 (최소 1,000P)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                '교환할 포인트',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 포인트 입력 필드
              TextField(
                controller: _pointController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: '예: 1000',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.green[400]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 교환 신청 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleExchange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          '교환 신청하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  String _formatPoints(int points) {
    return points.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  void _handleExchange() async {
    final inputText = _pointController.text.trim();
    
    if (inputText.isEmpty) {
      _showSnackBar('교환할 포인트를 입력해주세요.', Colors.orange);
      return;
    }

    final exchangePoints = int.tryParse(inputText);
    if (exchangePoints == null) {
      _showSnackBar('올바른 포인트를 입력해주세요.', Colors.red);
      return;
    }

    if (exchangePoints < 1000) {
      _showSnackBar('최소 1,000P 이상 교환 가능합니다.', Colors.orange);
      return;
    }

    if (exchangePoints > _availablePoints) {
      _showSnackBar('보유 포인트가 부족합니다.', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 교환 처리 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _availablePoints -= exchangePoints;
      _pointController.clear();
    });

    _showSnackBar(
      '${_formatPoints(exchangePoints)}P가 지역화폐로 교환 신청되었습니다!',
      Colors.green,
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
