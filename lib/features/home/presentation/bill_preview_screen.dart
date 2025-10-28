import 'dart:io';
import 'dart:typed_data'; // Uint8List 사용을 위해 import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart'; // 패키지 import
import '../data/bill_remote_datasource.dart';
import '../data/bill_repository_impl.dart';
import '../domain/bill_repository_interface.dart';
import '../domain/bill_entity.dart'; // BillEntity import

class BillPreviewScreen extends StatefulWidget {
  final XFile imageFile;
  final String billType;

  const BillPreviewScreen({
    super.key,
    required this.imageFile,
    required this.billType,
  });

  @override
  State<BillPreviewScreen> createState() => _BillPreviewScreenState();
}

class _BillPreviewScreenState extends State<BillPreviewScreen> {
  late final BillRepository _billRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _billRepository = BillRepositoryImpl(remoteDataSource: BillRemoteDataSource());
  }

  // ⭐ 이미지 압축 함수 추가
  Future<XFile?> _compressImage(XFile file) async {
    final filePath = file.path;
    // 원본 파일 경로에서 마지막 부분을 가져와서 압축 후 파일 이름으로 사용
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    // 이미지를 압축 (quality 조절 가능: 0 ~ 100)
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 70, // 품질을 70으로 설정 (원본 대비 크기 감소)
    );

    print('원본 크기: ${await file.length()} bytes');
    if (result != null) {
      print('압축 후 크기: ${await result.length()} bytes');
    }

    return result;
  }


  Future<void> _uploadAndProcess() async {
    setState(() => _isLoading = true);

    try {
      // ⭐ 1. 이미지 압축 실행
      XFile? compressedImage = await _compressImage(widget.imageFile);

      // 압축에 실패하거나 결과가 없으면 원본 사용 (혹은 오류 처리)
      XFile imageToSend = compressedImage ?? widget.imageFile;


      // ⭐ 2. 압축된 이미지 또는 원본 이미지로 API 호출
      final result = await _billRepository.uploadBill(
        billType: widget.billType,
        billImage: imageToSend, // 압축된 이미지 전달
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('${result.usagePeriod} 고지서 분석 완료! 금액: ${result.amount}원')),
        );
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // build 메서드는 기존과 동일
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 확인'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.file(File(widget.imageFile.path), fit: BoxFit.contain),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('다시 찍기'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _uploadAndProcess,
                          child: const Text('확인'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

