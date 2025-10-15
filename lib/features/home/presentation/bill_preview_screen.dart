import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/bill_remote_datasource.dart';
import '../data/bill_repository_impl.dart';
import '../domain/bill_repository_interface.dart';

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

  Future<void> _uploadAndProcess() async {
    setState(() => _isLoading = true);

    try {
      final result = await _billRepository.uploadBill(
        billType: widget.billType,
        billImage: widget.imageFile,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('${result.usagePeriod} 고지서 분석 완료! 금액: ${result.amount}원')),
        );
        Navigator.of(context).pop(true); // 성공 신호와 함께 pop
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
