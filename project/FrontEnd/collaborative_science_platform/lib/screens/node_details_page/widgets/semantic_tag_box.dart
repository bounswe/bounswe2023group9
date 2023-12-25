// import 'package:collaborative_science_platform/extensions/string_extensions.dart';
// import 'package:collaborative_science_platform/models/semantic_tag.dart';
// import 'package:collaborative_science_platform/providers/node_provider.dart';
// import 'package:collaborative_science_platform/utils/colors.dart';
// import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
// import 'package:collaborative_science_platform/utils/text_styles.dart';
// import 'package:collaborative_science_platform/widgets/app_search_bar.dart';
// import 'package:collaborative_science_platform/widgets/card_container.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// class SemanticTagBox extends StatelessWidget {
//   final List<SemanticTag> semanticTags;
//   final ScrollController controller;
//   const SemanticTagBox({super.key, required this.semanticTags, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16),
//       child: Column(
//         children: [
//           const Text(
//             "Semantic Tags",
//             style: TextStyle(
//               color: AppColors.secondaryDarkColor,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(
//             width:
//                 Responsive.isDesktop(context) ? Responsive.desktopPageWidth / 4 : double.infinity,
//             //decoration: BoxDecoration(color: Colors.grey[200]),
//             child: ListView.builder(
//                 controller: controller,
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.all(8),
//                 itemCount: semanticTags.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return SemanticTagBox(semanticTags: semanticTags);
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }
