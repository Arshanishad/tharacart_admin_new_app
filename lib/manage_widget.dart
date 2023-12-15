
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tharacart_admin_new_app/core/theme/pallete.dart';
import 'feature/login/screen/splash_screen.dart';
import 'main.dart';

List groupNames=[];

class ManageWidget extends StatefulWidget {
  const ManageWidget({Key? key}) : super(key: key);

  @override
  _ManageWidgetState createState() => _ManageWidgetState();
}

class _ManageWidgetState extends State<ManageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getBranches();
    // TODO: implement initState
    super.initState();
  }

  getBranches() async {
    if ( currentBranchId == null ) {
      branches = await FirebaseFirestore.instance
          .collection('branches')
          .where('admins', arrayContains: currentUserEmail)
          .get();
      if (branches?.docs.length == 1) {
        setState(() {
          currentBranchId = branches?.docs[0].get('branchId');
          currentBranchName = branches?.docs[0].get('name');
        });
      }
      else {
        setState(() {
          branches=branches;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor:Pallete.primaryColor,
        automaticallyImplyLeading: true,
        title: const Text(
          'Manage',
          style:TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('V 6.3.2'),
          ),
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: branches == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : branches?.docs.length == 0
                ? const Center(
                    child: Text('No branches found for you'),
                  )
                : currentBranchId == null
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: branches?.docs.length,
                        itemBuilder: (context, listViewIndex) {
                          final branch = branches?.docs[listViewIndex];
                          return Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: const Color(0xFFF5F5F5),
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      currentBranchId = branch?.get('branchId');
                                      currentBranchName = branch?.get('name');
                                    });
                                  },
                                  child: Container(
                                    height: 100,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment: Alignment(0, -0.11),
                                          child: Text(
                                            branch?.get('name'),
                                             style:const TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Align(
                        alignment: const Alignment(0, 0),
                        child: GridView(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0,
                            childAspectRatio: 1,
                          ),
                          scrollDirection: Axis.vertical,
                          children: [
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ProductsWidget(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // await Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         ProductsWidget(),
                                      //   ),
                                      // );
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.productHunt,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80,
                                  ),
                                  const Text(
                                    'Products',
                                    style:TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => BrandsWidget(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // await Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => BrandsWidget(),
                                      //   ),
                                      // );
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.bold,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80,
                                  ),
                                  const Text(
                                    'Brands',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => CategoryWidget(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // await Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         CategoryWidget(),
                                      //   ),
                                      // );
                                    },
                                    icon: const Icon(
                                      Icons.category,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80,
                                  ),
                                  const Text(
                                    'Category',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => OfferWidget(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // await Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => OfferWidget(),
                                      //   ),
                                      // );
                                    },
                                    icon: Icon(
                                      Icons.local_offer,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80,
                                  ),
                                  const Text(
                                    'Offers',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => OfferWidget(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // await Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => BranchWidget(),
                                      //   ),
                                      // );
                                    },
                                    icon: const Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80,
                                  ),
                                  const Text(
                                    'Branches',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: ()  {
                                //  Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => BannerWidget(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.photo_library,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  },
                                  ),
                                  const Text(
                                    'Banners',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AddGroupWidget(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.group_add,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  }
                                    ,
                                  ),
                                  const Text(
                                    'Groups',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context
                                //   // MaterialPageRoute(
                                //   //   builder: (context) => SMTP(),
                                //   // ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.sms_outlined,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  }
                                    ,
                                  ),
                                  const Text(
                                    'SMTP',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Medal(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.leaderboard,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  }
                                    ,
                                  ),
                                  const Text(
                                    'Medal',
                                    style:TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AddMessage(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_alert,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  }
                                    ,
                                  ),
                                  const Text(
                                    'Running Message',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AddContact(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_call,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  },
                                  ),
                                  const Text(
                                    'Add Contact',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AddNotification(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.notification_add,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  },
                                  ),
                                  const Text(
                                    'Add Notification',
                                    style:TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AddAnnoucement(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.announcement,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  },
                                  ),
                                  const Text(
                                    'Add Announcement',
                                    style:TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => SurveyList(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.question_answer_rounded,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  },
                                  ),
                                  const Text(
                                    'Add Survey',
                                    style:TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ImageUpload(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.image_rounded,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  },
                                  ),
                                  const Text(
                                    'Image upload',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => PosUsers(),
                                //   ),
                                // );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.black,
                                      size: 80,
                                    ),
                                    iconSize: 80, onPressed: () {  },
                                  ),
                                  const Text(
                                    'Add PosUsers',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
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
