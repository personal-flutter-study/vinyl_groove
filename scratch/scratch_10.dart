                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text('관심 상품 삭제'),
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
                                         
                                          },
                                        ),
                                      ],
                                    ),
                                  );