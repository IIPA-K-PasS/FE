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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('약관 동의'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : _terms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        '약관 정보가 없습니다',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainNavigationPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('메인으로 이동 (임시)'),
                      ),
                    ],
                  ),
                )
              : Column(
              children: [
                // 상단 안내 메시지
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.teal[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '환영합니다! 👋',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '서비스 이용을 위해 약관 동의가 필요해요',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.teal[700],
                            ),
                      ),
                    ],
                  ),
                ),

                // 전체 동의 체크박스
                Container(
                  color: Colors.grey[50],
                  child: CheckboxListTile(
                    title: const Text(
                      '전체 동의',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    value: _allAgreed,
                    onChanged: _toggleAllAgreement,
                    activeColor: Colors.teal,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),

                const Divider(height: 1),

                // 개별 약관 목록
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _terms.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
                    itemBuilder: (context, index) {
                      final term = _terms[index];
                      return CheckboxListTile(
                        title: Row(
                          children: [
                            Text(term.title),
                            const SizedBox(width: 8),
                            if (term.isRequired)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.red[300]!),
                                ),
                                child: Text(
                                  '필수',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '선택',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TermDetailScreen(term: term),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('자세히 보기'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                        value: term.agreed,
                        onChanged: (value) => _toggleTermAgreement(index, value),
                        activeColor: Colors.teal,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
                ),

                // 하단 동의 버튼
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _canProceed ? _submitTerms : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _canProceed ? '동의하고 시작하기' : '필수 약관에 동의해주세요',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

