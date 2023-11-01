import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/ui/vendor_ui/common/bluemark_icon.dart';

import '../../../../../../config/route/route_paths.dart';
import '../../../../../../core/vendor/constant/ps_constants.dart';
import '../../../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../../../core/vendor/provider/offer/offer_provider.dart';
import '../../../../../../core/vendor/utils/utils.dart';
import '../../../../../../core/vendor/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import '../../../../../../core/vendor/viewobject/holder/intent_holder/user_intent_holder.dart';
import '../../../../../../core/vendor/viewobject/offer.dart';
import '../../../../common/ps_ui_widget.dart';

class OfferSentListItem extends StatelessWidget {
  const OfferSentListItem({
    Key? key,
    required this.offer,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final Offer offer;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );

    final Widget _dividerWidget = Divider(
      height: PsDimens.space1,
      color: Utils.isLightMode(context) ? PsColors.achromatic400 : PsColors.achromatic100,
      thickness: 0.2,
    );
    animationController?.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: () {
            onTap(context);
          },
          child: Column(
            children: <Widget>[
              // _dividerWidget,
              Container(
                color: Utils.isLightMode(context)
                    ? PsColors.achromatic50
                    : PsColors.achromatic800,
                padding: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space19, vertical: PsDimens.space8),
                child: Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              width: PsDimens.space64,
                              height: PsDimens.space64,
                              child: PsNetworkCircleImage(
                                photoKey: '',
                                imagePath: offer.item!.defaultPhoto?.imgPath,
                                boxfit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              right: 1,
                              child: Container(
                                width: PsDimens.space24,
                                height: PsDimens.space24,
                                child: PsNetworkCircleImageForUser(
                                  photoKey: '',
                                  imagePath: offer.item!.user!.userCoverPhoto,
                                  boxfit: BoxFit.cover,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutePaths.userDetail,
                                        arguments: UserIntentHolder(
                                            userId: offer.seller!.userId,
                                            userName: offer.seller!.name));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: PsDimens.space16,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                offer.item!.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600),
                              ),
                              // _spacingWidget,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          offer.seller?.name == ''
                                              ? 'default__user_name'.tr
                                              : offer.seller?.name ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal),
                                        ),
                                        if (offer.seller!.isVefifiedBlueMarkUser)
                                          const BluemarkIcon()
                                      ],
                                    ),
                                  ),
                                  if (offer.hasBuyerUnreadCount)
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor, //PsColors.primary500,
                                        borderRadius: BorderRadius.circular(
                                            PsDimens.space28),
                                      ),
                                      child: Center(
                                        child: Text(offer.buyerUnreadCount!,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Utils.isLightMode(
                                                            context)
                                                        ? PsColors.achromatic50
                                                        : PsColors
                                                            .achromatic800,
                                                    fontSize: 10)),
                                      ),
                                    ),
                                ],
                              ),
                              _spacingWidget,
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  offer.addedDateStr!,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: Utils.isLightMode(context)
                                              ? PsColors.text900
                                              : PsColors.text50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _dividerWidget
            ],
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }

  Future<void> onTap(BuildContext context) async {
    final OfferListProvider provider =
        Provider.of<OfferListProvider>(context, listen: false);
    print(offer.item!.title);
    final dynamic returnData = await Navigator.pushNamed(
      context,
      RoutePaths.chatView,
      arguments: ChatHistoryIntentHolder(
          chatFlag: PsConst.CHAT_FROM_SELLER,
          itemId: offer.item!.id,
          buyerUserId: offer.buyerUserId,
          sellerUserId: offer.sellerUserId,
          userCoverPhoto: offer.seller!.userCoverPhoto,
          userName: offer.seller!.name,
          itemDetail: offer.item),
    );
    if (returnData == null) {
      provider.loadDataList();
    }
  }
}
