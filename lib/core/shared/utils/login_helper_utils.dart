// import 'package:finoco/core/models/login_helper.dart';
// import 'package:finoco/core/repository/local_storage.dart';

// class LoginHelpUtils {
//   static Future<DateTime> checkForBlock(LogInHelper logInHelper) async {
//     int dif = logInHelper.lastLogin.difference(DateTime.now()).inHours.abs();
//     if (logInHelper.lastLogin == null || dif >= 24) {
//       logInHelper.blockUntil = null;
//       logInHelper.lastLogin = DateTime.now();
//       logInHelper.tentative = 1;
//     } else {
//       logInHelper.tentative++;
//       if (logInHelper.tentative == 4) {
//         logInHelper.blockUntil =
//             DateTime.now().add(const Duration(minutes: 10));
//       } else if (logInHelper.tentative == 5) {
//         logInHelper.blockUntil =
//             DateTime.now().add(const Duration(minutes: 20));
//       } else if (logInHelper.tentative == 6) {
//         logInHelper.blockUntil =
//             DateTime.now().add(const Duration(minutes: 40));
//       } else if (logInHelper.tentative == 7) {
//         logInHelper.blockUntil =
//             DateTime.now().add(const Duration(minutes: 60));
//       } else if (logInHelper.tentative >= 8) {
//         logInHelper.blockUntil =
//             DateTime.now().add(Duration(days: 1 + (logInHelper.tentative - 8)));
//       }
//     }
//     logInHelper.lastLogin = DateTime.now();

//     await LocalStorage.getInstance().setLastLogin(logInHelper);
//     return logInHelper.blockUntil;
//   }
// }
