class QuestionItemEntity {
  final String id;
  final String question;

  const QuestionItemEntity({
    required this.id,
    required this.question,
  });
}

class AnswerEntity {
  String? answer;

  AnswerEntity({this.answer});
}
