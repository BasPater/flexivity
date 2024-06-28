import 'package:flexivity/app/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Content(),
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Flexivity",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          const Image(
              width: 200,
              height: 200,
              image: AssetImage(
                  'lib/app/assets/app_icon/app_icon_square_rounded.png')),
          const SizedBox(
            height: 16,
          ),
          FullWidthButton(
              label: "Sign up",
              onPressed: () => GoRouter.of(context).push("/sign_up")),
          const SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () => GoRouter.of(context).push('/login'),
                style: Theme.of(context).textButtonTheme.style,
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize),
                )),
          )
        ],
      ),
    );
  }
}
