import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_11/app_ctrl.dart';
import 'package:vinyl_groove_poc_11/models/album_model.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.album,
    this.size = 18,
    this.fav,
    this.act,
  });

  final AlbumModel album;
  final double size;

  final bool? fav;
  final VoidCallback? act;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool press = false;

  @override
  Widget build(BuildContext context) {
    final album = widget.album;
    return AnimatedScale(
      duration: Duration(milliseconds: 250),
      scale: press ? 1.2 : 1,
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
                appCtrl.save();
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
