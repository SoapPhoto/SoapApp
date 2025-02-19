import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

/// 视频手势封装
/// 单击：暂停
/// 双击：点赞，双击后再次单击也是增加点赞爱心
class LikeGesture extends StatefulWidget {
  const LikeGesture({
    Key? key,
    required this.child,
    this.onLike,
    this.onTap,
  }) : super(key: key);

  final Function? onLike;
  final Function? onTap;
  final Widget child;

  @override
  _LikeGestureState createState() => _LikeGestureState();
}

class _LikeGestureState extends State<LikeGesture> {
  final GlobalKey _key = GlobalKey();

  List<Offset> icons = [];

  bool canAddFavorite = false;
  bool justAddFavorite = false;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    final Stack iconStack = Stack(
      children: icons
          .map<Widget>(
            (Offset p) => TikTokFavoriteAnimationIcon(
              key: Key(p.toString()),
              position: p,
              onAnimationComplete: () {
                icons.remove(p);
              },
            ),
          )
          .toList(),
    );
    return TouchableOpacity(
      activeOpacity: 1,
      key: _key,
      onTapDown: (TapDownDetails detail) {
        if (widget.onLike == null) {
          return;
        }
        setState(() {
          if (canAddFavorite) {
            Offset off = detail.localPosition;
            // TODO: 相同位置会报错，让他稍稍移动一下
            if (icons.isNotEmpty) {
              off = icons.firstWhere(
                (Offset of) {
                  if (of.dx == detail.localPosition.dx &&
                      of.dy == detail.localPosition.dy) {
                    return true;
                  }
                  return false;
                },
                orElse: () => Offset.zero,
              );
              if (off == Offset.zero) {
                off = detail.localPosition;
              } else {
                print(off);
                print(Offset(
                  detail.localPosition.dx +
                      math.Random().nextDouble() +
                      math.Random().nextDouble(),
                  detail.localPosition.dy +
                      math.Random().nextDouble() +
                      math.Random().nextDouble(),
                ));
                off = Offset(
                  detail.localPosition.dx +
                      math.Random().nextDouble() -
                      math.Random().nextDouble(),
                  detail.localPosition.dy +
                      math.Random().nextDouble() -
                      math.Random().nextDouble(),
                );
              }
            }
            icons.add(off);
            widget.onLike?.call();
            justAddFavorite = true;
          } else {
            justAddFavorite = false;
          }
        });
      },
      onTapUp: (TapUpDetails detail) {
        timer?.cancel();
        if (widget.onLike == null) {
          widget.onTap?.call();
          return;
        }
        timer = Timer(const Duration(milliseconds: 200), () {
          canAddFavorite = false;
          timer = null;
          if (!justAddFavorite) {
            widget.onTap?.call();
          }
        });
        canAddFavorite = true;
      },
      onTapCancel: () {
        print('onTapCancel');
      },
      child: Stack(
        children: <Widget>[
          widget.child,
          iconStack,
        ],
      ),
    );
  }
}

class TikTokFavoriteAnimationIcon extends StatefulWidget {
  const TikTokFavoriteAnimationIcon({
    Key? key,
    this.onAnimationComplete,
    required this.position,
    this.size = 100,
  }) : super(key: key);

  final Offset position;
  final double size;
  final Function? onAnimationComplete;

  @override
  _TikTokFavoriteAnimationIconState createState() =>
      _TikTokFavoriteAnimationIconState();
}

class _TikTokFavoriteAnimationIconState
    extends State<TikTokFavoriteAnimationIcon> with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _animationController.addListener(() {
      setState(() {});
    });
    startAnimation();
    super.initState();
  }

  Future<void> startAnimation() async {
    await _animationController.forward();
    widget.onAnimationComplete?.call();
  }

  double rotate = math.pi / 10.0 * (2 * math.Random().nextDouble() - 1);

  double get value => _animationController.value;

  double appearDuration = 0.1;
  double dismissDuration = 0.8;

  double get opa {
    if (value < appearDuration) {
      return 0.99 / appearDuration * value;
    }
    if (value < dismissDuration) {
      return 0.99;
    }
    final double res = 0.99 - (value - dismissDuration) / (1 - dismissDuration);
    return res < 0 ? 0 : res;
  }

  double get scale {
    if (value < appearDuration) {
      return 1 + appearDuration - value;
    }
    if (value < dismissDuration) {
      return 1;
    }
    return (value - dismissDuration) / (1 - dismissDuration) + 1;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Icon(
      Ionicons.heart,
      size: widget.size,
      color: Colors.redAccent,
    );
    content = ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) => RadialGradient(
        center: Alignment.topLeft.add(const Alignment(0.66, 0.66)),
        colors: const <Color>[
          Color(0xffEF6F6F),
          Color(0xffF03E3E),
        ],
      ).createShader(bounds),
      child: content,
    );
    final Widget body = Transform.rotate(
      angle: rotate,
      child: Opacity(
        opacity: opa,
        child: Transform.scale(
          alignment: Alignment.bottomCenter,
          scale: scale,
          child: content,
        ),
      ),
    );
    return widget.position == null
        ? Container()
        : Positioned(
            left: widget.position.dx - widget.size / 2,
            top: widget.position.dy - widget.size / 2,
            child: body,
          );
  }
}
