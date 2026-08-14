Container(
                          width: 140,
                          height: 180,
                          decoration: BoxDecoration(
                            color: black3,
                            borderRadius: .circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              SizedBox(
                                height: 100,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        e.albumImage,
                                        fit: .cover,
                                      ),
                                    ),

                                    Align(
                                      alignment: .bottomLeft,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: .circular(4),
                                        ),
                                        color: Colors.black54,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            e.condition,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  spacing: 4,
                                  children: [
                                    Text(
                                      maxLines: 1,
                                      e.albumName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: .bold,
                                        color: Colors.white,
                                      ),
                                    ),

                                    Text(
                                      maxLines: 1,
                                      e.artist,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    Text(
                                      maxLines: 1,
                                      NumberFormat('₩ #,###').format(e.price),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: .bold,
                                        color: yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )