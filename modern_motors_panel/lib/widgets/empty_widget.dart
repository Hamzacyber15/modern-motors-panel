// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:app/app_theme.dart';

// class EmptyWidget extends StatelessWidget {
//   final String text;
//   const EmptyWidget({required this.text, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.hourglass_empty,
//             size: 52,
//             color: AppTheme.redColor,
//           ),
//           Text(
//             text.tr(),
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modern_motors_panel/app_theme.dart';

class EmptyWidget extends StatelessWidget {
  final String text;

  const EmptyWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Lottie.asset(
              'assets/images/nodata.json',
              repeat: true,
              reverse: false,
              animate: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text.tr(),
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.greyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
