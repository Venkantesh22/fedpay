import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/drawer_screen/component/qr_section.dart';
import 'package:lekra/views/screens/drawer_screen/component/drawer_profile_section.dart';
import 'package:lekra/views/screens/drawer_screen/component/drawer_title_section.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // ADD THIS SHAPE: It rounds the corners to match your floating bar
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      backgroundColor: Colors.white, // Ensure it is pure white
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBoxHeight(height: 20),
            DrawerProfileSection(),
            QRSection(),
            DrawerTitleSection()
          ],
        ),
      ),
    );
  }
}
