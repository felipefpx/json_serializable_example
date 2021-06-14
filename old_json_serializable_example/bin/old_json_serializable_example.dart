void main() {
  final emptyJson = <String, dynamic>{};

  // ignore: unnecessary_cast
  print('0: ${null as String}');

  try {
    // ignore: omit_local_variable_types
    final String foo = emptyJson['foo'] as String;
    print('1: foo = $foo');
  } catch (e) {
    print('1: ${e.toString()}');
  }

  final nullValuesJson = <String, dynamic>{'foo': null, 'bar': null};
  try {
    // ignore: omit_local_variable_types
    final String foo = nullValuesJson['foo'] as String;
    print('2: foo = $foo');
  } catch (e) {
    print('2: ${e.toString()}');
  }
}
