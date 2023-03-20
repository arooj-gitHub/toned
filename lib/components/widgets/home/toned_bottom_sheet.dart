// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:provider/provider.dart';
// import '/providers/home_provider.dart';

// import '../chat_components/media_list.dart';

// void showProgramTray(context) {
//   showCupertinoModalBottomSheet(
//     context: context,
//     builder: (context) => Consumer<HomeProvider>(
//       builder: (context, provider, child) {
//         return SafeArea(
//           child: CupertinoPageScaffold(
//             navigationBar: const CupertinoNavigationBar(
//               backgroundColor: Colors.transparent,
//               automaticallyImplyLeading: false,
//               middle: Text("SELECT PROGRAM"),
//             ),
//             child: Material(
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 height: MediaQuery.of(context).size.height * 0.28,
//                 alignment: Alignment.center,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.separated(
//                           shrinkWrap: true,
//                           itemCount: provider.groupProgramExercise!.programsList!.length,
//                           // ignore: avoid_types_as_parameter_names
//                           separatorBuilder: (context, int) {
//                             return const Divider();
//                           },
//                           itemBuilder: (context, index) {
//                             return SizedBox(
//                               height: 30,
//                               child: ListTile(
//                                 onTap: () {
//                                   provider.changeSelectedProgram(index);
//                                   Navigator.of(context).pop();
//                                 },
//                                 title: Center(
//                                   child: Text(
//                                     provider.groupProgramExercise!.programsList![index].title,
//                                     style: const TextStyle(fontSize: 18),
//                                   ),
//                                 ),
//                                 dense: true,
//                               ),
//                             );
//                           },),
//                     ),
//                     const Divider(),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           CupertinoIcons.question_circle_fill,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           "Which program is for me ?",
//                           style: TextStyle(color: Colors.grey.shade400),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }

// chatTray(context) {
//   showModalBottomSheet(
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(20),
//       ),
//     ),
//     clipBehavior: Clip.antiAliasWithSaveLayer,
//     context: context,
//     backgroundColor: Colors.grey.shade100,
//     builder: (context) {
//       return Container(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 10),
//             const Center(
//               child: Text(
//                 'Media',
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 MediaListItem(iconData: Icons.camera_alt_rounded,
//                     title: 'Camera',
//                     func: () {}),
//                 MediaListItem(iconData: Icons.perm_media_rounded,
//                     title: 'Gallery',
//                     func: () {}),
//                 MediaListItem(iconData: Icons.insert_drive_file_rounded,
//                     title: 'File',
//                     func: () {}),
//                 MediaListItem(
//                     iconData: CupertinoIcons.money_dollar_circle_fill,
//                     title: 'Offer',
//                     func: () {}),
//               ],
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       );
//     },
//   );
// }
