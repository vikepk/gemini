class QuestionItem {
  final String id;
  final String question;

  QuestionItem({
    required this.id,
    required this.question,
  });

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    return QuestionItem(
      id: json['_id'],
      question: json['question'],
    );
  }
}
