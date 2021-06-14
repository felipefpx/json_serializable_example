// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foo_fixed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

Map<String, dynamic> _$FooFixedToJson(FooFixed instance) => <String, dynamic>{
      'foo_nullable': instance.fooNullable,
      'foo': instance.foo,
      'bar_nullable': instance.barNullable,
      'bar': instance.bar,
    };
