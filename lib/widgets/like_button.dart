import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_10/app_ctrl.dart';
import 'package:vinyl_groove_poc_10/models/album_model.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.albumModel,
    this.size = 18,
    this.act,
    this.fav,
  });

  final AlbumModel albumModel;
  final double size;

  final VoidCallback? act;
  final bool? fav;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool press = false;

  @override
  Widget build(BuildContext context) {
    final album = widget.albumModel;

    return AnimatedScale(
      duration: Duration(milliseconds: 200),
      scale: press ? 1.2 : 1,
      curve: Curves.decelerate,
      child: ValueListenableBuilder(
        valueListenable: appCtrl.ticker,
        builder: (context, _, child) {
          final fav = widget.fav ?? appCtrl.likes.contains(album);
          return IconButton(
            style: IconButton.styleFrom(
              minimumSize: .zero,
              backgroundColor: Colors.black54,
            ),
            onPressed: () async {
              press = true;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 200));
              press = false;
              setState(() {});
              if (widget.act != null) {
                widget.act?.call();
              } else {
                if (!appCtrl.likes.remove(album)) {
                  appCtrl.likes.add(album);
                }
                await appCtrl.save();
              }
            },
            icon: Icon(
              size: widget.size,
              fav ? Icons.favorite : Icons.favorite_outline,
              color: fav ? Colors.red : Colors.white,
            ),
          );
        },
      ),
    );
  }
}
