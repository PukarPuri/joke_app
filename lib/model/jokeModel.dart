class jokeModel {
  String? id;
  String? joke;
  String? post;

  jokeModel({
    required this.id,
    required this.joke,
    required this.post,
  });

  factory jokeModel.fromJson(Map<String, dynamic> json) => jokeModel(
        id: json["id"],
        joke: json["joke"],
        post: json["post"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "joke": joke,
        "post": post,
      };
}
