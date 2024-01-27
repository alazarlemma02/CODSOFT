import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/screens/views/navigation_screen.dart';

class WelcomeScreenWidget extends StatelessWidget {
  final int pageIndex;
  final String title;
  final String subtitle;
  final String buttonTitle;
  final String imageUrl;
  final BuildContext context;
  final PageController pageController;
  const WelcomeScreenWidget({
    super.key,
    required this.pageIndex,
    required this.title,
    required this.subtitle,
    required this.buttonTitle,
    required this.imageUrl,
    required this.context,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          height: 400,
          width: double.infinity,
          child: Center(
            child: Image(
              image: AssetImage(imageUrl),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: lightColorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: lightColorScheme.secondary),
                  ),
                ],
              ),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            shadowColor: Colors.black,
          ),
          onPressed: () async {
            if (pageIndex < 0) {
              pageController.animateToPage(pageIndex + 1,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigationScreen(),
                  ),
                  (route) => false);

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("firstTime", false);
            }
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Center(
              child: Text(
                buttonTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
