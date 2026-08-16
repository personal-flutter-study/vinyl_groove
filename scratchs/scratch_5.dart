ListTile(
                                contentPadding: .all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(12),
                                ),
                                tileColor: black3,
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
                                  'sdsfsd',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: .bold,
                                    fontSize: 18,
                                  ),
                                ),

                                subtitle: Text(
                                  'sdfsdfsdf',
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