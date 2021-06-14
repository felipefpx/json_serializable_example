import 'package:json_annotation/json_annotation.dart';

part 'foo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Foo {
  const Foo({
    this.fooNullable,
    required this.foo,
    this.barNullable,
    required this.bar,
  });

  factory Foo.fromJson(Map<String, dynamic> json) => _$FooFromJson(json);

  Map<String, dynamic> toJson() => _$FooToJson(this);

  @JsonKey()
  final String? fooNullable;

  @JsonKey()
  final String foo;

  @JsonKey()
  final Bar? barNullable;

  @JsonKey()
  final Bar bar;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Bar {
  const Bar({this.bar});

  factory Bar.fromJson(Map<String, dynamic> json) => _$BarFromJson(json);

  Map<String, dynamic> toJson() => _$BarToJson(this);

  @JsonKey()
  final String? bar;
}
