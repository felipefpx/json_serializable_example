void main() {
  final emptyJson = <String, dynamic>{};

  try {
    // ignore: omit_local_variable_types
    final String? foo = emptyJson['foo'] as String?;
    print('1: foo = $foo');

    // ignore: omit_local_variable_types
    final String bar = emptyJson['bar'] as String;
    print('1: bar = $bar');
  } catch (e) {
    print('1: ${e.toString()}');
  }

  final nullValuesJson = <String, dynamic>{'foo': null, 'bar': null};
  try {
    // ignore: omit_local_variable_types
    final String? foo = nullValuesJson['foo'] as String?;
    print('2: foo = $foo');

    // ignore: omit_local_variable_types
    final String bar = nullValuesJson['bar'] as String;
    print('2: bar = $bar');
  } catch (e) {
    print('2: ${e.toString()}');
  }
}
