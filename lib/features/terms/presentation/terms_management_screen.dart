import 'package:flutter/material.dart';
import '../data/term_api_service.dart';
import '../data/models/term_models.dart';
import 'term_detail_screen.dart';

class TermsManagementScreen extends StatefulWidget {
  const TermsManagementScreen({super.key});

  @override
  State<TermsManagementScreen> createState() => _TermsManagementScreenState();
}

class _TermsManagementScreenState extends State<TermsManagementScreen> {
  List<Term> _terms = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final terms = await TermApiService.fetchTerms();
      if (mounted) {
        setState(() {
          _terms = terms;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '약관 정보를 불러오는데 실패했어요';
          _loading = false;
        });
      }
    }
  }

  Future<void> _updateTermAgreement(int index, bool agreed) async {
    final term = _terms[index];

    // 필수 약관은 변경 불가
    if (term.isRequired && !agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 약관은 동의를 철회할 수 없습니다')),
      );
      return;
    }

    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.teal),
      ),
    );

    final success = await TermApiService.agreeToTerms([
      TermAgreement(termId: term.termId, agreed: agreed),
    ]);

    if (!mounted) return;

    Navigator.pop(context); // 로딩 다이얼로그 닫기

    if (success) {
      setState(() {
        _terms[index] = term.copyWith(agreed: agreed);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(agreed ? '동의 처리되었습니다' : '동의가 철회되었습니다'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('처리에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('약관 및 정책'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadTerms,
                        icon: const Icon(Icons.refresh),
                        label: const Text('다시 시도'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTerms,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // 필수 약관 섹션
                      Text(
                        '필수 약관',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),
                      const SizedBox(height: 12),
                      ..._terms
                          .where((t) => t.isRequired)
                          .map((t) => _buildTermCard(
                              t, _terms.indexOf(t), isRequired: true)),

                      const SizedBox(height: 24),

                      // 선택 약관 섹션
                      if (_terms.any((t) => !t.isRequired)) ...[
                        Text(
                          '선택 약관',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        ..._terms
                            .where((t) => !t.isRequired)
                            .map((t) => _buildTermCard(
                                t, _terms.indexOf(t), isRequired: false)),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildTermCard(Term term, int index, {required bool isRequired}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TermDetailScreen(term: term),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 아이콘
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: term.agreed ? Colors.green[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    term.agreed ? Icons.check_circle : Icons.description,
                    color: term.agreed ? Colors.green[600] : Colors.grey[600],
                    size: 20,
                  ),
                ),

                const SizedBox(width: 16),

                // 제목 및 상태
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        term.title,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        term.agreed ? '동의함' : '미동의',
                        style: TextStyle(
                          fontSize: 13,
                          color: term.agreed
                              ? Colors.green[600]
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // 토글 또는 화살표
                if (isRequired)
                  // 필수 약관: 보기만
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey[400])
                else
                  // 선택 약관: 토글 가능
                  Switch(
                    value: term.agreed,
                    onChanged: (value) => _updateTermAgreement(index, value),
                    activeColor: Colors.teal,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

