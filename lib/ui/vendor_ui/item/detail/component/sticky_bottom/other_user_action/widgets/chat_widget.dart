import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../PaymentMethods/components/subscription_diloagbox.dart';
import '../../../../../../../../config/route/route_paths.dart';
import '../../../../../../../../core/vendor/constant/ps_constants.dart';
import '../../../../../../../../core/vendor/provider/chat/get_chat_history_provider.dart';
import '../../../../../../../../core/vendor/provider/language/app_localization_provider.dart';
import '../../../../../../../../core/vendor/provider/product/item_entry_provider.dart';
import '../../../../../../../../core/vendor/provider/product/product_provider.dart';
import '../../../../../../../../core/vendor/utils/utils.dart';
import '../../../../../../../../core/vendor/viewobject/common/ps_value_holder.dart';
import '../../../../../../../../core/vendor/viewobject/custom_field.dart';
import '../../../../../../../../core/vendor/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import '../../../../../../../../core/vendor/viewobject/selected_object.dart';
import '../../../../../../common/dialog/warning_dialog_view.dart';
import '../../../../../../common/ps_button_widget.dart';
import 'dart:developer';

class ChatWidget extends StatefulWidget {
  @override
  ChatWidgetState<ChatWidget> createState() => ChatWidgetState<ChatWidget>();
}

class ChatWidgetState<T extends ChatWidget> extends State<ChatWidget> {
  late ItemDetailProvider provider;
  late GetChatHistoryProvider getChatHistoryProvider;
  late PsValueHolder psValueHolder;
  late ItemEntryFieldProvider itemEntryFieldProvider;
  //===============
  //==Clicks count
  int dailyClickCount=0;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String getUserId() => auth.currentUser?.uid ?? 'unknown';
  @override
  void initState() {
    getDailyClickCount();
    // TODO: implement initState
    super.initState();
  }

  //===============
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ItemDetailProvider>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
     itemEntryFieldProvider = Provider.of<ItemEntryFieldProvider>(context);
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: PSButtonWidget(
          hasShadow: false,
          colorData: PsColors.primary500,
          titleText: 'item_detail_book_now'.tr,
          onPressed: () {
            onChatClick();
          },
        ),
      ),
    );
  }
//================ Subscription Clicks Count


  Future<void> getDailyClickCount() async {
    final userId = getUserId();
    final userDoc = firestore.collection('clickCounts').doc(userId);
    final userData = await userDoc.get();

    if (userData.exists) {
      final data = userData.data() as Map<String, dynamic>;
      final lastUpdated = data['lastUpdated'] as Timestamp;
      final count = data['count'] as int;
      final subscription = data['subscription'] as String;
      //===If user does not buy subscription
      if(subscription=="0"){
        final now = DateTime.now();
        if (lastUpdated.toDate().day != now.day) {
          // Reset the count for a new day
          await userDoc.set(
              {
                'lastUpdated': Timestamp.now(),
                'count': 0,
                'subscription': '0'
              });
          setState(() => dailyClickCount = 0);
        }
      }
      else {
        setState(() => dailyClickCount = count);
      }
    } else {
      // Initialize the count for a new user
      await userDoc.set({
        'lastUpdated': Timestamp.now(),
        'count': 0,
        'subscription': '0'
      });
    }
  }

  void incrementClickCount()async {
    //==Get Data from firebase
    final userId = getUserId();
    final userDoc = firestore.collection('clickCounts').doc(userId);
    final userData = await userDoc.get();
    final data = userData.data() as Map<String, dynamic>;
    final lastUpdated = data['lastUpdated'] as Timestamp;
    final count = data['count'] as int;
    final subscription = data['subscription'] as String;
    log("Subscription======${subscription}");
    log("Clicks======${count}");
    //==Check Subscription
    if(subscription=="0"){
    if (count < 5) {
      setState(() => dailyClickCount++);
      // final userId = getUserId();
      // final userDoc = firestore.collection('clickCounts').doc(userId);
      userDoc.set(
          {
            'lastUpdated': Timestamp.now(),
            'count': dailyClickCount,
            'subscription': '0'
          });
      //==URl Launcher
      final MapEntry<CustomField, SelectedObject> element = itemEntryFieldProvider
          .textControllerMap.entries
          .firstWhere((MapEntry<CustomField, SelectedObject> element) =>
      element.key.coreKeyId == "ps-itm00006");
      _launchInBrowser(Uri.parse('${element.value.valueTextController.text}'));
      log('Product******: ${element.value.valueTextController.text}');
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext contet) {
            return SubscriptionDialogBox(provider: provider,);
          });
    }}else
    {
     // ==URl Launcher
      log("****************URL Launched******************");
      final MapEntry<CustomField, SelectedObject> element = itemEntryFieldProvider
          .textControllerMap.entries
          .firstWhere((MapEntry<CustomField, SelectedObject> element) =>
      element.key.coreKeyId == "ps-itm00006");
      _launchInBrowser(Uri.parse('${element.value.valueTextController.text}'));
      log('Product******: ${element.value.valueTextController.text}');
    }
  }


//==============
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  Future<void> onChatClick() async {
    // final Uri _url = Uri.parse('https://flutter.dev');
//=====Checking for clicks


  //=========================================
    //Actual code
    //=================================================================================================
    //=================================================================================================
    // incrementClickCount();
    //=================================================================================================
    if (await Utils.checkInternetConnectivity()) {
      if(FirebaseAuth.instance.currentUser != null){
        incrementClickCount();
      }else
      {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return WarningDialog(
                message: 'Please login first',
                onPressed: (){
                  // Navigator.pop(context, true);
                },
              );
            });
      }
//==URl Launcher
//       final MapEntry<CustomField, SelectedObject> element = itemEntryFieldProvider
//           .textControllerMap.entries
//           .firstWhere((MapEntry<CustomField, SelectedObject> element) =>
//       element.key.coreKeyId == "ps-itm00006");
//       _launchInBrowser(Uri.parse('${element.value.valueTextController.text}'));
//       log('Product******: ${element.value.valueTextController.text}');
//=================================================================================================
      //=================================================================================================

      // Utils.navigateOnUserVerificationView(context, () async {
      //   Navigator.pushNamed(context, RoutePaths.chatView,
      //       arguments: ChatHistoryIntentHolder(
      //         chatFlag: PsConst.CHAT_FROM_SELLER,
      //         itemId: provider.product.id,
      //         buyerUserId: psValueHolder.loginUserId,
      //         sellerUserId: provider.product.addedUserId,
      //         userCoverPhoto: provider.product.user!.userCoverPhoto,
      //         userName: provider.product.user!.name,
      //         itemDetail: provider.product,
      //       ));
      // });
    }
  }
}
