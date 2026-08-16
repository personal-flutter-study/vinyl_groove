                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: black2,
                                foregroundColor: Colors.white,
                                padding: .symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                minimumSize: .zero,
                              ),
                              onPressed: () {},
                              child: Text(
                                NumberFormat('₩#,###').format(pri.start),
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 12,
                                ),
                              ),
                            )