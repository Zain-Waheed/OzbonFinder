import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/vendor/provider/product/product_provider.dart';
import '../../../../../../custom_ui/item/detail/component/sticky_bottom/other_user_action/widgets/call_widget.dart';
import '../../../../../../custom_ui/item/detail/component/sticky_bottom/other_user_action/widgets/chat_widget.dart';
import '../../../../../../custom_ui/item/detail/component/sticky_bottom/other_user_action/widgets/sms_widget.dart';

class OtherUserActionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ItemDetailProvider provider =
        Provider.of<ItemDetailProvider>(context);
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // if (provider.productOwner != null && (provider.productOwner!.showPhone && provider.productOwner!.hasPhone) || provider.product.phoneNumList != '')
          //   CustomPhoneCallWidget(),
          // if (provider.productOwner != null && (provider.productOwner!.showPhone && provider.productOwner!.hasPhone) || provider.product.phoneNumList != '')
          //   CustomSMSWidget(),
          CustomChatWidget()
        ],
      ),
    );
  }
}
