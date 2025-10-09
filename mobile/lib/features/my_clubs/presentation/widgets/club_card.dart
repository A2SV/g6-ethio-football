import 'package:ethio_football/core/Presentation/constants/colors.dart';
import 'package:ethio_football/core/Presentation/constants/dimensions.dart';
import 'package:ethio_football/core/Presentation/constants/text_styles.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';
import 'package:ethio_football/features/my_clubs/presentation/bloc/my_clubs_bloc.dart';
import 'package:ethio_football/features/my_clubs/presentation/bloc/my_clubs_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClubCard extends StatelessWidget {
  final dynamic club;

  const ClubCard({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: kPrimaryButtonColor,
                      backgroundImage: club.logoUrl != null
                          ? NetworkImage(club.logoUrl!)
                          : null,
                      child: club.logoUrl == null
                          ? const Icon(Icons.sports_soccer, color: Colors.white)
                          : null,
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        club.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kClubNameFontSize(context),
                          color: kPrimaryTextColor,
                        ),
                        softWrap: true, // 👈 allows wrapping to next line
                        maxLines: 3,
                        textAlign: TextAlign
                            .left, // 👈 optional, limits wrapping to 2 lines
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  club.description,
                  style: TextStyle(
                    fontSize: kDescriptionFontSize(context),
                    color: kSecondaryTextColor,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (club.isFollowed) {
                    context.read<MyClubsBloc>().add(UnfollowClubEvent(club.id));
                  } else {
                    context.read<MyClubsBloc>().add(FollowClubEvent(club.id));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: club.isFollowed
                      ? kPrimaryButtonColorLocked
                      : kPrimaryButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  club.isFollowed ? 'Unfollow' : 'Follow',
                  style: TextStyle(
                    fontSize: kButtonFontSize(context),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
