import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_2/app_ctrl.dart';

import '../main.dart';
import 'album_screen.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  readAlert({all, id}) =>
      put(
        Uri.parse('http://${baseUrl}/notifications/read').replace(
          queryParameters: {'all': all?.toString(), 'id': id?.toString()}
            ..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) async {
        try {
          final body = jsonDecode(value.body);

          if (value.statusCode == 200) {
            await appCtrl.loadAlerts();
            return null;
          }
        } catch (e) {
          print(e);
        }
        return null;
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: appCtrl.ticker,
        builder: (context, child) {
          final alerts = appCtrl.alerts?['notifications'] as List?;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.back();
                },
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                PopupMenuButton(
                  color: black2,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        readAlert(all: true);
                      },
                      child: Text(
                        '모두 읽음',
                        style: TextStyle(
                          fontWeight: .bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        print('sdf');

                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text('알림 전체 삭제'),
                            actions: [
                              CupertinoButton(

                                child: Text('취소'),
                                onPressed: () {
                                  context.back();
                                },
                              ),
                              CupertinoButton(
                                child: Text('삭제'),
                                onPressed: () async {
                                  delete(
                                    Uri.parse(
                                      'http://${baseUrl}/notifications',
                                    ),
                                    headers: baseHeader,
                                  ).then((value) async {
                                    try {
                                      final body = jsonDecode(value.body);

                                      if (value.statusCode == 200) {
                                        await appCtrl.loadAlerts();
                                        return null;
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                    return null;
                                  });

                                  context.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        '전체 삭제',
                        style: TextStyle(color: Colors.red, fontWeight: .bold),
                      ),
                    ),
                  ],
                  child: Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
              backgroundColor: Colors.transparent,
              title: Text(
                '알림',
                style: TextStyle(color: Colors.white, fontWeight: .bold),
              ),
            ),
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: alerts == null || alerts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      spacing: 12,
                      children: [
                        AppIcon.notification.icon(
                          size: 80,
                          color: Colors.white60,
                        ),

                        Text(
                          '알림이 없습니다.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 18,
                            fontWeight: .bold,
                          ),
                        ),
                        Text(
                          '관심 상품의 가격이 변경되면 알려드릴게요.',
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: alerts.map((e) {
                        final down = e['title'] == '가격 인하';

                        final read = e['isRead'];

                        return Material(
                          color: !read ? yellow.withAlpha(40) : black,
                          shape: Border.symmetric(
                            horizontal: BorderSide(color: Colors.white12),
                          ),
                          child: InkWell(
                            onTap: () async {
                              await readAlert(id: e['id']);
                              await context.go(AlbumScreen(id: e['productId']));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                spacing: 12,
                                crossAxisAlignment: .start,
                                children: [
                                  ClipRRect(
                                    borderRadius: .circular(12),
                                    child: Image.network(
                                      e['albumImage'],
                                      width: 72,
                                      height: 72,
                                      fit: .cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: .min,
                                      crossAxisAlignment: .start,
                                      spacing: 4,
                                      children: [
                                        Row(
                                          spacing: 4,
                                          children: [
                                            Icon(
                                              down
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              color: down
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 18,
                                            ),
                                            Text(
                                              '${e['title']}',
                                              style: TextStyle(
                                                fontWeight: .bold,
                                                color: down
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          e['albumName'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: .bold,
                                          ),
                                        ),
                                        Row(
                                          spacing: 4,
                                          children: [
                                            Text(
                                              '₩${NumberFormat('#,###').format(e['previousPrice'])}',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                decoration: .lineThrough,
                                                decorationColor: Colors.white60,
                                              ),
                                            ),

                                            Icon(
                                              Icons.arrow_forward,
                                              size: 14,
                                              color: Colors.white60,
                                            ),
                                            Text(
                                              '₩${NumberFormat('#,###').format(e['currentPrice'])}',
                                              style: TextStyle(
                                                color: yellow,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisSize: .min,
                                    spacing: 4,
                                    children: [
                                      Text(
                                        date(DateTime.parse(e['createdAt'])),
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),

                                      if (!read)
                                        CircleAvatar(
                                          backgroundColor: yellow,
                                          radius: 4,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

String date(date) {
  final differ = DateTime.now().difference(date);

  if (differ.inDays >= 1) {
    return '${differ.inDays}일 전';
  }
  if (differ.inHours >= 1) {
    return '${differ.inHours}시간 전';
  }
  return '${differ.inMinutes}분 전';
}
