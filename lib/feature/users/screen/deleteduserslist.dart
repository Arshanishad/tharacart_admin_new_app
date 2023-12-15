import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import 'package:tharacart_admin_new_app/feature/users/controller/users_controller.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../controller/deleteduser_controller.dart';
import 'deleteduserdetails.dart';

class DeletedUsersList extends ConsumerStatefulWidget {
  const DeletedUsersList({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _DeletedUsersListState();
}

class _DeletedUsersListState extends ConsumerState<DeletedUsersList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController mobile;

  @override
  void initState() {
    super.initState();
    getB2C();
    getB2B();
    mobile = TextEditingController();
  }



  getB2C(){
    ref.read(deletedUserControllerProvider).getB2C();
  }

  getB2B(){
    ref.read(deletedUserControllerProvider).getB2B();
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
          'Deleted Users List',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF1D2429),
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                      text: 'B2C',
                    ),
                    Tab(
                      text: 'B2B',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 4, 16, 0),
                            child: TextFormField(
                              controller: mobile,
                              obscureText: false,
                              onFieldSubmitted: (text) {
                                ref.watch(deletedb2cUserSearchProvider.notifier).update((state) => text.trim());
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
                                  suffixIcon:IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      mobile.clear();
                                      ref.watch(deletedb2cUserSearchProvider.notifier).update((state) => '');
                                      ref.watch(deletedb2bUserSearchProvider.notifier).update((state) => '');
                                    },
                                  )
                              ),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF1D2429),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 0, 0),
                                child: Text(
                                  'Total Users : ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 12, 16, 0),
                                child: Text(
                                  ref.watch(b2CcountProvider).toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                            return  ref.watch(deletedb2cuserStreamProvider(ref.watch(deletedb2cUserSearchProvider)))
                                  .when(
                                data: (data) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(8, 8, 8, 0),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (buildContext, int index) {
                                          String photoUrl = '';
                                          String fullName = '';
                                          String email = '';
                                          try {
                                            email = data[index].email;
                                            photoUrl =
                                                data[index].photoUrl;
                                            fullName =
                                                data[index].fullName;
                                          } catch (e) {
                                            photoUrl = '';
                                            fullName = '';
                                            email = '';
                                          }
                                          return Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 1),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DeletedUserDetails(
                                                  data1:data[index],
                                                )));
                                              },
                                              child: Container(
                                                width: 100,
                                                decoration:
                                                const BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 0,
                                                      color:
                                                      Color(0xFFE0E3E7),
                                                      offset: Offset(0, 1),
                                                    )
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8, 8, 8, 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(40),
                                                        child:
                                                        CachedNetworkImage(
                                                          imageUrl: photoUrl ==
                                                              ''
                                                              ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                              : photoUrl,
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                          MainAxisSize
                                                              .max,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  12,
                                                                  0,
                                                                  0,
                                                                  0),
                                                              child: Text(
                                                                fullName,
                                                                style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                  'Poppins',
                                                                  color: Color(
                                                                      0xFF1D2429),
                                                                  fontSize:
                                                                  14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  12,
                                                                  4,
                                                                  0,
                                                                  0),
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          4,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                      Text(
                                                                        email ??
                                                                            '',
                                                                        style:
                                                                        const TextStyle(
                                                                          fontFamily:
                                                                          'Poppins',
                                                                          color:
                                                                          Color(0xFF57636C),
                                                                          fontSize:
                                                                          11,
                                                                          fontWeight:
                                                                          FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  12,
                                                                  4,
                                                                  0,
                                                                  0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        4,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    child:
                                                                    Text(
                                                                      data[index].mobileNumber,
                                                                      style:
                                                                      const TextStyle(
                                                                        fontFamily:
                                                                        'Poppins',
                                                                        color:
                                                                        Color(0xFF57636C),
                                                                        fontSize:
                                                                        11,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color: const Color(
                                                            0xFFF1F4F8),
                                                        elevation: 1,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              40),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              4,
                                                              4,
                                                              4,
                                                              4),
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_right_rounded,
                                                            color: Color(
                                                                0xFF57636C),
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) => ErrorText(
                                  error: error.toString(),
                                ),
                                loading: () => const Loader(),
                              ); },
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 4, 16, 0),
                            child: TextFormField(
                              controller: mobile,
                              obscureText: false,
                              onFieldSubmitted: (text) {
                                ref.watch(b2bUsersSearchProvider.notifier).update((state) => text.trim());
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
                                  suffixIcon:IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      mobile.clear();
                                      ref.watch(deletedb2cUserSearchProvider.notifier).update((state) => '');
                                      ref.watch(deletedb2bUserSearchProvider.notifier).update((state) => '');
                                    },
                                  )
                              ),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF1D2429),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 0, 0),
                                child: Text(
                                  'Total Users : ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4, 12, 16, 0),
                                child: Text(
                                  ref.watch(b2BcountProvider).toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                             return ref.read(b2bdeleteuserStreamProvider(ref.read(deletedb2bUserSearchProvider)))
                                  .when(
                                data: (data) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(8, 8, 8, 0),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                        const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (buildContext, int index) {
                                          return Padding(
                                            padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 1),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DeletedUserDetails(
                                                  data1:data[index],
                                                )));
                                              },
                                              child: Container(
                                                width: 100,
                                                decoration:
                                                const BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 0,
                                                      color:
                                                      Color(0xFFE0E3E7),
                                                      offset: Offset(0, 1),
                                                    )
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      8, 8, 8, 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(40),
                                                        child:
                                                        CachedNetworkImage(
                                                          imageUrl: data[index].photoUrl
                                                              ==
                                                              ''
                                                              ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECommerce_Website_App_Online_Shop_Gradient_greenish_lineart_Modern_profile_photo_person_contact_account_buyer_seller-512.png'
                                                              : data[index].photoUrl,
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                          MainAxisSize
                                                              .max,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  12,
                                                                  0,
                                                                  0,
                                                                  0),
                                                              child: Text(
                                                                data[index].fullName,
                                                                style:
                                                                const TextStyle(
                                                                  fontFamily:
                                                                  'Poppins',
                                                                  color: Color(
                                                                      0xFF1D2429),
                                                                  fontSize:
                                                                  14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  12,
                                                                  4,
                                                                  0,
                                                                  0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        4,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    child:
                                                                    Text(
                                                                      data[index].email,
                                                                      style:
                                                                      const TextStyle(
                                                                        fontFamily:
                                                                        'Poppins',
                                                                        color:
                                                                        Color(0xFF57636C),
                                                                        fontSize:
                                                                        11,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  12,
                                                                  4,
                                                                  0,
                                                                  0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        4,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    child:
                                                                    Text(
                                                                      data[index].mobileNumber,
                                                                      style:
                                                                      const TextStyle(
                                                                        fontFamily:
                                                                        'Poppins',
                                                                        color:
                                                                        Color(0xFF57636C),
                                                                        fontSize:
                                                                        11,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color: const Color(
                                                            0xFFF1F4F8),
                                                        elevation: 1,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              40),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              4,
                                                              4,
                                                              4,
                                                              4),
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_right_rounded,
                                                            color: Color(
                                                                0xFF57636C),
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                               error: (error, stackTrace) => ErrorText(
                                 error: error.toString(),
                               ),
                               loading: () => const Loader(),
                             ); },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
