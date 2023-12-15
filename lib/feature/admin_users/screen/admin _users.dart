import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import 'package:tharacart_admin_new_app/feature/admin_users/controller/admin_users_controller.dart';
import '../../../core/common/upload_message.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import 'deleted_users.dart';

class AdminUsersWidget extends ConsumerWidget {
  AdminUsersWidget({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override

  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        automaticallyImplyLeading: true,
        title: const Text(
          'Admin Users',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeletedPendingUsers()));
              },
              icon: const Icon(Icons.delete))
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              const TabBar(
                labelColor: Pallete.primaryColor,
                indicatorColor: Pallete.secondaryColor,
                tabs: [
                  Tab(
                    text: 'Approved Users',
                  ),
                  Tab(
                    text: 'Pending Users',
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ref.watch(approvedAdminUsersStreamProvider).when(
                      data: (data) {
                        return data == null || data.isEmpty
                            ? const Center(child: Text('No Approved Users'))
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: data.length,
                                itemBuilder: (context, listViewIndex) {
                                  return InkWell(
                                    onLongPress: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirmation'),
                                            content: const Text(
                                                'Do you want to delete this user?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  ref
                                                    .read(adminUsersControllerProvider)
                                                    .deleteUser(
                                                    data[listViewIndex].uid);
                                                showUploadMessage(
                                                    context, 'Deleted...');
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
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
                                              imageUrl: data[listViewIndex]
                                                  .photo_url,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                data[listViewIndex]
                                                    .display_name,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  data[listViewIndex]
                                                      .email,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              ref
                                                  .read(
                                                      adminUsersControllerProvider)
                                                  .removeAdminUserAndBranch(
                                                      data[listViewIndex]
                                                          .email);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            iconSize: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    ),

                    Consumer(
                      builder: (context, ref, child) {
                       return ref.watch(pendingAdminUsersStreamProvider).when(
                          data: (data) {
                            return data == null || data.isEmpty
                                ? const Center(child: Text('No Pending Users'))
                                : ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: (context, listViewIndex) {
                                return InkWell(
                                  onLongPress: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirmation'),
                                          content: const Text(
                                              'Do you want to delete this user?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ref
                                                  .read(adminUsersControllerProvider)
                                                  .deleteUser(
                                                  data[listViewIndex].uid);
                                              showUploadMessage(
                                                  context, 'Deleted...');
                                                Navigator.of(context).pop(
                                                    true);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Card(
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
                                            imageUrl: data[listViewIndex]
                                                .photo_url,
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              data[listViewIndex]
                                                  .display_name,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.6,
                                              child: Text(
                                                data[listViewIndex]
                                                    .email,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            ref
                                                .read(
                                                adminUsersControllerProvider)
                                                .removeAdminUserAndBranch(
                                                data[listViewIndex]
                                                    .email);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                          iconSize: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        ); },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                       return ref.watch(unverifiedAdminUsersStreamProvider).when(data: (data) {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, listViewIndex) {
                              return data.length == 0
                                  ? const Center(child: Text('No Pending Users'))
                                  : InkWell(
                                onLongPress: () async {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Do you want to delete this user?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(false);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () { ref
                                                .read(adminUsersControllerProvider)
                                                .deleteUser(data[listViewIndex].uid);
                                            showUploadMessage(context, 'Deleted...');
                                              // Navigator.of(context).pop(
                                              //     true);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Card(
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
                                          imageUrl: data[listViewIndex]
                                              .photo_url,
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            data[listViewIndex]
                                                .display_name,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          Text(
                                            data[listViewIndex].email,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          ref
                                              .read(
                                              adminUsersControllerProvider)
                                              .removeAdminUserAndBranch(
                                              data[listViewIndex]
                                                  .email);
                                        },
                                        icon: const Icon(
                                          Icons.verified,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                        iconSize: 30,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                            error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                            ),
                          loading: () => const Loader(),
                        );},
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
