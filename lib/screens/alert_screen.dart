import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_3/app_ctrl.dart';
import 'package:vinyl_groove_poc_3/screens/album_screen.dart';

import '../main.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  read({all, id}) =>
      put(
        Uri.parse('http://${baseUrl}/notifications/read').replace(
          queryParameters: {'id': id?.toString(), 'all': all?.toString()}
            ..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) async {
        final body = jsonDecode(value.body);

        if (value.statusCode == 200) {
          message(body['message']);
          await appCtrl.loadAlert();
          return;
        }
        message((body['errors'] as List).first['message']);

        return null;
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: appCtrl.ticker,
        builder: (context, child) {
          final List alerts = appCtrl.alerts?['notifications'] ?? [];
          return Scaffold(
            appBar: AppBar(
              actions: [
                if (alerts.isNotEmpty)
                  PopupMenuButton(
                    color: black2,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () async {
                          await read(all: true);
                        },
                        child: Text(
                          '모두 읽음',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: .bold,
                          ),
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
                                  onPressed: () async {
                                    await delete(
                                      Uri.parse(
                                        'http://${baseUrl}/notifications',
                                      ),
                                      headers: baseHeader,
                                    ).then((value) async {
                                      final body = jsonDecode(value.body);

                                      if (value.statusCode == 200) {
                                        message(body['message']);
                                        await appCtrl.loadAlert();
                                        return;
                                      }

                                      message(
                                        (body['errors'] as List)
                                            .first['message'],
                                      );

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
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                    ],
                    child: Icon(Icons.more_vert, color: Colors.white),
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
                style: TextStyle(fontWeight: .bold, color: Colors.white),
              ),
            ),
            backgroundColor: black,
            body: RefreshIndicator(
              onRefresh: () async {
                await appCtrl.loadAlert();
              },
              child: alerts.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        return ListView(
                          children: [
                            SizedBox(
                              height: constraints.maxHeight,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: .center,
                                  spacing: 12,
                                  children: [
                                    AppIcon.notification.icon(
                                      size: 72,
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
                                      style: TextStyle(color: Colors.white60),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : ListView(
                      children: alerts.map((e) {
                        final down = e['title'] == '가격 인하';

                        final isRead = e['isRead'];

                        return InkWell(
                          onTap: () async {
                            await read(id: e['id']);
                            await appCtrl.loadAlert();
                            context.go(AlbumScreen(id: e['productId']));
                          },
                          child: Material(
                            color: !isRead ? yellow.withAlpha(12) : black,
                            shape: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.white24,
                                width: .5,
                              ),
                            ),
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
                                      spacing: 4,
                                      crossAxisAlignment: .start,
                                      children: [
                                        Row(
                                          spacing: 4,
                                          children: [
                                            Icon(
                                              down
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              color: down
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                            Text(
                                              e['title'],
                                              style: TextStyle(
                                                color: down
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          e['albumName'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          spacing: 8,
                                          children: [
                                            Text(
                                              NumberFormat(
                                                '₩ #,###',
                                              ).format(e['previousPrice']),
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12,
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
                                              NumberFormat(
                                                '₩ #,###',
                                              ).format(e['currentPrice']),
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
                                    spacing: 4,
                                    children: [
                                      Text(
                                        date(.parse(e['createdAt'])),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white60,
                                        ),
                                      ),

                                      if (!isRead)
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor: yellow,
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
