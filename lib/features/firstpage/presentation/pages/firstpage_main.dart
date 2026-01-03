import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/firstpage_bloc.dart';

import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';

class FirstPageMain extends StatefulWidget {
  const FirstPageMain({Key? key}) : super(key: key);

  @override
  _FirstPageMainState createState() => _FirstPageMainState();
}

class _FirstPageMainState extends State<FirstPageMain> {

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FirstPageBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              FirstPage(pageController: _pageController),
              SecondPage(pageController: _pageController),
              ThirdPage(),
            ],
          ),
        ),
      ),
    );
  }
}
