import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';

import '../../../../../../../../config/ps_colors.dart';
import '../../../../../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../../../../../core/vendor/provider/product/product_provider.dart';
import '../../../../../../../../core/vendor/utils/utils.dart';
import '../../../../../../../../core/vendor/viewobject/common/ps_value_holder.dart';
import '../../../../../../../../core/vendor/viewobject/message.dart';
import '../../../../../../../../core/vendor/viewobject/product.dart';

class SenderMakeOfferMessage extends StatelessWidget {
  const SenderMakeOfferMessage({required this.messageObj});
  final Message messageObj;

  @override
  Widget build(BuildContext context) {
    final ItemDetailProvider itemDetailProvider =
        Provider.of<ItemDetailProvider>(context);
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    final Product? itemDetail = itemDetailProvider.product;
    print(
        '******Make Offer time ${Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp)}');
    return Container(
      margin: const EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        bottom: PsDimens.space16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            Utils.convertTimeStampToTime(messageObj.addedDateTimeStamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(PsDimens.space16),
                color: PsColors.info500),
            padding: const EdgeInsets.all(PsDimens.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  // 'chat_view__make_offer_message'.tr,
                  'chat_view__make_book_message'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: PsColors.achromatic50),
                ),
                const SizedBox(height: PsDimens.space8),
                Text(
                  itemDetail!.originalPrice != '0'
                      ? Utils.getChatPriceFormat(
                          messageObj.message!, psValueHolder.priceFormat!)
                      : 'item_price_free'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: PsColors.achromatic50),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
