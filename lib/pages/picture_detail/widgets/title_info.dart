import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';

import '../../../model/picture.dart';
import '../../../model/tag.dart';
import '../../../widget/medal.dart';
import 'tag_item.dart';

class PictureTitleInfo extends StatelessWidget {
  const PictureTitleInfo({
    Key? key,
    required this.picture,
  }) : super(key: key);

  final Picture picture;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: RepaintBoundary(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (picture.isChoice) ...[
                  Medal(
                    type: MedalType.choice,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 4,
                  )
                ],
                Text(
                  picture.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: theme.textTheme.bodyText2!.color,
                  ),
                ),
              ],
            ),
            if (picture.tags == null || picture.tags!.isEmpty)
              const SizedBox()
            else
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    runAlignment: WrapAlignment.end,
                    children: picture.tags!
                        .map(
                          (Tag tag) => TagItem(
                            tag: tag,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Visibility(
                  visible: picture.isPrivate != null && picture.isPrivate!,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 14,
                        width: 14,
                        child: SvgPicture.asset(
                          'assets/remix/lock-fill.svg',
                          color:
                              theme.textTheme.bodyText2!.color!.withOpacity(.6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '私密',
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              theme.textTheme.bodyText2!.color!.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '发布于 ${Jiffy.parse(picture.createTime.toString()).fromNow()}',
                  style: TextStyle(
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
