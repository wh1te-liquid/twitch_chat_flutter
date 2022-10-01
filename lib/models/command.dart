class Command {
  final String command;
  final String? channel;

  Command({required this.command, required this.channel});

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      command: json['command'],
      channel: json['channel'],
    );
  }
}
