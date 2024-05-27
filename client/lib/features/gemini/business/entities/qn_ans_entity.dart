class QuestionItemEntity {
  final String? id;
  final String question;

  const QuestionItemEntity({
    this.id,
    required this.question,
  });
}

class AnswerEntity {
  String? answer;

  AnswerEntity({this.answer});
}
