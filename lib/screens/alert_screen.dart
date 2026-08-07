import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_1/screens/album_screen.dart';

import '../main.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key, required this.alerts});

  final List alerts;

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  Future<void> readAlert({id, all}) async {
    put(
        Uri.parse(
          'http://${baseUrl}/notifications/read',
        ).replace(queryParameters: {"all": all, "id": id}),
        headers: {...authHeader, ...jsonHeader}
    ).then((value) {
      final body = value.body;

      if (value.statusCode == 200) {
        return true;
      }

      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alerts = widget.alerts;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              context.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            '알림',
            style: TextStyle(color: Colors.white, fontWeight: .bold),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: black,
        body: alerts.isEmpty
            ? Center(
          child: Column(
            spacing: 8,
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.notifications_none,
                color: Colors.white60,
                size: 72,
              ),

              Text(
                '알림이 없습니다.',
                style: TextStyle(
                  fontWeight: .bold,
                  color: Colors.white60,
                ),
              ),

              Text(
                '관심 상품의 가격이 변경되면 알려드릴게요.',
                style: TextStyle(color: Colors.white60),
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          child: Column(
            children: alerts.map((e) {
              final priceP = e['previousPrice'];
              final priceC = e['currentPrice'];

              final read = e['isRead'];

              final incre = priceP <= priceC;


              final id = e['id'];

              return ListTile(
                onTap: () {
                  readAlert(id: id).then((value) {
                    context.go(AlbumScreen(albumModel: albumModel))
                  },);
                },
                tileColor: !read ? yellow.withAlpha(10) : null,
                contentPadding: .all(8),
                leading: ClipRRect(
                  borderRadius: .circular(12),
                  child: SizedBox.square(
                    dimension: 64,
                    child: Image.network(e['albumImage'], fit: .fill),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 18,
                          color: Colors.green,
                        ),
                        Text(
                          e['title'],
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      e['albumName'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                subtitle: Row(
                  spacing: 8,
                  children: [
                    Text(
                      "\₩${NumberFormat('###,###').format(priceP)}",
                      style: TextStyle(
                        decoration: .lineThrough,
                        decorationColor: Colors.white,
                        decorationThickness: 1.5,
                        color: Colors.white60,
                      ),
                    ),

                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white60,
                      size: 18,
                    ),

                    Text(
                      "\₩${NumberFormat('###,###').format(priceC)}",
                      style: TextStyle(color: yellow, fontWeight: .bold),
                    ),
                  ],
                ),
                trailing: SizedBox(
                  height: .infinity,
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: [
                      Text(
                        dateformat(DateTime.parse(e['createdAt'])),
                        style: TextStyle(color: Colors.white60),
                      ),

                      if (!read)
                        CircleAvatar(radius: 4, backgroundColor: yellow),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

dateformat(date) {
  final differ = DateTime.now().difference(date);

  if (differ.inDays >= 1) {
    return '${differ.inDays}일 전';
  }
  if (differ.inHours >= 1) {
    return '${differ.inHours}시간 전';
  }
  return '${differ.inMinutes}분 전';
}
