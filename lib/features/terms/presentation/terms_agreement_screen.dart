import 'package:flutter/material.dart';
import '../data/term_api_service.dart';
import '../data/models/term_models.dart';
import 'term_detail_screen.dart';
import '../../../main.dart';

class TermsAgreementScreen extends StatefulWidget {
  const TermsAgreementScreen({super.key});

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  List<Term> _terms = [];
  bool _loading = true;
  bool _allAgreed = false;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    setState(() => _loading = true);
    final terms = await TermApiService.fetchTerms();
    if (mounted) {
      setState(() {
        _terms = terms;
        _loading = false;
        _checkAllAgreed();
      });
    }
  }

  void _checkAllAgreed() {
    if (_terms.isEmpty) {
      _allAgreed = false;
      return;
    }
    _allAgreed = _terms.every((t) => t.agreed);
  }

  void _toggleAllAgreement(bool? value) {
    setState(() {
      _allAgreed = value ?? false;
      _terms = _terms.map((t) => t.copyWith(agreed: _allAgreed)).toList();
    });
  }

  void _toggleTermAgreement(int index, bool? value) {
    setState(() {
      _terms[index] = _terms[index].copyWith(agreed: value ?? false);
      _checkAllAgreed();
    });
  }

  bool get _canProceed {
    // 모든 필수 약관에 동의했는지 확인
    final requiredTerms = _terms.where((t) => t.isRequired).toList();
    if (requiredTerms.isEmpty) return true;
    return requiredTerms.every((t) => t.agreed);
  }

  Future<void> _submitTerms() async {
    if (!_canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 약관에 동의해주세요')),
      );
      return;
    }

    // 약관이 없으면 바로 진행
    if (_terms.isEmpty) {
      debugPrint('[TermsAgreement] No terms to agree, proceeding to main...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
      );
      return;
    }

    // 로딩 다이얼로그
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.teal),
      ),
    );

    final agreements =
        _terms.map((t) => TermAgreement(termId: t.termId, agreed: t.agreed)).toList();

    final success = await TermApiService.agreeToTerms(agreements);

    if (!mounted) return;

    Navigator.pop(context); // 로딩 다이얼로그 닫기

    if (success) {
      // 약관 동의 완료 → 메인 화면으로
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약관 동의 처리에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : _terms.isEmpty
              ? _buildEmptyState()
              : _buildTermsAgreement(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '약관 정보가 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '백엔드에 약관 데이터를 추가해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('메인으로 이동 (임시)'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAgreement() {
    return Column(
      children: [
        // 상단 헤더
        _buildHeader(),
        
        // 약관 목록
        Expanded(
          child: _buildTermsList(),
        ),
        
        // 하단 버튼
        _buildBottomButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal[50]!,
            Colors.teal[100]!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.teal[600],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.handshake_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '환영합니다!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '서비스 이용을 위해 약관 동의가 필요해요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // 전체 동의 카드
          _buildAllAgreeCard(),
          
          const SizedBox(height: 16),
          
          // 개별 약관 목록
          Expanded(
            child: ListView.separated(
              itemCount: _terms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final term = _terms[index];
                return _buildTermCard(term, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllAgreeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _allAgreed ? Colors.teal : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _allAgreed ? Colors.teal : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: _allAgreed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '전체 동의',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '모든 약관에 동의합니다',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _toggleAllAgreement(!_allAgreed),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _allAgreed ? Icons.toggle_on : Icons.toggle_off,
                color: _allAgreed ? Colors.teal : Colors.grey[400],
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermCard(Term term, int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 체크박스
              GestureDetector(
                onTap: () => _toggleTermAgreement(index, !term.agreed),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: term.agreed ? Colors.teal : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: term.agreed ? Colors.teal : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: term.agreed
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              
              // 제목과 배지
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        term.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: term.isRequired ? Colors.red[50] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: term.isRequired ? Colors.red[200]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        term.isRequired ? '필수' : '선택',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: term.isRequired ? Colors.red[700] : Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 자세히 보기 버튼
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TermDetailScreen(term: term),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: Colors.teal[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '자세히 보기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal[600],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.teal[600],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _canProceed ? _submitTerms : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _canProceed ? Colors.teal : Colors.grey[300],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: _canProceed ? 2 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_canProceed) ...[
                  const Icon(Icons.check_circle_outline, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  _canProceed ? '동의하고 시작하기' : '필수 약관에 동의해주세요',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

