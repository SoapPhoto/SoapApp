import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../widget/soap_toast.dart';

void captureException(dynamic throwable, {dynamic stackTrace}) {
  if (throwable is OperationException) {
    if (throwable.linkException is NetworkException) {
      print('网络错误：${throwable.linkException}');
      // handle network issues, maybe
    } else {
      if (throwable.graphqlErrors.isNotEmpty) {
        if (throwable.graphqlErrors[0].message == 'Unauthorized') {
          SoapToast.error('没权限！');
        }
      }
      Sentry.captureException(throwable);
      print(throwable);
    }
  } else {
    Sentry.captureException(throwable);
    print(throwable);
  }
}
