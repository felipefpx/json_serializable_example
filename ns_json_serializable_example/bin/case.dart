import 'models/foo.dart';
import 'models/foo_fixed.dart';

void runCase() {
  final emptyJson = <String, dynamic>{'bar': <String, dynamic>{}};

  try {
    final value = Foo.fromJson(emptyJson);
    print('1: value.foo = ${value.foo}');
  } catch (e) {
    print('1: Ops! ${e.toString()}');
  }

  try {
    final fixedValue = FooFixed.fromJson(emptyJson);
    print('2: fixedValue.foo = ${fixedValue.foo}');
  } catch (e) {
    print('2: Ops! ${e.toString()}');
  }
}
