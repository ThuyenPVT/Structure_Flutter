import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:structure_flutter/bloc/bloc.dart';
import 'package:structure_flutter/bloc/blocs/authentication_bloc.dart';
import 'package:structure_flutter/core/resource/app_colors.dart';
import 'package:structure_flutter/core/resource/text_style.dart';
import 'package:structure_flutter/di/injection.dart';
import 'widgets/avatar.dart';
import 'widgets/birthday_date_picker.dart';
import 'widgets/gender_radio.dart';
import 'widgets/language_dropdown.dart';

class SettingPage extends StatefulWidget {
  final User user;

  SettingPage(this.user);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
  User get user => widget.user;

  final _authenticationBloc = getIt<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.outer_space,
        title: Text(
          'Cài đặt',
          style: AppStyles.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _authenticationBloc.add(LoggedOut());
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Avatar(user),
          Container(
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.topLeft,
            child: Text('SETTING'),
          ),
          LanguageDropdown(),
          GenderRadio(),
          BirthdayDatePicker(),
        ],
      ),
    );
  }
}
