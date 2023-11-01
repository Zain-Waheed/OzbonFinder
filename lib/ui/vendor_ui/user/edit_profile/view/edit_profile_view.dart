import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/config/ps_config.dart';

import '../../../../../core/vendor/api/common/ps_resource.dart';
import '../../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../../core/vendor/provider/language/app_localization_provider.dart';
import '../../../../../core/vendor/provider/user/user_provider.dart';
import '../../../../../core/vendor/repository/user_repository.dart';
import '../../../../../core/vendor/utils/ps_progress_dialog.dart';
import '../../../../../core/vendor/utils/utils.dart';
import '../../../../../core/vendor/viewobject/common/ps_value_holder.dart';
import '../../../../../core/vendor/viewobject/holder/profile_update_view_holder.dart';
import '../../../../../core/vendor/viewobject/user.dart';
import '../../../../../core/vendor/viewobject/user_relation.dart';
import '../../../../custom_ui/user/edit_profile/component/profile/email_checkbox.dart';
import '../../../../custom_ui/user/edit_profile/component/profile/phone_no_checkbox.dart';
import '../../../../custom_ui/user/edit_profile/component/profile/phone_no_widget.dart';
import '../../../../custom_ui/user/edit_profile/component/profile/profile_image_widget.dart';
import '../../../common/base/ps_widget_with_appbar.dart';
import '../../../common/dialog/error_dialog.dart';
import '../../../common/dialog/success_dialog.dart';
import '../../../common/ps_textfield_widget.dart';
import '../../../common/ps_ui_widget.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository? userRepository;
  UserProvider? userProvider;
  PsValueHolder? psValueHolder;
  late AnimationController animationController;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool bindDataFirstTime = true;
  late AppLocalization langProvider;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    langProvider = Provider.of<AppLocalization>(context);

    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<UserProvider>(
            appBarTitle: 'edit_profile__title'.tr,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () async {
                    onTapSave(context, userProvider!);
                  },
                  child: Text(
                    'edit_profile__save'.tr,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
            initProvider: () {
              return UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
            },
            onProviderReady: (UserProvider provider) async {
              await provider.getUser(provider.psValueHolder!.loginUserId,
                  langProvider.currentLocale.languageCode);
              userProvider = provider;
              return provider;
            },
            builder: (BuildContext context, UserProvider userProvider,
                Widget? child) {
              if (userProvider.user.data != null) {
                if (bindDataFirstTime) {
                  userNameController.text = userProvider.user.data!.name!;
                  emailController.text = userProvider.user.data!.userEmail!;
                  addressController.text = userProvider.user.data!.userAddress!;
                  if (userProvider.user.data!.hasPhone)
                    phoneController.text = '(' +
                        userProvider.user.data!.userPhone!
                            .replaceFirst(RegExp(r'-'), ')');
                  aboutMeController.text = userProvider.user.data!.userAboutMe!;

                  bindDataFirstTime = false;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const CustomImageWidget(),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      PsTextFieldWidget(
                          titleText: 'edit_profile__user_name'.tr,
                          hintText: 'edit_profile__user_name'.tr,
                          textAboutMe: false,
                          textEditingController: userNameController),
                      PsTextFieldWidget(
                          titleText: 'edit_profile__email'.tr,
                          hintText: 'edit_profile__email'.tr,
                          keyboardType: TextInputType.emailAddress,
                          textAboutMe: false,
                          textEditingController: emailController),
                      CustomPhoneNoWidget(phoneController: phoneController),
                      PsTextFieldWidget(
                          titleText: 'edit_profile__about_me'.tr,
                          height: PsDimens.space120,
                          keyboardType: TextInputType.multiline,
                          textAboutMe: true,
                          hintText: 'edit_profile__about_me'.tr,
                          textEditingController: aboutMeController),
                      const SizedBox(
                        height: 2,
                      ),
                      CustomEmailCheckboxWidget(),
                      const SizedBox(
                        height: PsDimens.space18,
                      ),
                      CustomPhoneNoCheckboxWidget(),
                      const SizedBox(
                        height: PsDimens.space64,
                      ),
                    ],
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    const SizedBox(),
                    PSProgressIndicator(userProvider.user.status)
                  ],
                );
              }
            }));
  }

  dynamic onTapSave(BuildContext context, UserProvider provider) async {
    if (userNameController.text == '') {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: 'edit_profile__name_error'.tr,
            );
          });
    } else if (emailController.text == '') {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: 'edit_profile__email_error'.tr,
            );
          });
    } else {
      if (await Utils.checkInternetConnectivity()) {
        String purePhoneNum = phoneController.text.replaceFirst(')', '-');
        purePhoneNum = purePhoneNum.replaceFirst('(', '');
        final ProfileUpdateParameterHolder profileUpdateParameterHolder =
            ProfileUpdateParameterHolder(
          userId: provider.user.data!.userId,
          userName: userNameController.text,
          userEmail: emailController.text.trim(),
          userPhone: purePhoneNum,
          userAboutMe: aboutMeController.text,
          isShowEmail: provider.user.data!.isShowEmail,
          isShowPhone: provider.user.data!.isShowPhone,
          userRelation: <UserRelation>[], // to modify later
        );
        await PsProgressDialog.showDialog(context);
        final PsResource<User> _apiStatus = await provider.postProfileUpdate(
            profileUpdateParameterHolder.toMap(),
            psValueHolder!.loginUserId!,
            langProvider.currentLocale.languageCode);
        if (_apiStatus.data != null) {
          PsProgressDialog.dismissDialog();
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext contet) {
                return SuccessDialog(
                  message: 'edit_profile__success'.tr,
                  onPressed: () {},
                );
              });
        } else {
          PsProgressDialog.dismissDialog();

          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: 'error_dialog__no_internet'.tr,
              );
            });
      }
    }
  }
}
