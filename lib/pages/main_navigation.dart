import 'package:cosmolot/pages/calendar_cosmic.dart';
import 'package:cosmolot/pages/watch_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cosmolot/pages/homi_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _tabViews = [
    const HomiPage(),
    CalendarCosmic(),
    const WatchPage(),
    const WatchPage(),
  ];

  final List<IconData> _tabIcons = [
    CupertinoIcons.rocket,
    CupertinoIcons.calendar,
    CupertinoIcons.book_solid,
    CupertinoIcons.gift_fill,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _tabViews[_currentIndex],
        Positioned(
          left: 12,
          right: 12,
          bottom: 30,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xff2E073F),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_tabIcons.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    child: Icon(
                      _tabIcons[index],
                      color: _currentIndex == index
                          ? const Color(0xff7A1CAC)
                          : Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
