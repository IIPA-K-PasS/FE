import 'package:flutter/material.dart';
import '../data/term_api_service.dart';
import '../data/models/term_models.dart';
import 'term_detail_screen.dart';

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
    setState(() {
      _terms = terms;
      _loading = false;
      _checkAllAgreed();
    });
  }

  void _checkAllAgreed() {
    final req = _terms.where((t) => t.isRequired).toList();
    if (req.isEmpty) {
      _allAgreed = false;
      return;
    }
    _allAgreed = req.every((t) => t.agreed);
  }

  void _toggleAllAgreement(bool? value) {
    setState(() {
      _allAgreed = value ?? false;
      _terms = _terms.map((t) => t.copyWith(agreed: t.isRequired ? _allAgreed : t.agreed)).toList();
    });
  }

  Future<void> _toggleTermAgreement(int index, bool? value) async {
    final term = _terms[index];
    // 필수 약관 해제 불가 UX(테스트/운영 분리)
    if (term.isRequired && !(value ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 약관은 반드시 동의해야 합니다')),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final success = await TermApiService.agreeToTerms([
      TermAgreement(termId: term.termId, agreed: value ?? false)
    ]);
    if (!mounted) return;
    Navigator.pop(context);
    if (success) {
      setState(() {
        _terms[index] = term.copyWith(agreed: value ?? false);
        _checkAllAgreed();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value ?? false ? '동의 처리되었습니다' : '동의 철회')),);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('처리에 실패했습니다')),
      );
    }
  }

  bool get _canProceed {
    final req = _terms.where((t) => t.isRequired).toList();
    if (req.isEmpty) return false;
    return req.every((t) => t.agreed);
  }

  void _onDetail(Term term) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TermDetailScreen(term: term)),
    );
    _loadTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약관 동의'),
        centerTitle: true,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _buildHeader(),
          const SizedBox(height: 8),
          Expanded(child: _buildTermsSection()),
          _buildActionButton(),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('서비스 이용을 위해 약관 동의가 필요합니다',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    final requiredTerms = _terms.where((t) => t.isRequired).toList();
    final optionalTerms = _terms.where((t) => !t.isRequired).toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전체동의 토글
          ListTile(
            leading: Checkbox(
              value: _allAgreed && requiredTerms.isNotEmpty,
              onChanged: (v) => _toggleAllAgreement(v),
              activeColor: Colors.teal,
            ),
            title: const Text('전체 필수 약관 동의', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 12),
          Text('필수 약관', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...requiredTerms.asMap().entries.map((entry) => _buildTermCard(entry.key, entry.value)),
          if (optionalTerms.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text('선택 약관', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ...optionalTerms.asMap().entries.map((entry) => _buildTermCard(_terms.indexOf(entry.value), entry.value)),
          ],
        ],
      ),
    );
  }

  Widget _buildTermCard(int index, Term term) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: term.agreed,
              onChanged: (value) => _toggleTermAgreement(index, value),
              activeColor: Colors.teal,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _onDetail(term),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(term.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: term.isRequired ? Colors.red[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            term.isRequired ? '필수' : '선택',
                            style: TextStyle(fontSize: 11, color: term.isRequired ? Colors.red[700] : Colors.grey[700]),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      term.agreed ? '동의함' : '미동의',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: term.agreed ? Colors.teal : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _canProceed ? () {
            Navigator.pop(context, true);
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 1,
          ),
          child: const Text('동의하고 시작하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}

