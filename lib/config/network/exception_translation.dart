import 'package:finoco/config/network/response_code.dart';
import 'package:flutter/material.dart';

class ExceptionTranslation extends StatelessWidget {
  final int _code;
  final int _number;
  final int _nb_visits;
  final int _nb_reschedule;
  ExceptionTranslation(
      {Key key,
      @required int code,
      int number,
      int nb_visits,
      int nb_reschedule})
      : _code = code,
        _number = number,
        _nb_visits = nb_visits,
        _nb_reschedule = nb_reschedule,
        super(key: key);

  String _getMessage(code) {
    switch (code) {
      case ResponseCode.AccountAlreadyExist:
        return "accoutExistsError";
      case ResponseCode.BadRequest:
        return "subscriptionError";
      case ResponseCode.Unauthorised:
        return "unauthorisedError";
      case ResponseCode.AccountNotActive:
        return "accoutNotActivatedError";
      case ResponseCode.ChangeAccountPassword:
        return "passwordChangeNeeded";
      case ResponseCode.AccountNotFound1:
        return "accountNotFound";
      case ResponseCode.WrongVerificationCode:
        return "wrongVerificationCode";
      case ResponseCode.WrongPassCode:
        return "wrongVerificationCode";
      case ResponseCode.InternalServerError:
        return "internalServerError";
      case ResponseCode.NoInternetFound:
        return "noInternetError";

      case ResponseCode.NoEmployee:
        return "noEmployee";
      case ResponseCode.AccountNotFoundLogin:
        return "userNotFound";
      case ResponseCode.WrongPassword:
        return 'wrongCredential';
      case ResponseCode.AccountLockedLogin:
        return "accountLocked";
      default:
        return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      _getMessage(_code),
      style: const TextStyle(fontFamily: "DroidArabicKufi", fontSize: 14),
    );
  }
}
