import 'package:flutter/material.dart';
import '../favorite/favorite_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _pages = const [HomePage(), FavoritePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack: state tiap tab terjaga (Home tidak fetch ulang).
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
