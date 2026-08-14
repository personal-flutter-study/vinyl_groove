import 'package:flutter/material.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/models/album_model.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.albumModel,
    this.size = 18,
    this.action,
    this.fav,
  });

  final AlbumModel albumModel;

  final double size;

  final VoidCallback? action;
  final bool? fav;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool press = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appCtrl.ticker,
      builder: (context, child) {
        final album = widget.albumModel;
        final fav = widget.fav ?? appCtrl.likes.contains(album);
        return AnimatedScale(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          scale: press ? 1.2 : 1,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              minimumSize: .zero,
            ),
            onPressed: () async {
              press = true;
              setState(() {});

              if (widget.action == null) {
                if (!appCtrl.likes.remove(album)) appCtrl.likes.add(album);
                appCtrl.save();
                appCtrl.ticker.value++;
              } else {
                widget.action?.call();
              }

              await Future.delayed(Duration(milliseconds: 200));

              press = false;
              setState(() {});
            },
            icon: Icon(
              size: widget.size,
              fav ? Icons.favorite : Icons.favorite_border,
              color: fav ? Colors.red : Colors.white,
            ),
          ),
        );
      },
    );
  }
}
