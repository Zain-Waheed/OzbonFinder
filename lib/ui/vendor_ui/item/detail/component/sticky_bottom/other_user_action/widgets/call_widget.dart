import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../../../../../core/vendor/provider/language/app_localization_provider.dart';
import '../../../../../../../../core/vendor/provider/product/product_provider.dart';
import '../../../../../../common/ps_button_widget_with_round_corner.dart';

class PhoneCallWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ItemDetailProvider provider =
        Provider.of<ItemDetailProvider>(context);
    final List<String> phoneList =
        provider.product.phoneNumList?.split('#') ?? <String>[];
    phoneList.removeWhere((String phone) => phone == '');
    if (provider.productOwner!.showPhone && provider.productOwner!.hasPhone) {
      phoneList.insert(0, provider.productOwner!.userPhone!);
    }
    
    // final List<String> phoneNumList =
    //     List<String>.filled(phoneList.length, '', growable: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: PSButtonWidgetWithIconRoundCorner(
        colorData:Utils.isLightMode(context) ? PsColors.achromatic50  : PsColors.text800,
        borderColor: PsColors.primary500,
        width: 40,
        hasShadow: false,
        icon: Remix.phone_line,
        iconColor: PsColors.primary500,
        onPressed: () async {
          // if (provider.productOwner!.hasPhone) {
          //   if (await canLaunchUrl(
          //       Uri.parse('tel://${provider.productOwner!.userPhone}'))) {
          //     await launchUrl(
          //         Uri.parse('tel://${provider.productOwner!.userPhone}'));
          //   } else {
          //     throw 'Could not send Phone Number 1';
          //   }
          // } else if (provider.product.phoneNumList != '')
            showModalBottomSheet<Widget>(
                elevation: 2.0,
                isScrollControlled: true,
                useRootNavigator: true,
                isDismissible: true,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.0)),
                ),
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.zero,
                            itemCount: phoneList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    bottom: PsDimens.space16),
                                child: InkWell(
                                  onTap: () async {
                                    if (await canLaunchUrl(Uri.parse(
                                        'tel://${phoneList[index]}'))) {
                                      await launchUrl(Uri.parse(
                                          'tel://${phoneList[index]}'));
                                    } else {
                                      throw 'Could not send Phone Number 1';
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        phoneList.elementAt(index),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.normal),
                                      ),
                                      Icon(
                                        Remix.phone_line,
                                        size: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        PSButtonWithIconWidget(
                          colorData: Theme.of(context).primaryColor,
                          hasShadow: false,
                          // icon: Icons.call,
                          iconColor: Theme.of(context).primaryColor,
                          width: double.infinity,
                          titleText: 'cancel'.tr,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                });
        },
      ),
    );
  }
}
