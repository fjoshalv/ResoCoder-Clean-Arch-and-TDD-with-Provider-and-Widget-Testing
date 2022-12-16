import 'package:clean_arch_tdd/core/values/json_keys.dart';
import 'package:clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({
    required super.text,
    required super.number,
  });

  factory NumberTriviaModel.fromJson(Map<String, dynamic> response) =>
      NumberTriviaModel(
        text: response[JsonKeys.text],
        number: (response[JsonKeys.number] as num).toInt(),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      JsonKeys.text: text,
      JsonKeys.number: number,
    };
  }
}
