import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tharacart_admin_new_app/core/constants/firebase_constants.dart';
import 'package:tharacart_admin_new_app/feature/b2b_request/screen/zoom.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/common/Upload_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../controller/b2b_request_controller.dart';

class DetailsPageWidget extends ConsumerStatefulWidget {
  final String id;
  const DetailsPageWidget({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState createState() => _DetailsPageWidgetState();
}

class _DetailsPageWidgetState extends ConsumerState<DetailsPageWidget> {
  bool? safeExtension;
  bool? ebextension;
  bool? safeMcc;
  bool? ebmcc;
  bool load = false;
  String? safeZone;
  String? ebZone;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<void> _launche;

  List<String> zones = ['Select Zone'];
  List<String> zones1 = ['Select Zone'];
  List pinCode = [];

  var zone;

  // Future getZone()async{
  //   DocumentSnapshot snapshot=await FirebaseFirestore.instance
  //       .collection('safeExpress')
  //       .doc('safeExpress')
  //       .get();
  //   safeZone="A";
  //   for(var abc in snapshot.get('zonePrice')){
  //     zones.add(abc['name']);
  //   }
  //   if(mounted){
  //     setState(() {
  //       safeZone='Select Zone';
  //
  //     });
  //   }
  //
  //
  //
  // }

  getZone() {
    ref.read(b2bRequestControllerProvider).getZone();
  }

  getZone1() {
    ref.read(b2bRequestControllerProvider).getZone1();
  }




  updateStatus() {
    ref.read(b2bRequestControllerProvider).updateStatus(widget.id);
  }

  Future<void> updateB2BRequest(
      {required String safeMcc,
      required String ebmcc,
      required String safeExtension,
      required String ebextension,
      required String safeZone,
      required String ebZone}) {
    return ref.read(b2bRequestControllerProvider).updateB2BRequest(
        safeMcc: safeMcc,
        ebmcc: ebmcc,
        safeExtension: safeExtension,
        ebextension: ebextension,
        safeZone: safeZone,
        ebZone: ebZone);
  }

  // Future getZone1()async{
  //   DocumentSnapshot snapshot=await FirebaseFirestore.instance
  //       .collection('expressB')
  //       .doc('expressB')
  //       .get();
  //
  //   ebZone="A";
  //   for(var abc in snapshot.get('zonePrice')){
  //     zones1.add(abc['name']);
  //
  //   }
  //   if(mounted){
  //     setState(() {
  //       ebZone='Select Zone';
  //
  //     });
  //   }
  //
  //
  //
  // }

  Future<void> _makeCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not call$url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getZone();
    getZone1();
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
            'Details',
            style: TextStyle(
              fontFamily: 'Lexend Deca',
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 1,
        ),
        backgroundColor: Colors.white,
        body: Consumer(
          builder: (context, ref, child) {
            return ref.watch(getB2bRequestStreamProvider(widget.id)).when(
                  data: (data) {
                    var taxPayerInfo = data.taxpayerInfo;
                    var pAddress = taxPayerInfo?['pradr'];
                    var address = pAddress['addr'];
                    var passOrAadhar = data.pANumber.toString();
                    var tradeName = taxPayerInfo?['tradeNam'];
                    String panNo = taxPayerInfo?['panNo'];
                    String stj = taxPayerInfo?['stj'];
                    String stjCd = taxPayerInfo?['stjCd'];
                    String rgdt = taxPayerInfo?['rgdt'];
                    String status = taxPayerInfo?['sts'];
                    var frontView = data.idFront;
                    var backView = data.idBack;
                    var ctb = taxPayerInfo?['ctb'];
                    var ctj = taxPayerInfo?['ctj'];
                    var ctjCd = taxPayerInfo?['ctjCd'];
                    var cxdt = taxPayerInfo?['cxdt'];
                    var dty = taxPayerInfo?['dty'];
                    var ignm = taxPayerInfo?['lgnm'];
                    var lstupdt = taxPayerInfo?['lstupdt'];

                    print(data);
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 20, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    data.userName.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  height: 120,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: data.imageUrl == ''
                                        ? 'https://cdn1.iconfinder.com/data/icons/ecommerce-gradient/512/ECo'
                                            'mmerce_Website_App_Online_Shop_Gradient_greenish_lineart_Mod'
                                            'ern_profile_photo_person_contact_account_buyer_seller-512.png'
                                        : data.imageUrl.toString(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 20, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Phone : ${data.officialNo}',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _launche =
                                        _makeCall('tel:${data.officialNo}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF00B423),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Container(
                                    width: 130,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Call',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 20, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    data.email.toString() ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 20, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Passport/Aadhar Number: ${passOrAadhar ?? ''}',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Trade Name: ${tradeName ?? ''}',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Pan No: ${panNo ?? ''}',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    stj ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    stjCd,
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'RDate: $rgdt',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Status: $status',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Passport / Aadhar',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          frontView == "" && data.idBack == ""
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return Zoom(
                                              image: data.idFront.toString(),
                                            );
                                          }));
                                        },
                                        child: Container(
                                          width: 180,
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  data.idFront.toString()),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return Zoom(
                                              image: data.idBack.toString(),
                                            );
                                          }));
                                        },
                                        child: Container(
                                          width: 180,
                                          child: CachedNetworkImage(
                                            imageUrl: data.idBack.toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Tax Payer Info',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'GSTIN : ${taxPayerInfo?['gstin']}',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['ctb'],
                                    ctb,
                                    // taxPayerInfo?['ctb'],
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['ctj'],
                                    // taxPayerInfo?['ctj'],
                                    ctj,
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['ctjCd'],
                                    // taxPayerInfo?['cjCd'],
                                    ctjCd,
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['dty'],
                                    // taxPayerInfo?['dty'],
                                    dty,
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['lgnm'],
                                    // taxPayerInfo?['lgnm'],
                                    ignm,
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['lstupdt'],
                                    // taxPayerInfo?['lstupdt'],
                                    lstupdt,
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Permanent Address',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // address['bnm'],
                                    // data.taxpayerInfo?['pradr']['addr']['bnm'],
                                    address['bnm'],
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['pradr']['addr']['bno'],
                                    address['bno'],
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          address['city'] != ''
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 3, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          // data.taxpayerInfo?['pradr']['addr']['city'],
                                          address['city'],
                                          style: const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF8B97A2),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['pradr']['addr']['dst'],
                                    address['dst'],
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          address['flno'] != ''
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 3, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          address['flno'],
                                          style: const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF8B97A2),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    'Pincode : ${address['pncd']}',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    // data.taxpayerInfo?['pradr']['addr']['st'],
                                    address['st'],
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 3, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    address['stcd'],
                                    style: const TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF8B97A2),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        'Zone',
                                        style: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Consumer(builder: (context, ref, child) {
                                  var data = ref.watch(getZoneListProvider);
                                  return data.when(
                                    data: (data) {
                                      print("dataaa");
                                      print(data);
                                      print("dataaa");
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButton(
                                              value: safeZone,
                                              onChanged: (val) => setState(
                                                  () => safeZone = val!),
                                              items: data.map((zone) {
                                                return DropdownMenuItem(
                                                  value: zone,
                                                  child: Text(
                                                    zone,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              isExpanded: true,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                              ),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    error: (error, stackTrace) {
                                      print(error);
                                      return const SizedBox();
                                    },
                                    loading: () {
                                      return const SizedBox();
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'EB Zone',
                                        style: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Consumer(builder: (context, ref, child) {
                                  var data = ref.watch(getZone1ListProvider);
                                  return data.when(
                                    data: (data) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButton(
                                              value: safeZone,
                                              onChanged: (val) => ref
                                                  .watch(
                                                      safeZoneProvider.notifier)
                                                  .update((state) => val),
                                              // setState(() => safeZone = val!),
                                              items: data.map((zone) {
                                                return DropdownMenuItem(
                                                  value: zone,
                                                  child: Text(
                                                    zone,
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              isExpanded: true,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                              ),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    error: (error, stackTrace) {
                                      print(error);
                                      return const SizedBox();
                                    },
                                    loading: () {
                                      return const SizedBox();
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SwitchListTile.adaptive(
                                value: safeExtension ?? false,
                                onChanged: (newValue) =>
                                    setState(() => safeExtension = newValue),
                                title: const Text(
                                  'Extension',
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                activeColor: const Color(0xFF4B39EF),
                                activeTrackColor: const Color(0xFF3B2DB6),
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        24, 12, 24, 12),
                              ),
                              SwitchListTile.adaptive(
                                value: ebextension ?? false,
                                onChanged: (newValue) =>
                                    setState(() => ebextension = newValue),
                                title: const Text(
                                  'EB Extension',
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                activeColor: const Color(0xFF4B39EF),
                                activeTrackColor: const Color(0xFF3B2DB6),
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        24, 12, 24, 12),
                              ),
                              SwitchListTile.adaptive(
                                value: safeMcc ??= true,
                                onChanged: (newValue) =>
                                    setState(() => safeMcc = newValue),
                                title: const Text(
                                  'MCC',
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                activeColor: const Color(0xFF4B39EF),
                                activeTrackColor: const Color(0xFF3B2DB6),
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        24, 12, 24, 12),
                              ),
                              SwitchListTile.adaptive(
                                value: ebmcc ??= true,
                                onChanged: (newValue) =>
                                    setState(() => ebmcc = newValue),
                                title: const Text(
                                  'EB MCC',
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                activeColor: const Color(0xFF4B39EF),
                                activeTrackColor: const Color(0xFF3B2DB6),
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        24, 12, 24, 12),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 24, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (alertDialogContext) {
                                            return AlertDialog(
                                              title: const Text('Reject'),
                                              content: const Text(
                                                  'Do you want to Reject'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          alertDialogContext),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    // snapshot.data?.reference.update({
                                                    //   'status': 2,
                                                    // });
                                                    updateStatus();

                                                    Navigator.pop(
                                                        alertDialogContext);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Confirm'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFFC20000),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Container(
                                        width: 170,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 24, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (safeZone != 'Select Zone' &&
                                            ebZone != 'Select Zone') {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: const Text('Confirm'),
                                                content: const Text(
                                                    'Do you want to Approve'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      // snapshot.data?.reference
                                                      // FirebaseFirestore.instance
                                                      //     .collection(
                                                      //         FirebaseConstants
                                                      //             .b2bRequestsCollection)
                                                      //     .doc()
                                                      //     .update({
                                                      //   'status': 1,
                                                      //   'mcc': safeMcc,
                                                      //   'ebMcc': ebmcc,
                                                      //   'extension':
                                                      //       safeExtension,
                                                      //   'ebExtension':
                                                      //       ebextension,
                                                      //   'zone': safeZone,
                                                      //   'ebZone': ebZone,
                                                      // });
                                                      updateStatus();

                                                      FirebaseFirestore.instance.collection('users').doc(widget.id).update({
                                                        'b2b': true,
                                                        'zone': safeZone,
                                                        'ebZone': ebZone,
                                                        'officialNo': data.officialNo,
                                                        'ext': safeExtension,
                                                        'ebExtension': ebextension,
                                                        'gst': data.taxpayerInfo?['gstin'],
                                                        'mcc': safeMcc,
                                                        'ebMcc': ebmcc,
                                                      });

                                                      Navigator.pop(
                                                          alertDialogContext);
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text('Confirm'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showUploadMessage(
                                              context, 'Please Choose Zone');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFF4B39EF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Container(
                                        width: 170,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Approve',
                                          style: TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                );
          },
        ));
  }
}
