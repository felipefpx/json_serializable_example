import 'package:json_annotation/json_annotation.dart';
import 'foo.dart';

part 'foo_fixed.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FooFixed {
  const FooFixed({
    this.fooNullable,
    required this.foo,
    this.barNullable,
    required this.bar,
  });

  factory FooFixed.fromJson(Map<String, dynamic> json) =>
      _$FooFixedFromJson(json);

  Map<String, dynamic> toJson() => _$FooFixedToJson(this);

  @JsonKey()
  final String? fooNullable;

  @JsonKey(required: true, disallowNullValue: true)
  final String foo;

  @JsonKey()
  final Bar? barNullable;

  @JsonKey(required: true, disallowNullValue: true)
  final Bar bar;
}
