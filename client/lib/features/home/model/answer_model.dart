class Answer {
  String? answer;

  Answer({this.answer});

  Answer.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    return data;
  }
}
