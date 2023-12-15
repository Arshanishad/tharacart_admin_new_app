import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import 'package:tharacart_admin_new_app/feature/b2b_request/controller/b2b_request_controller.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import 'details_page_widget.dart';

class B2BRequestWidget extends ConsumerStatefulWidget {
  const B2BRequestWidget({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _B2BRequestWidgetState();
}

class _B2BRequestWidgetState extends ConsumerState<B2BRequestWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController number;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    number = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: const Text(
          'Request',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            const TabBar(
                labelColor: Pallete.primaryColor,
                indicatorColor: Pallete.secondaryColor,
                tabs: [
                  Tab(
                    text: 'Requests',
                  ),
                  Tab(
                    text: 'Approved',
                  ),
                ]),
            Expanded(
                child: TabBarView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 10),
                      child: TextFormField(
                        controller: number,
                        obscureText: false,
                        onFieldSubmitted: (text) {
                          ref
                              .watch(getPendingSearchProvider.notifier)
                              .update((state) => text.trim());
                        },
                        decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: 'Search officialNo',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF1F4F8),
                            prefixIcon: const Icon(
                              Icons.search_outlined,
                              color: Color(0xFF57636C),
                            ),
                            suffixIcon:
                              // ref.watch(getPendingSearchProvider).isNotEmpty
                              //       ?
                                IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                number.clear();
                              },
                            )
                             // : const SizedBox(),
                            ),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF1D2429),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    // number.text == ''
                    //     ?
                    Consumer(builder: (context, ref, child) {
                      return Expanded(
                          child: ref
                              .watch(
                                  getPendingB2BRequestsByNumberStreamProvider(
                                      ref.watch(getPendingSearchProvider)))
                              .when(
                                data: (data) {
                                  // return data.isEmpty
                                  //     ? const Center(
                                  //         child: Text('No Pending Request'))
                                  //     :
                              return    ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailsPageWidget(
                                                                  id: data[
                                                                          index]
                                                                      .userId.toString(),
                                                                )));
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFFC8CED5),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8, 0, 8, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  width: 60,
                                                                  height: 60,
                                                                  clipBehavior: Clip
                                                                      .antiAlias,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: data[index].imageUrl ==
                                                                            ''
                                                                        ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                        : data[index]
                                                                            .imageUrl.toString(),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    data[index]
                                                                        .userName.toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Lexend Deca',
                                                                      color: Color(
                                                                          0xFF15212B),
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          4,
                                                                          4,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .email.toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Lexend Deca',
                                                                          color:
                                                                              Color(0xFF4B39EF),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          4,
                                                                          4,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .officialNo.toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Lexend Deca',
                                                                          color:
                                                                              Color(0xFF4B39EF),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      0, 8, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: Color(
                                                                    0xFF82878C),
                                                                size: 24,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                },
                                error: (error, stackTrace) => ErrorText(
                                  error: error.toString(),
                                ),
                                loading: () => const Loader(),
                              ));
                    }),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 10),
                      child: TextFormField(
                        controller: number,
                        obscureText: false,
                        onFieldSubmitted: (text) {
                          ref
                              .watch(approvedB2bRequestsSearchProvider.notifier)
                              .update((state) => text.trim());
                        },
                        decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: 'Search Users',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF1F4F8),
                            prefixIcon: const Icon(
                              Icons.search_outlined,
                              color: Color(0xFF57636C),
                            ),
                            suffixIcon:
                                // number != null && number.text.isNotEmpty
                                //     ?
                                IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                number.clear();
                                ref
                                    .watch(approvedB2bRequestsSearchProvider
                                        .notifier)
                                    .update((state) => '');
                              },
                            )
                            // : null,
                            ),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF1D2429),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return Expanded(
                          child: ref
                              .watch(getApprovedRequestsByNumberStreamProvider(
                                  ref.watch(approvedB2bRequestsSearchProvider)))
                              .when(
                                data: (data) {
                                  // return data.length == 0
                                  //     ? Center(child: Text('No Approved Users'))
                                  //     :
                               return    ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailsPageWidget(
                                                                  id: data[
                                                                          index]
                                                                      .userId.toString(),
                                                                )));
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFFC8CED5),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8, 0, 8, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  width: 60,
                                                                  height: 60,
                                                                  clipBehavior: Clip
                                                                      .antiAlias,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: data[index].imageUrl ==
                                                                            ''
                                                                        ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                                        : data[index]
                                                                            .imageUrl.toString(),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      data[index]
                                                                          .userName.toString(),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Lexend Deca',
                                                                        color: Color(
                                                                            0xFF15212B),
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          4,
                                                                          4,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .email.toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Lexend Deca',
                                                                          color:
                                                                              Color(0xFF4B39EF),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          4,
                                                                          4,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .officialNo.toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Lexend Deca',
                                                                          color:
                                                                              Color(0xFF4B39EF),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      0, 8, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: Color(
                                                                    0xFF82878C),
                                                                size: 24,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                },
                                error: (error, stackTrace) => ErrorText(
                                  error: error.toString(),
                                ),
                                loading: () => const Loader(),
                              ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
