import 'package:json_annotation/json_annotation.dart';

Map<String, dynamic> toJsonNoNulls(JsonSerializable serializable) {
  return serializable.toJson()..removeWhere((key, value) => value == null);
}
