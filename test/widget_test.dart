import 'package:flutter_test/flutter_test.dart';
import 'package:tkc_vender_auth/core/network/models/app_exception.dart';

void main() {
  test('AppException exposes message', () {
    const error = AppException('Invalid credentials', code: '401');
    expect(error.message, 'Invalid credentials');
    expect(error.code, '401');
  });
}
