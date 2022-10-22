class UserTwitch {
  final String id;
  final String login;
  final String displayName;
  final String profileImageUrl;

  const UserTwitch({
    required this.id,
    required this.login,
    required this.displayName,
    required this.profileImageUrl,
  });

  factory UserTwitch.fromJson(Map<String, dynamic> json) {
    return UserTwitch(
      id: json['id'],
      login: json['login'],
      displayName: json['display_name'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}
