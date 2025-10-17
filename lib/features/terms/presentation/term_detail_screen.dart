import 'package:flutter/material.dart';
import '../data/models/term_models.dart';

class TermDetailScreen extends StatelessWidget {
  final Term term;

  const TermDetailScreen({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(term.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 약관 제목 + 배지
            Row(
              children: [
                Expanded(
                  child: Text(
                    term.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                if (term.isRequired)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Text(
                      '필수',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '선택',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // 동의 상태
            Row(
              children: [
                Icon(
                  term.agreed ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: term.agreed ? Colors.green[600] : Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  term.agreed ? '동의함' : '미동의',
                  style: TextStyle(
                    fontSize: 14,
                    color: term.agreed ? Colors.green[600] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // 약관 내용
            Text(
              term.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    height: 1.6,
                  ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

