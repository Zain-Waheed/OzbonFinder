import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import '../../../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../../../core/vendor/utils/utils.dart';

class DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            // color: Colors.blue,
            child: Image.asset(
              'assets/images/rec_logo.png',
              width: PsDimens.space180,
              height: PsDimens.space60,
            ),
          ),
          const SizedBox(
            height: PsDimens.space4,
          ),
          // Text(
          //   'app_name'.tr,
          //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //       color: Utils.isLightMode(context)
          //           ? PsColors.text800
          //           : PsColors.achromatic50,
          //       fontSize: 18),
          // ),
          const SizedBox(
            height: PsDimens.space44,
          ),
        ],
      ),
      decoration: BoxDecoration(
          color:
              Utils.isLightMode(context) ? PsColors.primary50 : Colors.black12),
    );
  }
}
