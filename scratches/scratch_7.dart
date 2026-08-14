                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: black2,
                            foregroundColor: Colors.white,
                            padding: .symmetric(vertical: 6, horizontal: 16),
                            minimumSize: .zero,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              Text(
                                NumberFormat('₩ #,###').format(pri.start),
                                style: TextStyle(fontWeight: .bold),
                              ),
                            ],
                          ),
                        )