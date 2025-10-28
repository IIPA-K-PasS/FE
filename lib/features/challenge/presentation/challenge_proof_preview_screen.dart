import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChallengeProofPreviewScreen extends StatelessWidget { // StatefulWidget -> StatelessWidget 변경
  final XFile imageFile;

  const ChallengeProofPreviewScreen({
    super.key,
    required this.imageFile,
  });

  // // 이미지 압축 함수 제거
  // Future<XFile?> _compressImage(XFile file) async { ... }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인증샷 확인'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false), // 취소 시 false 반환
        ),
      ),
      // ⭐ 변경점: Stack 및 로딩 UI 제거
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(File(imageFile.path), fit: BoxFit.contain),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      // ⭐ 변경점: _isCompressing 조건 제거
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('다시 찍기'), // '다시 선택' -> '다시 찍기'
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      // ⭐ 변경점: 압축 로직 제거하고 바로 pop(true) 호출
                      onPressed: () {
                        Navigator.of(context).pop(true); // 성공 시 true 반환
                      },
                      child: const Text('확인'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // ⭐ 변경점: 로딩 인디케이터 제거
      // if (_isCompressing) ...
    );
  }
}

