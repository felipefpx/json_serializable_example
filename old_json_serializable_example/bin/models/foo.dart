import 'package:json_annotation/json_annotation.dart';

part 'foo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Foo {
  const Foo({
    this.fooNullable,
    // ignore: always_require_non_null_named_parameters
    this.foo,
    this.barNullable,
    this.bar,
  }) : assert(foo != null, bar != null);

  factory Foo.fromJson(Map<String, dynamic> json) => _$FooFromJson(json);

  Map<String, dynamic> toJson() => _$FooToJson(this);

  @JsonKey(nullable: true)
  final String fooNullable;

  @JsonKey(nullable: false)
  final String foo;

  @JsonKey(nullable: true)
  final Bar barNullable;

  @JsonKey(nullable: false)
  final Bar bar;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Bar {
  const Bar({this.bar});

  factory Bar.fromJson(Map<String, dynamic> json) => _$BarFromJson(json);

  Map<String, dynamic> toJson() => _$BarToJson(this);

  @JsonKey(nullable: true)
  final String bar;
}
