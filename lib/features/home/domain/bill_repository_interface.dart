import 'package:image_picker/image_picker.dart';
import '../domain/bill_entity.dart';

// 데이터 계층과의 통신을 위한 계약(interface)입니다.
// domain 계층은 이 인터페이스에만 의존합니다.
abstract class BillRepository {
  Future<BillEntity> uploadBill({
    required String billType,
    required XFile billImage,
  });
}
