import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_7/app_ctrl.dart';
import 'package:vinyl_groove_poc_7/models/album_model.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.albumModel,
    this.size = 18,
    this.fav,
    this.act,
  });

  final AlbumModel albumModel;
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
    final album = widget.albumModel;

    return ListenableBuilder(
      listenable: appCtrl.ticker,
      builder: (context, child) {
        final fav = widget.fav ?? appCtrl.likes.contains(album);
        return AnimatedScale(
          curve: Curves.decelerate,
          scale: press ? 1.4 : 1,
          duration: Duration(milliseconds: 300),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              minimumSize: .zero,
            ),
            onPressed: () async {
              press = true;
              setState(() {});

              await Future.delayed(Duration(milliseconds: 150));

              press = false;
              setState(() {});

              if (widget.act == null) {
                if (!appCtrl.likes.remove(album)) appCtrl.likes.add(album);
                await appCtrl.save();
              } else {
                widget.act?.call();
              }
            },
            icon: Icon(
              fav ? Icons.favorite : Icons.favorite_outline,
              color: fav ? Colors.red : Colors.white,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}
