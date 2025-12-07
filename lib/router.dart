import 'package:go_router/go_router.dart';
import 'package:mvvm_real/view/pages/pages.dart';
import 'package:mvvm_real/view/widgets/widgets.dart';
import 'package:flutter/material.dart';


final GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavBar(
            currentIndex: _getCurrentIndex(state.uri.toString()),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/international',
          name: 'international',
          builder: (context, state) => const InternationalPage(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);

int _getCurrentIndex(String location) {
  if (location == '/') return 0;
  if (location == '/international') return 1;
  // if (location == '/profile') return 2;
  return 0;
}

