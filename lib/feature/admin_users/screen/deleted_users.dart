
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import 'package:tharacart_admin_new_app/feature/admin_users/controller/admin_users_controller.dart';
import '../../../core/common/upload_message.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';


class DeletedPendingUsers extends ConsumerWidget {
  DeletedPendingUsers({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override

  addAdminUsers(WidgetRef ref,String uid){
    ref.read(adminUsersControllerProvider).addAdminUsers(uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        automaticallyImplyLeading: true,
        title: const Text(
          'Deleted Pending Users',
          style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white
          ),
        ),
        actions: const [
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer(
              builder: (context,ref,child) {
                return Expanded(
                  child:
                  ref.watch(deletedAdminUsersStreamProvider).when(data: (data){
                        return  ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: data.length,
                itemBuilder: (context, listViewIndex) {
                  return  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0xFFF5F5F5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                            data[listViewIndex].photo_url,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              data[listViewIndex].display_name,
                              style:
                              const TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              data[listViewIndex].email,
                              style:
                              const TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                           await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text('Do you want to add pending List ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // ref.watch(adminUsersControllerProvider).addAdminUsers(data[listViewIndex].uid);
                                        addAdminUsers(ref,data[listViewIndex].uid);
                                        showUploadMessage(context, 'Successfully Added');
                                        Navigator.pop(context);
                                        // Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ],
                                );
                              },
                            );

                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30,
                          ),
                          iconSize: 30,
                        )
                      ],
                    ),
                  );
                },
                          );
                        },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                    loading: () => const Loader(),
                  )
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

