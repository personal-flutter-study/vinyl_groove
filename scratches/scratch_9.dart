                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text(''),
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
                                    },
                                  ),
                                ],
                              ),
                            );