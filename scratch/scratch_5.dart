                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: trade == ''
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor: trade == '' ? yellow : black3,
                              padding: .symmetric(vertical: 8, horizontal: 12),
                              minimumSize: .zero,
                            ),
                            onPressed: () {
                              setState(() {
                                trade = '';
                              });

                              load();
                            },
                            child: Text(
                              '전체',
                              style: TextStyle(fontWeight: .bold, fontSize: 12),
                            ),
                          )