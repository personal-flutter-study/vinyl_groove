import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vinyl_groove_poc_14/app_ctrl.dart';

import '../main.dart';
import 'album_screen.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  read({all, id}) =>
      put(
        Uri.parse('http://${baseUrl}/notifications/read').replace(
          queryParameters: {'all': all?.toString(), 'id': id?.toString()}
            ..removeWhere((key, value) => value == null),
        ),
        headers: baseHeader,
      ).then((value) {
        final body = jsonDecode(value.body);

        if (body['success'] ?? false) {
          message(body['message']);
          appCtrl.loadAlerts();
          return body;
        }

        message((body['errors'] as List?)?.firstOrNull['message']);
      }, onError: (e) => message('서버 통신 오류'));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appCtrl.ticker2,
      builder: (context, _, child) {
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
                                    context.back();

                                    delete(
                                      Uri.parse(
                                        'http://${baseUrl}/notifications',
                                      ),
                                      headers: baseHeader,
                                    ).then((value) {
                                      final body = jsonDecode(value.body);

                                      if (body['success'] ?? false) {
                                        message(body['message']);
                                        appCtrl.loadAlerts();
                                        return body;
                                      }

                                      message(
                                        (body['errors'] as List?)
                                            ?.firstOrNull['message'],
                                      );
                                    }, onError: (e) => message('서버 통신 오류'));
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
              actionsPadding: .symmetric(horizontal: 8),
              leading: IconButton(
                style: IconButton.styleFrom(),
                onPressed: () {
                  context.back();
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                '알림',
                style: TextStyle(color: Colors.white, fontWeight: .bold),
              ),
            ),
            resizeToAvoidBottomInset: false,
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
                                mainAxisSize: .min,
                                spacing: 12,
                                children: [
                                  AppIcon.notification.icon(
                                    color: Colors.white38,
                                    size: 72,
                                  ),

                                  Text(
                                    '알림이 없습니다.',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 16,
                                      fontWeight: .bold,
                                    ),
                                  ),

                                  Text(
                                    '관심 상품의 가격이 변경되면 알려드릴게요.',
                                    style: TextStyle(color: Colors.white38),
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
                        final isRead = e['isRead'];
                        final down = e['title'] == '가격 인하';

                        return Material(
                          shape: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.white10,
                              width: .5,
                            ),
                          ),
                          clipBehavior: .antiAlias,
                          color: isRead ? black : yellow.withAlpha(12),
                          child: InkWell(
                            onTap: () {
                              read(id: e['id']);
                              context.go(AlbumScreen(id: e['productId']));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: .start,
                                spacing: 12,
                                children: [
                                  ClipRRect(
                                    borderRadius: .circular(12),
                                    child: Image.network(
                                      e['albumImage'],
                                      fit: .cover,
                                      width: 72,
                                      height: 72,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              SizedBox(),
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
                                                fontWeight: .w500,
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
                                            fontSize: 16,
                                            fontWeight: isRead ? .w400 : .bold,
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
                                                decoration: .lineThrough,
                                                decorationThickness: 1.5,
                                                decorationColor: Colors.white60,
                                              ),
                                            ),

                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white60,
                                              size: 18,
                                            ),
                                            Text(
                                              NumberFormat(
                                                '₩ #,###',
                                              ).format(e['currentPrice']),
                                              overflow: .ellipsis,
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
                                    spacing: 8,
                                    children: [
                                      Text(
                                        date(.parse(e['createdAt'])),
                                        overflow: .ellipsis,
                                        style: TextStyle(
                                          color: Colors.white38,
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
