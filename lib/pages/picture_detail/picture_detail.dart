import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/picture_detail/widgets/widgets.dart';
import 'package:soap_app/utils/utils.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import 'stores/picture_detail_store.dart';

class PictureDetailPage extends StatefulWidget {
  const PictureDetailPage({
    Key? key,
    required this.picture,
    this.heroLabel,
  }) : super(key: key);
  final Picture picture;
  final String? heroLabel;

  @override
  _PictureDetailPageState createState() => _PictureDetailPageState();
}

class _PictureDetailPageState extends State<PictureDetailPage> {
  final PictureDetailPageStore _pageStore = PictureDetailPageStore();

  @override
  void initState() {
    _pageStore.init(widget.picture);
    _pageStore.watchQuery();
    super.initState();
  }

  @override
  void dispose() {
    _pageStore.close();
    super.dispose();
  }

  void openPictureGallery() {
    Navigator.of(context).push<dynamic>(
      HeroDialogRoute<void>(
        builder: (_) => HeroPhotoGallery(
          id: _pageStore.picture!.id,
          heroLabel: widget.heroLabel,
          url: getPictureUrl(
            key: _pageStore.picture!.key,
            style: PictureStyle.regular,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      backdropBar: true,
      appBar: SoapAppBar(
        backdrop: true,
        border: false,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: PictureAppBarTitle(
          avatar: widget.picture.user!.avatarUrl,
          fullName: widget.picture.user!.fullName,
          openUserPage: () => Navigator.of(context).pushNamed(
            RouteName.user,
            arguments: {
              'user': widget.picture.user!,
              'heroId': '',
            },
          ),
        ),
        actions: [
          TouchableOpacity(
            activeOpacity: activeOpacity,
            onTap: () {
              showBasicModalBottomSheet(
                enableDrag: true,
                context: context,
                builder: (BuildContext context) => PictureDetailMoreHandle(
                  picture: _pageStore.picture!,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                FeatherIcons.moreHorizontal,
                color: theme.textTheme.bodyText2!.color,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: theme.cardColor,
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: <Widget>[
            // const Test(),
            const SizedBox(height: appBarHeight),
            TouchableOpacity(
              activeOpacity: activeOpacity,
              onTap: () {
                openPictureGallery();
              },
              child: RepaintBoundary(
                child: Observer(builder: (_) {
                  return PictureDetailImage(
                    picture: _pageStore.picture!,
                    heroLabel: widget.heroLabel,
                  );
                }),
              ),
            ),
            Observer(builder: (_) {
              return PictureTitleInfo(picture: _pageStore.picture!);
            }),
            Container(
              height: 8,
              color: theme.backgroundColor,
            ),
            Observer(builder: (_) {
              if (_pageStore.picture?.location == null) {
                return const SizedBox();
              }
              return PictureLocationInfo(
                location: _pageStore.picture!.location!,
              );
            }),
            Container(
              color: theme.cardColor,
              child: Column(
                children: <Widget>[
                  Observer(builder: (_) {
                    return PictureDetailInfo(picture: _pageStore.picture!);
                  }),
                  if (widget.picture.make != null ||
                      widget.picture.model != null)
                    Container(
                      height: 8,
                      color: theme.backgroundColor,
                    ),
                  FutureBuilder<dynamic>(
                    future: Future<dynamic>.delayed(
                      Duration(milliseconds: screenDelayTimer),
                    ),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return PictureDetailComment(store: _pageStore);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
            if (_pageStore.picture!.isPrivate == null ||
                _pageStore.picture!.isPrivate == false) ...[
              Container(
                height: 8,
                color: theme.backgroundColor,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  '相关图片',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                  ),
                ),
              ),
              FutureBuilder<dynamic>(
                future: Future<dynamic>.delayed(
                  Duration(milliseconds: screenDelayTimer),
                ),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return RelatedPicture(id: _pageStore.picture!.id);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
            const SizedBox(
              height: pictureDetailHandleHeight,
            ),
          ],
        ),
      ),
      position: Observer(builder: (_) {
        return PictureDetailHandle(picture: _pageStore.picture!);
      }),
    );
  }
}
