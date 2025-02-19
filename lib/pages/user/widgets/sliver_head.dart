import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../config/theme.dart';
import '../../../utils/picture.dart';
import '../../../widget/avatar.dart';
import '../../../widget/large_custom_header.dart';
import '../stores/user_store.dart';
import 'header_content.dart';

class SliverHeader extends StatefulWidget {
  const SliverHeader({
    Key? key,
    required this.tabBarHeight,
    required this.store,
    required this.tabController,
  }) : super(key: key);

  final double tabBarHeight;
  final UserPageStore store;
  final TabController tabController;

  @override
  _SliverHeaderState createState() => _SliverHeaderState();
}

class _SliverHeaderState extends State<SliverHeader> {
  final double titleHeight = 160;
  double bioHeight = 20;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SliverPersistentHeader(
      // floating: true,
      pinned: true,
      delegate: LargeCustomHeader(
        navBarHeight: appBarHeight + MediaQuery.of(context).padding.top,
        titleHeight: titleHeight + bioHeight,
        tabBarHeight: widget.tabBarHeight,
        barCenterTitle: false,
        backgroundImage: getPictureUrl(
          key: widget.store.user!.cover ?? widget.store.user!.avatar,
          style: widget.store.user!.cover != null
              ? PictureStyle.blur
              : PictureStyle.blur,
        ),
        titleTextStyle: TextStyle(
          color: theme.cardColor,
          fontSize: 36,
        ),
        title: UserHeaderContent(
          store: widget.store,
          onHeightChanged: (double height) {
            setState(() {
              bioHeight = height;
            });
          },
        ),
        tabBar: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0d000000),
                blurRadius: 0.2 * 1.0,
                offset: Offset(0, 0.2 * 2.0),
              )
            ],
          ),
          child: TabBar(
            controller: widget.tabController,
            tabs: const <Widget>[
              Tab(
                text: '照片',
              ),
              Tab(
                text: '收藏夹',
              ),
            ],
            onTap: (int index) {
              // setState(() {
              //   _tabIndex = index;
              // });
            },
            labelColor: theme.textTheme.bodyText2!.color,
            indicator: MaterialIndicator(
              height: 3,
              topLeftRadius: 12,
              topRightRadius: 12,
              bottomLeftRadius: 12,
              bottomRightRadius: 12,
              horizontalPadding: 92,
              color: theme.primaryColor.withOpacity(.8),
            ),
          ),
        ),
        bar: Row(
          children: <Widget>[
            Avatar(
              size: 38,
              image: widget.store.user!.avatarUrl,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.store.user!.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            )
          ],
        ),
        actions: [
          // TouchableOpacity(
          //   activeOpacity: activeOpacity,
          //   onTap: () {
          //     // showBasicModalBottomSheet(
          //     //   enableDrag: true,
          //     //   context: context,
          //     //   builder: (BuildContext context) =>
          //     //       PictureDetailMoreHandle(
          //     //     picture: data,
          //     //   ),
          //     // );
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.only(right: 12),
          //     child: Icon(
          //       FeatherIcons.moreHorizontal,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
