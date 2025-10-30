import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../data/models/term_models.dart';

class TermDetailScreen extends StatelessWidget {
  final Term term;
  const TermDetailScreen({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(term.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Text(term.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(width: 8),
              _termBadge(term),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(term.agreed ? Icons.check_circle : Icons.cancel,
                size: 18,
                color: term.agreed ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(term.agreed ? '동의함' : '미동의',
                style: TextStyle(
                  color: term.agreed ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500)
              ),
            ],
          ),
          const Divider(height: 30),
          Text(
            term.content,
            style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 28),
          if (term.contentUrl != null && term.contentUrl!.isNotEmpty)
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  final url = term.contentUrl!;
                  if (await canLaunchUrlString(url)) {
                    launchUrlString(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('링크를 열 수 없습니다: $url')),
                    );
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('공식 전문 깃허브에서 보기', style: TextStyle(fontSize: 13)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _termBadge(Term term) {
    return Container(
      decoration: BoxDecoration(
        color: term.isRequired ? Colors.red[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        term.isRequired ? '필수' : '선택',
        style: TextStyle(fontSize: 12, color: term.isRequired ? Colors.red[700] : Colors.grey[700], fontWeight: FontWeight.w600),
      ),
    );
  }
}

