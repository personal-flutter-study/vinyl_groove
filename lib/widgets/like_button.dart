import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_5/app_ctrl.dart';
import 'package:vinyl_groove_poc_5/models/album_model.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.albumModel,
    this.size = 18,
    this.action,
    this.enable,
  });

  final AlbumModel albumModel;

  final double size;

  final VoidCallback? action;
  final bool? enable;

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
        final fav = widget.enable ?? appCtrl.likes.contains(album);
        return AnimatedScale(
          duration: Duration(milliseconds: 200),
          scale: press ? 1.2 : 1,
          curve: Curves.easeOut,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              minimumSize: .zero,
            ),
            onPressed: () async {
              press = true;

              if (widget.action != null) {
                widget.action?.call();
              } else {
                if (!appCtrl.likes.remove(album)) {
                  appCtrl.likes.add(album);
                }

                await appCtrl.save();
              }

              setState(() {});

              await Future.delayed(Duration(milliseconds: 200));

              press = false;
              setState(() {});
              appCtrl.ticker.value++;
            },
            icon: Icon(
              fav ? Icons.favorite : Icons.favorite_border,
              color: fav ? Colors.red : Colors.white,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}
