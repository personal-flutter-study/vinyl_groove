Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                color: black2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: yellow.withAlpha(100),
                                        child: Icon(
                                          Icons.person,
                                          size: 28,
                                          color: yellow,
                                        ),
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            Text(
                                              'sdfdsf',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: .bold,
                                              ),
                                            ),
                                            Text(
                                              'sdfdsf',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontWeight: .w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );