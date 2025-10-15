import 'package:image_picker/image_picker.dart';
import '../domain/bill_entity.dart';
import '../domain/bill_repository_interface.dart';
import '../data/bill_remote_datasource.dart';

// domain 계층의 BillRepository 인터페이스를 구현합니다.
class BillRepositoryImpl implements BillRepository {
  final BillRemoteDataSource remoteDataSource;

  BillRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BillEntity> uploadBill({
    required String billType,
    required XFile billImage,
  }) async {
    try {
      // 데이터 소스에서 API 모델을 가져옵니다.
      final billResponseModel = await remoteDataSource.uploadBill(
        billType: billType,
        billImage: billImage,
      );
      // API 모델을 Domain Entity로 변환하여 반환합니다.
      return billResponseModel.toEntity();
    } catch (e) {
      rethrow; // 에러를 그대로 상위 계층으로 전달합니다.
    }
  }
}
