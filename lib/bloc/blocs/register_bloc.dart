import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:structure_flutter/bloc/events/register_event.dart';
import 'package:structure_flutter/bloc/states/register_state.dart';
import 'package:structure_flutter/di/injection.dart';
import 'package:structure_flutter/repositories/account_repository.dart';
import 'package:structure_flutter/repositories/storage_repository.dart';
import 'package:structure_flutter/repositories/user_repository.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _userRepository = getIt<UserRepository>();

  final _accountRepository = getIt<AccountRepository>();

  final _storageRepository = getIt<StorageRepository>();

  RegisterBloc(RegisterState initialState) : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterWithCredentials) {
      yield* _mapRegisterAccountToState(
        email: event.email.trim(),
        password: event.password.trim(),
        name: event.fullName.trim(),
        imageURL: event.imageURL,
      );
    }
  }

  Stream<RegisterState> _mapRegisterAccountToState({
    @required String email,
    @required String password,
    @required String name,
    File imageURL,
  }) async* {
    yield RegisterState.loading();
    try {
      final String uid = await _userRepository.signUp(email, password);
      var result = _storageRepository.uploadUserImage(uid, imageURL);
      var _imageURL = await (await result).ref.getDownloadURL();
      await _userRepository.updateUserInfo(name, _imageURL);
      await _accountRepository.createUser(uid, name, email, _imageURL);
      yield RegisterState.success();
    } catch (e) {
      yield RegisterState.failure();
    }
  }
}
