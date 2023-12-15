// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tharacart_admin_new_app/home/screen/home_page_widget.dart';
// import 'package:tharacart_admin_new_app/manage_widget.dart';
// import 'feature/login/screen/splash_screen.dart';
// final bottomNavProvider = StateProvider<int>((ref) => 0);
// class NavBarPage extends ConsumerStatefulWidget {
//   const NavBarPage({super.key});
//   @override
//   ConsumerState<NavBarPage> createState() => _NavBarPageState();
// }
// final pageProvider = StateProvider<List>((ref) => [
//       const HomePageWidget(),
//       const ManageWidget(),
//     ]);
// final bottomIconProvider =
//     StateProvider<List<BottomNavigationBarItem>>((ref) => [
//           const BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
//           const BottomNavigationBarItem(
//               label: "Upload",
//               icon: Icon(
//                 Icons.upload,
//               )),
//         ]);
// class _NavBarPageState extends ConsumerState<NavBarPage> {
//   void onTap(int index) {
//     ref.read(bottomNavProvider.notifier).update((state) => index);
//   }
//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//
//     int currentintex = ref.watch(bottomNavProvider);
//     final Pages = ref.watch(pageProvider);
//     return Scaffold(
//       body: Pages[currentintex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color(0xFF1E2674),
//         currentIndex: currentintex,
//         showSelectedLabels: true,
//         selectedItemColor: const Color(0xFF498826),
//         unselectedItemColor: const Color(0x8A000000),
//         showUnselectedLabels: false,
//         onTap: onTap,
//         elevation: 2,
//         items: ref.watch(bottomIconProvider),
//       ),
//     );
//   }
// }
