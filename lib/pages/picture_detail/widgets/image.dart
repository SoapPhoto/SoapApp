import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/utils/octo_bluehash.dart';
import '../../../config/theme.dart';
import '../../../model/picture.dart';
import '../../../store/index.dart';
import '../../../utils/picture.dart';

class PictureDetailImage extends StatelessWidget {
  const PictureDetailImage({
    Key? key,
    required this.picture,
    this.heroLabel,
  }) : super(key: key);

  final Picture picture;
  final String? heroLabel;

  @override
  Widget build(BuildContext context) {
    final double imgMaxHeight = MediaQuery
        .of(context)
        .size
        .height -
        (MediaQuery
            .of(context)
            .size
            .height / 4) -
        MediaQuery
            .of(context)
            .padding
            .bottom -
        MediaQuery
            .of(context)
            .padding
            .top -
        appBarHeight;
    final double minFactor = MediaQuery
        .of(context)
        .size
        .width / imgMaxHeight;

    final Hero _content = Hero(
      tag: 'picture-$heroLabel-${picture.id}',
      child: Observer(builder: (_) {
        return OctoImage(
          placeholderBuilder: OctoBlurHashFix.placeHolder(
            picture.blurhash,
          ),
          errorBuilder: OctoBlurHashFix.error(
            picture.blurhash,
          ),
          image: ExtendedImage
              .network(
            picture.pictureUrl(
              style: appStore.imgMode == 1
                  ? PictureStyle.regular
                  : PictureStyle.mediumLarge,
            ),
          )
              .image,
          fit: BoxFit.cover,
        );
      }),
    );
    final double num = picture.width / picture.height;
    if (num < minFactor && num < 1) {
      return SizedBox(
        height: imgMaxHeight,
        child: FractionallySizedBox(
          widthFactor: num / minFactor,
          heightFactor: 1,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(6), child: _content),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: AspectRatio(
          aspectRatio: picture.width / picture.height,
          child: _content,
        ),
      );
    }
  }
}
