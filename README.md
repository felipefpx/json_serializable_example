## Json Serializable Example

This project was created to illustrate an issue you can face when migrating partially your project to dart 2.12+ (null safety), in which requires `--no-sound-null-safety` or `//@dart=2.10` to run the project in a compatibility mode to work with legacy packages during the migration process.

Furthermore, this is also useful to learn more about `@JsonKey` properties.

### Problem statement

Consider that you are working in dart project for a big company with hundred packages and you need to bump dart version to 2.12+ in order to make use of null safety benefits, but this process will take too long and you need to interoperate with legacy dart packages while the bump is not completed.

### Old Json Serializable - No null safety support

[foo.dart](old_json_serializable_example/bin/models/foo.dart) is a class with four fields but only two fields are nullable (in order to compare the generated code):
```dart
part 'foo.g.dart'
...
  @JsonKey(nullable: true)
  final String fooNullable;

  @JsonKey(nullable: false)
  final String foo;

  @JsonKey(nullable: true)
  final Bar barNullable;

  @JsonKey(nullable: false)
  final Bar bar;
```

After running the build runner to build the generated files `$ make build-generators`, the [foo.g.dart](old_json_serializable_example/bin/models/foo.dart) will be generated:

```dart

part of 'foo.dart';
...
Foo _$FooFromJson(Map<String, dynamic> json) {
  return Foo(
    fooNullable: json['foo_nullable'] as String,
    foo: json['foo'] as String,
    barNullable: json['bar_nullable'] == null
        ? null
        : Bar.fromJson(json['bar_nullable'] as Map<String, dynamic>),
    bar: Bar.fromJson(json['bar'] as Map<String, dynamic>),
  );
}
```

As you can see, the parser function will try to get a field from `json` called `foo_nullable` and cast to `String` type. 

If `foo_nullable` is absent on `json` (key doesn't exist), both `json['foo_nullable']` and `json['foo_nullable']` will be null, because the `null as String` is equal to `null` in dart version <2.12 (no null safety support).


In order to check it, you can run the old json serializable example:
```bash
$ dart old_json_serializable_example/bin/old_json_serializable_example.dart 
0: null
1: foo = null
2: foo = null
```

### Json Serializable with null safety support

Now, consider that you already migrated [foo.dart](ns_json_serializable_example/bin/models/foo.dart):
```dart
part 'foo.g.dart'
...
  @JsonKey()
  final String? fooNullable;

  @JsonKey()
  final String foo;

  @JsonKey()
  final Bar? barNullable;

  @JsonKey()
  final Bar bar;
```

The `nullable: true` property is not required for `JsonKey` because the new version uses dart null safety to ensure the nullability, because optional type will be used to cast nullable values:

```dart
part of 'foo.dart';
...
Foo _$FooFromJson(Map<String, dynamic> json) {
  return Foo(
    fooNullable: json['foo_nullable'] as String?, // Nullable type
    foo: json['foo'] as String, // Non-nullable type
    barNullable: json['bar_nullable'] == null
        ? null
        : Bar.fromJson(json['bar_nullable'] as Map<String, dynamic>),
    bar: Bar.fromJson(json['bar'] as Map<String, dynamic>),
  );
}
```

If we run the [sound_example.dart](ns_json_serializable_example/bin/sound_example.dart) it will works properly:
```dart
...
  try {
    print('0: ${null as String}');
  } catch (e) {
    print('0: Ops! ${e.toString()}');
  }

  final emptyJson = <String, dynamic>{};

  try {
    // ignore: omit_local_variable_types
    final String? foo = emptyJson['foo'] as String?;
    print('1: foo = $foo');

    // ignore: omit_local_variable_types
    final String bar = emptyJson['bar'] as String;
    print('1: bar = $bar');
  } catch (e) {
    print('1: Ops! ${e.toString()}');
  }
...
```

As the map does not contains the `foo` key, it will throw an error on the cast, because for dart with null safety `null` cannot be cast as `String`:

```bash
$ dart ns_json_serializable_example/bin/sound_example.dart 
0: Ops! type 'Null' is not a subtype of type 'String' in type cast
1: foo = null
1: type 'Null' is not a subtype of type 'String' in type cast
```

Ok, it makes sense... but... what if we run the code with `--no-sound-null-safety`?!

```bash
$ dart --no-sound-null-safety ns_json_serializable_example/bin/sound_example.dart
0: null
1: value.foo = null
...
```

Oh, no! It also makes sense, because before null safety `null as String` is equals to `null`. What could we do to ensure the project throws an error instead of propagating `null`?

`json_serializable` and `json_annotations` provide some useful key checks that can be used to solve this problem. Let's check the [foo_fixed.dart](ns_json_serializable_example/bin/models/foo_fixed.dart):

```dart
part 'foo_fixed.g.dart';
...
  @JsonKey()
  final String? fooNullable;

  @JsonKey(required: true, disallowNullValue: true)
  final String foo;

  @JsonKey()
  final Bar? barNullable;

  @JsonKey(required: true, disallowNullValue: true)
  final Bar bar;
...
```

When you run `$ make build-generators` it will generate the [foo_fixed.g.dart](ns_json_serializable_example/bin/models/foo_fixed.g.dart):
```dart
part of 'foo_fixed.dart';

...

FooFixed _$FooFixedFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['foo', 'bar'],
      disallowNullValues: const ['foo', 'bar']);
  return FooFixed(
    fooNullable: json['foo_nullable'] as String?,
    foo: json['foo'] as String,
    barNullable: json['bar_nullable'] == null
        ? null
        : Bar.fromJson(json['bar_nullable'] as Map<String, dynamic>),
    bar: Bar.fromJson(json['bar'] as Map<String, dynamic>),
  );
}
```

It will basically call the `$checkKeys` function to ensure that the required keys are present on `json` with a value that is not `null`.

So, if we run the example [case](ns_json_serializable_example/bin/case.dart) again with both dart null-safety and `--no-sound-null-safety` it will throw an exception when the keys are absent.

```dart
...
  try {
    print('0: ${null as String}');
  } catch (e) {
    print('0: Ops! ${e.toString()}');
  }

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
```

```bash
$ dart --no-sound-null-safety ns_json_serializable_example/bin/sound_example.dart
0: null
1: value.foo = null
2: Ops! Instance of 'MissingRequiredKeysException'
```

```bash
$ dart ns_json_serializable_example/bin/sound_example.dart
0: Ops! type 'Null' is not a subtype of type 'String' in type cast
1: Ops! type 'Null' is not a subtype of type 'String' in type cast
2: Ops! Instance of 'MissingRequiredKeysException'
```