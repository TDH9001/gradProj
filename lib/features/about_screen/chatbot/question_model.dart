class QuestionModel {
  final String id;
  final String question;
  final List<OptionModel> options;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['question'],
      options: List<OptionModel>.from(
        json['options'].map((x) => OptionModel.fromJson(x)),
      ),
    );
  }
}
class OptionModel {
  final String text;
  final String next;

  OptionModel({required this.text, required this.next});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(text: json['text'], next: json['next']);
  }
}
