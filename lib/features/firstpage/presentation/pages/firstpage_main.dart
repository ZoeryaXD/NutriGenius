import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart'; // Import Service Locator (sl)
import '../bloc/firstpage_bloc.dart';

// Import 3 Halaman Anak
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';

class FirstPageMain extends StatefulWidget {
  const FirstPageMain({Key? key}) : super(key: key);

  @override
  _FirstPageMainState createState() => _FirstPageMainState();
}

class _FirstPageMainState extends State<FirstPageMain> {
  // Controller untuk mengatur perpindahan halaman
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. INJECT BLOC DISINI
    // Kita pasang BlocProvider di induk agar state (Data TDEE) tetap hidup
    // saat user geser dari Page 1 -> Page 2 -> Page 3.
    return BlocProvider(
      create: (_) => sl<FirstPageBloc>(), 
      child: Scaffold(
        backgroundColor: Colors.white, // Sesuaikan warna background desain
        body: SafeArea(
          // 2. PageView
          // physics: NeverScrollable... agar user TIDAK BISA swipe manual.
          // User wajib tekan tombol "Lanjut" untuk validasi data dulu.
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), 
            children: [
              FirstPage(pageController: _pageController),
              SecondPage(pageController: _pageController),
              ThirdPage(), // Halaman terakhir tidak butuh controller (karena submit & finish)
            ],
          ),
        ),
      ),
    );
  }
}