import 'package:gemini/core/constants/constant.dart';
import 'package:gemini/features/gemini/business/entities/qn_ans_entity.dart';

class QuestionItemModel extends QuestionItemEntity {
  QuestionItemModel({
    required String id,
    required String question,
  }) : super(id: id, question: question);

  factory QuestionItemModel.fromJson(Map<String, dynamic> json) {
    return QuestionItemModel(
      id: json[kid],
      question: json[kquestion],
    );
  }
}

class AnswerModel extends AnswerEntity {
  AnswerModel({required String answer}) : super(answer: answer);

  AnswerModel.fromJson(Map<String, dynamic> json) {
    answer = json[kanswer];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[kanswer] = this.answer;
    return data;
  }
}
