// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

Map<String, dynamic> _$FooToJson(Foo instance) => <String, dynamic>{
      'foo_nullable': instance.fooNullable,
      'foo': instance.foo,
      'bar_nullable': instance.barNullable,
      'bar': instance.bar,
    };

Bar _$BarFromJson(Map<String, dynamic> json) {
  return Bar(
    bar: json['bar'] as String,
  );
}

Map<String, dynamic> _$BarToJson(Bar instance) => <String, dynamic>{
      'bar': instance.bar,
    };
