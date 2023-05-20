class Description {
  Description({required this.plaintext});

  final String plaintext;

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      plaintext: json['plaintext'],
    );
  }
}
