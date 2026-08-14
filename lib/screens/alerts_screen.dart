import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_6/app_ctrl.dart';

import '../main.dart';
import 'album_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  read({id, all}) =>
      put(
        Uri.parse('http://${baseUrl}/notifications/read').replace(
          queryParameters: {'id': id?.toString(), 'all': all?.toString()}
            ..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) {
        try {
          final body = jsonDecode(value.body);
          if (body['success'] ?? false) {
            message(body['message']);
            appCtrl.loadAlerts();
            return body['data'];
          }
          message((body['errors'] as List?)?.first['message']);
        } catch (e) {
          message("서버 통신 에러");
        }
      }, onError: (e) => message("서버 통신 에러"));

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appCtrl.ticker2,
      builder: (context, child) {
        final List alerts = appCtrl.alerts?['notifications'] ?? [];
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                if (alerts.isNotEmpty)
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
                                    delete(
                                      Uri.parse(
                                        'http://${baseUrl}/notifications',
                                      ),
                                      headers: baseHeader,
                                    ).then((value) {
                                      try {
                                        final body = jsonDecode(value.body);
                                        if (body['success'] ?? false) {
                                          message(body['message']);
                                          appCtrl.loadAlerts();
                                          return body['data'];
                                        }
                                        message(
                                          (body['errors'] as List?)
                                              ?.first['message'],
                                        );
                                      } catch (e) {
                                        message("서버 통신 에러");
                                      }
                                    }, onError: (e) => message("서버 통신 에러"));

                                    context.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          '전체 삭제',
                          style: TextStyle(color: Colors.red),
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
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Text(
                '알림',
                style: TextStyle(color: Colors.white, fontWeight: .bold),
              ),
            ),
            backgroundColor: black,
            resizeToAvoidBottomInset: false,
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
                                    color: Colors.white60,
                                    size: 68,
                                  ),
                                  Text(
                                    '알림이 없습니다.',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 16,
                                      fontWeight: .w500,
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
                          color: isRead ? black : yellow.withAlpha(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(12),
                          ),
                          child: InkWell(
                            onTap: () async {
                              context.go(AlbumScreen(id: e['productId']));
                              await read(id: e['id']);
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
                                      fit: .cover,
                                      width: 64,
                                      height: 64,
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
                                              size: 18,
                                              down
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_upward,
                                              color: down
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),

                                            Text(
                                              e['title'],
                                              style: TextStyle(
                                                color: down
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: .w500,
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
                                                '₩ #,###',
                                              ).format(e['previousPrice']),
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12,
                                              ),
                                            ),

                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white60,
                                              size: 14,
                                            ),

                                            Text(
                                              NumberFormat(
                                                '₩ #,###',
                                              ).format(e['currentPrice']),
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: yellow,
                                                fontWeight: .bold,
                                                fontSize: 14,
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
