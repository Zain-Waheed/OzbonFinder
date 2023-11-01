import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:theme_manager/theme_manager.dart';

import '../../config/ps_config.dart';
import '../../core/vendor/constant/ps_dimens.dart';
import '../../core/vendor/provider/product/product_provider.dart';
import '../../core/vendor/utils/utils.dart';
import '../../ui/vendor_ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import '../../ui/vendor_ui/common/dialog/warning_dialog_view.dart';
import '../../ui/vendor_ui/common/ps_button_widget.dart';
import '../../ui/vendor_ui/common/ps_credit_card_form_for_pay_stack.dart';

import 'dart:io';



class PayStackForSubscriptionView extends StatefulWidget {
  final  ItemDetailProvider provider;
  const PayStackForSubscriptionView({Key? key, required this.provider,}): super(key: key);

  @override
  State<PayStackForSubscriptionView> createState() => _PayStackForSubscriptionViewState();
}

class _PayStackForSubscriptionViewState extends State<PayStackForSubscriptionView> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final PaystackPlugin plugin = PaystackPlugin();
  //====
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String getUserId() => auth.currentUser?.uid ?? 'unknown';
  @override
  void initState() {
    plugin.initialize(publicKey: 'pk_test_485e593667e6cb54b0b9acd87ecd2e766a806d82');
    super.initState();
  }

  PaymentCard callCard(
      String cardNumber,
      String expiryDate,
      String cardHolderName,
      String cvvCode,
      ) {
    final List<String> monthAndYear = expiryDate.split('/');
    return PaymentCard(
        number: cardNumber,
        expiryMonth: int.parse(monthAndYear[0]),
        expiryYear: int.parse(monthAndYear[1]),
        name: cardHolderName,
        cvc: cvvCode);
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text.tr,
            onPressed: () {},
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return PsWidgetWithAppBarWithNoProvider(
      appBarTitle: 'PayStack',
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardWidget(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView: isCvvFocused,
                      height: 175,
                      width: MediaQuery.of(context).size.width,
                      animationDuration: PsConfig.animation_duration,
                      onCreditCardWidgetChange: (dynamic data) {},
                    ),
                    PsCreditCardFormForPayStack(
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space12, right: PsDimens.space12),
                      child: PSButtonWidget(
                        hasShadow: true,
                        width: double.infinity,
                        titleText: 'PAY',
                        onPressed: () async {

                          if (cardNumber.isEmpty) {
                            callWarningDialog(
                                context, 'Please input Card number');
                          } else if (expiryDate.isEmpty) {
                            callWarningDialog(
                                context, 'Please input Expired Date');
                          } else if (cardHolderName.isEmpty) {
                            callWarningDialog(
                                context, 'Please input Holder name');
                          } else if (cvvCode.isEmpty) {
                            callWarningDialog(
                                context, 'Please input CVV');
                          } else {
                            if (cardNumber.isEmpty) {
                              callWarningDialog(
                                  context, 'Please input Card number');
                            } else if (expiryDate.isEmpty) {
                              callWarningDialog(
                                  context, 'Please input Expired Date');
                            } else if (cardHolderName.isEmpty) {
                              callWarningDialog(
                                  context, 'Please input Holder name');
                            } else if (cvvCode.isEmpty) {
                              callWarningDialog(
                                  context, 'Please input CVV');
                            }else{
                              bool isLight = Utils.isLightMode(context);

                              if (!isLight) {
                                await ThemeManager.of(context)
                                    .setBrightnessPreference(
                                    BrightnessPreference.light);
                              }

                              // final Charge charge = Charge()
                              //   ..amount = 1
                              //   ..email = widget.provider.product.user?.userEmail
                              //   ..reference = _getReference()
                              //   ..card = callCard(
                              //       cardNumber, expiryDate, cardHolderName, cvvCode);
//=======================================================================================================================
 //=======================================================================================================================
                              final Charge charge = Charge()
                              //   ..currency='USD'
                              // ..transactionCharge=4217
                                 ..amount = (double.parse(Utils.getPriceTwoDecimal(
                                     '2999')) *
                                     100)
                                     .round()
                                ..email =  widget.provider.product.user?.userEmail
                                ..reference = _getReference()
                                ..card = callCard(
                                    cardNumber, expiryDate, cardHolderName, cvvCode);
                              try {
                                final CheckoutResponse response =
                                await plugin.checkout(
                                  context,
                                  method: CheckoutMethod.card,
                                  charge: charge,
                                  fullscreen: false,
                                  // logo: MyLogo(),
                                );
                                if (!isLight) {
                                  await ThemeManager.of(context)
                                      .setBrightnessPreference(
                                      BrightnessPreference.dark);
                                  isLight = true;
                                }
                                if (response.status) {
                                  print("********Response***********${response.status}");
                                  final userId = getUserId();
                                  final userDoc = firestore.collection('clickCounts').doc(userId);

                                  await userDoc.set({
                                    'lastUpdated': Timestamp.now(),
                                    'count': 0,
                                    'subscription': '1'
                                  });
                                  // log("Subscription======${subscription}");
                                  // payStackNow(response.reference!);
                                }
                              } catch (e) {
                                print('Check console for error');
                                rethrow;
                              }

 //=======================================================================================================================
 //=======================================================================================================================
                              if (!isLight) {
                                await ThemeManager.of(context)
                                    .setBrightnessPreference(
                                    BrightnessPreference.dark);
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: PsDimens.space40)
                  ],
                )),
          ),
        ],
      ),
    );
  }
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    if (creditCardModel != null) {
      setState(() {
        cardNumber = creditCardModel.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }
  }
}
