

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psxmpc/PaymentMethods/stripe/stripe_for_subscription.dart';
import 'package:psxmpc/core/vendor/provider/ps_provider_dependencies.dart';
import '../../core/vendor/provider/product/product_provider.dart';
import '../../config/ps_colors.dart';
import '../../core/vendor/constant/ps_dimens.dart';
import '../../core/vendor/repository/user_repository.dart';
import '../../core/vendor/utils/ps_progress_dialog.dart';
import '../../core/vendor/utils/utils.dart';
import '../../core/vendor/viewobject/common/ps_value_holder.dart';
import '../../core/vendor/viewobject/holder/username_and_pwd_holder.dart';
import '../../ui/vendor_ui/common/dialog/warning_dialog_view.dart';
import '../../ui/vendor_ui/common/ps_button_widget.dart';
import '../../ui/vendor_ui/common/ps_header_icon_and_dynamic_text_widget.dart';
import '../../ui/vendor_ui/common/ps_textfield_widget.dart';
import '../paystack/paystack_for_subscription.dart';

class SubscriptionDialogBox extends StatefulWidget {
  ItemDetailProvider provider;
  SubscriptionDialogBox({Key? key, required this.provider,}): super(key: key);

  @override
  State<SubscriptionDialogBox> createState() => _SubscriptionDialogBoxState();
}

class _SubscriptionDialogBoxState extends State<SubscriptionDialogBox> {
  UserRepository? repo1;
  PsValueHolder? psValueHolder;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool userNameWrongFormat = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 46,
                        height: 46,
                        child: Icon(
                          Icons.close,
                          color: Utils.isLightMode(context)
                              ?PsColors.achromatic800 : PsColors.achromatic50,
                        ),
                      )),
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: PsDimens.space18),
                    child: PsHeaderIconAndDynamicTextWidget(text: 'You have exceeded your daily ad views. Subscribe to continue viewing.')),

                if (userNameWrongFormat)
                  Container(
                    margin: const EdgeInsets.only(
                        top: PsDimens.space2,
                        left: PsDimens.space16,
                        right: PsDimens.space16),
                    child: Text(
                      'warning_dialog__username_format'.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                          fontWeight: FontWeight.w400,
                          color: PsColors.error500),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: PsDimens.space16,
                  //       vertical: PsDimens.space20),
                  //   child: PSButtonWidget(
                  //     titleText: 'Subscribe NGN 2,999',
                  //     onPressed: () async {
                  //       Get.to(PayStackForSubscriptionView(provider: widget.provider,));
                  //     },
                  //   ),
                  // ),
                paymentbtn(
                        (){
                          Get.to(PayStackForSubscriptionView(provider: widget.provider,));
                    },Image.asset('assets/images/payment/paystack.png')),
                Center(
                  child: Text(
                    'OR',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Utils.isLightMode(context)
                            ? PsColors.text800
                            : PsColors.achromatic50),
                  ),
                ),
                   paymentbtn(
                           (){
                             Get.to(StripeForSubscriptionView());
                   },Image.asset('assets/images/payment/stripe.png')),
              ]),
        ),
    );
  }

  paymentbtn(Function? onPressed,Widget image) {
    return
    InkWell(
      onTap: onPressed as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: PsDimens.space16,
            vertical: PsDimens.space20),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
                left: PsDimens.space8, right: PsDimens.space8),
            height: 40,
            decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(12), color: Theme.of(context).primaryColor),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(width: PsDimens.space40),
                    Container(
                        width: 32,
                        height: 32,
                        child: image),
                    const SizedBox(width: PsDimens.space22),
                    Text(
                      'Subscribe',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Utils.isLightMode(context)
                              ? PsColors.text800
                              : PsColors.achromatic50),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
