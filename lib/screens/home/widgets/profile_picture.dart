// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/models/user.dart';
import 'package:twitch_chat_flutter/repositories/twitch.dart';

class ProfilePicture extends StatelessWidget {
  final String userLogin;
  final double radius;

  const ProfilePicture({
    Key? key,
    required this.userLogin,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;

    return ClipOval(
      child: FutureBuilder(
        future: context.read<TwitchRepository>().getUser(userLogin: userLogin),
        builder: (context, AsyncSnapshot<UserTwitch> snapshot) {
          return snapshot.hasData
              ? CachedNetworkImage(
                  width: diameter,
                  height: diameter,
                  imageUrl: snapshot.data!.profileImageUrl,
                )
              : SizedBox(
                  width: diameter,
                  height: diameter,
                );
        },
      ),
    );
  }
}
