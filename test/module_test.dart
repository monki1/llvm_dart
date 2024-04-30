import 'package:llvm/llvm.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() => llvm.dispose());

  test('module names', () {
    final module = Module('my fancy module');
    expect(module.identifier, 'my fancy module');

    module.identifier = 'new name';
    expect(module.identifier, 'new name');
  });
}
