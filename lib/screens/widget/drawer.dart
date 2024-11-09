import 'package:flutter/material.dart';
import 'package:msbm_assessment_test/controllers/auth.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/icons.dart';
import 'package:msbm_assessment_test/helper/styles.dart';
import 'package:msbm_assessment_test/controllers/navigation.dart';
import 'package:msbm_assessment_test/screens/widget/navigation.dart';
import 'package:msbm_assessment_test/widgets/avatar_image.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    // Get the properties.
    final size = MediaQuery.sizeOf(context);
    final user = AppRegistry.find<AuthController>().currentState;

    // Return the widget.
    return Container(
      height: size.height,
      color: ThemeColors.primaryColor,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            //? First, for the profile image.
            const AvatarImage(
              image: "",
              height: 170,
              width: 170,
            ),

            // Some space.
            const SizedBox(height: Dimensions.paddingSizeDefault),

            //? Next, the user's name.
            Text(
              "${user?.firstname} ${user?.lastname}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: fontRegular.copyWith(
                fontSize: Dimensions.fontSizeLarger,
                color: Colors.white,
              ),
            ),

            // A lot more space.
            const SizedBox(height: Dimensions.paddingSize2XL),

            //? First on the navigation hierarchy is the dashboard.
            NavigationDrawerButtonWidget(
              value: 0,
              controller: AppRegistry.find<NavigationController>(),
              icon: AppIcons.folderAll,
              title: "My Drive",
            ),

            //? Second on the navigation hierarchy is the property listings.
            NavigationDrawerButtonWidget(
              value: 1,
              controller: AppRegistry.find<NavigationController>(),
              icon: AppIcons.settings,
              title: "Settings",
            ),

            // Finally, some extreme space.
            const SizedBox(height: Dimensions.paddingSize5XL),
          ],
        ),
      ),
    );
  }
}
