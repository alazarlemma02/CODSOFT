import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/welcome_bloc/welcome_bloc.dart';
import 'package:task_app/screens/widgets/welcome_screen_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("assets/images/welcome_background.png",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width),
        Scaffold(
          body: BlocBuilder<WelcomeBloc, WelcomeInitial>(
            builder: (context, state) {
              return Stack(
                alignment: FractionalOffset.bottomCenter,
                children: [
                  PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      state.pageIndex = value;
                      BlocProvider.of<WelcomeBloc>(context)
                          .add(WelcomePageChangedEvent());
                    },
                    children: [
                      WelcomeScreenWidget(
                        pageController: pageController,
                        pageIndex: 0,
                        title: "Welcome to TaskMaster!",
                        subtitle: "Let's make today super productive together!",
                        buttonTitle: "Let's Start",
                        imageUrl: "assets/images/welcome_logo.png",
                        context: context,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
