import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_4/app_ctrl.dart';

import '../main.dart';
import 'album_screen.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  read({id, all}) =>
      put(
        Uri.parse('http://${baseUrl}/notifications/read').replace(
          queryParameters: {'id': id?.toString(), 'all': all?.toString()}
            ..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) async {
        try {
          final body = jsonDecode(value.body);

          if (value.statusCode == 200) {
            message(body['message']);

            await appCtrl.loadAlerts();

            return body;
          }

          message((body['errors'] as List).first['message']);
        } catch (e) {
          print(e);
        }
      });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appCtrl.ticker2,
      builder: (context, child) {
        final List alerts = appCtrl.alerts?['notifications'] ?? [];
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  context.back();
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              actions: [
                PopupMenuButton(
                  color: black2,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        read(all: true);
                      },
                      child: Text(
                        '모두 읽음',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
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
                                onPressed: () {
                                  context.back();

                                  delete(
                                    Uri.parse(
                                      'http://${baseUrl}/notifications',
                                    ),
                                    headers: baseHeader,
                                  ).then((value) async {
                                    try {
                                      final body = jsonDecode(value.body);

                                      if (value.statusCode == 200) {
                                        message(body['message']);
                                        await appCtrl.loadAlerts();
                                        return body;
                                      }

                                      message(
                                        (body['errors'] as List)
                                            .first['message'],
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('전체 삭제', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                  child: Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
              title: Text(
                '알림',
                style: TextStyle(color: Colors.white, fontWeight: .bold),
              ),
            ),
            backgroundColor: black,
            body: RefreshIndicator(
              onRefresh: appCtrl.loadAlerts,
              child: alerts.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: .center,
                                spacing: 12,
                                children: [
                                  AppIcon.notification.icon(
                                    size: 68,
                                    color: Colors.white60,
                                  ),

                                  Text(
                                    '알림이 없습니다.',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 16,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                  Text(
                                    '관심 상품의 가격이 변경되면 알려드릴게요.',
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: alerts.map((e) {
                        final down = e['title'] == '가격 인하';

                        final isRead = e['isRead'];

                        return Material(
                          color: isRead ? black : yellow.withAlpha(16),
                          child: InkWell(
                            onTap: () {
                              context.go(AlbumScreen(id: e['productId']));
                              read(id: e['id']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: .start,
                                spacing: 12,
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
                                      crossAxisAlignment: .start,
                                      spacing: 4,
                                      children: [
                                        Row(
                                          spacing: 8,
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
                                                color: down
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          e['albumName'],
                                          overflow: .ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: .bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Row(
                                          spacing: 8,
                                          children: [
                                            Text(
                                              NumberFormat(
                                                '₩#,###',
                                              ).format(10000),
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                decoration: .lineThrough,
                                                decorationColor: Colors.white60,
                                              ),
                                            ),

                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white60,
                                              size: 16,
                                            ),

                                            Text(
                                              NumberFormat(
                                                '₩#,###',
                                              ).format(1000),
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: yellow,
                                                fontWeight: .bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '',
                                          overflow: .ellipsis,
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    spacing: 4,
                                    children: [
                                      Text(
                                        date(.parse(e['createdAt'])),
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),

                                      if (!isRead)
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
          ),
        );
      },
    );
  }
}

date(DateTime date) {
  final differ = DateTime.now().difference(date);

  if (differ.inDays >= 1) {
    return '${differ.inDays}일 전';
  }
  if (differ.inHours >= 1) {
    return '${differ.inHours}시간 전';
  }
  return '${differ.inMinutes}분 전';
}
