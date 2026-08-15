Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                color: black2,
                                child: InkWell(
                                  onTap: () {
                                    context.go(AlbumScreen(id: e.id));
                                  },

                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      ClipRRect(
                                        borderRadius: .circular(12),
                                        child: Image.network(
                                          e.albumImage,
                                          width: 68,
                                          height: 68,
                                          fit: .cover,
                                        ),
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              e.albumName,
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: .bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              e.artist,
                                              overflow: .ellipsis,

                                              style: TextStyle(color: yellow),
                                            ),
                                            Text(
                                              '${e.genre.l} • ${e.condition}',
                                              overflow: .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 13,
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
                              )