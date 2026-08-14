ListTile(
                                tileColor: black2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                contentPadding: .all(12),
                                leading: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: yellow.withAlpha(100),
                                  child: Icon(
                                    Icons.person,
                                    color: yellow,
                                    size: 32,
                                  ),
                                ),

                                title: Text(
                                  'seldfsds',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: .bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'seldfsds',
                                  style: TextStyle(color: Colors.white60),
                                ),

                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              );