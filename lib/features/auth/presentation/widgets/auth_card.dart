import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../products/presentaion/pages/products_page.dart';
import '../../../../providers/current_user.dart';

// import 'package:provider/provider.dart';
// import '../../../../providers/current_user.dart';

import '../../../../core/shared_widgets/error_dialog.dart';
import '../../../../core/strings/constatnts.dart';
import '../../../../core/util/snackbar_message.dart';
import '../bloc/auth_bloc.dart';
import 'auth_form.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    bool isLoading = false;
    AuthMode authMode = AuthMode.Login;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ErrorAuthState) {
          isLoading = false;
          showErrorDialog(context, state.errorMessage);
        } else if (state is SuccessAuthState) {
          isLoading = false;
          sl<CurrentUser>().setCurrentUser(
              authToken: state.user.authToken,
              userId: state.user.userId,
              expiryDate: state.user.expiryDate);
          SnackBarMessage().showSuccessSnackBar(
              message: "Success :You Are Authenticated", context: context);
          Navigator.of(context).pushReplacementNamed(ProductsPage.routeName);
        }
      },
      builder: (context, state) {
        if (state is LoadinAuthgState) {
          isLoading = true;
        }
        return authCardContainer(
            height: authMode == AuthMode.Signup ? 320 : 260,
            size: deviceSize.width * 0.75,
            child: FromWidget(authMode: authMode, isLoading: isLoading));
      },
    );
  }
}

Widget authCardContainer(
    {required Widget child, required double height, required double size}) {
  return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: height,
        constraints: BoxConstraints(minHeight: height),
        width: size,
        padding: const EdgeInsets.all(16.0),
        child: child,
      ));
}
