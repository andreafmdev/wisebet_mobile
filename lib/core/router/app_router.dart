import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/offers/presentation/pages/offers_list_page.dart';
import '../../features/offers/presentation/pages/offer_detail_page.dart';
import '../../features/surebets/presentation/pages/surebets_list_page.dart';
import '../../features/calculator/presentation/pages/calculator_page.dart';
import '../../features/profit_tracker/presentation/pages/profit_tracker_page.dart';
import '../../features/profit_tracker/presentation/pages/add_profit_entry_page.dart';
import '../../features/guides/presentation/pages/guides_list_page.dart';
import '../../features/guides/presentation/pages/guide_detail_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/subscription_page.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: authState == null ? '/auth/onboarding' : '/dashboard',
    routes: [
      // Auth routes
      GoRoute(
        path: '/auth/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),

      // Main app with bottom nav
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/offers',
            builder: (context, state) => const OffersListPage(),
          ),
          GoRoute(
            path: '/offers/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return OfferDetailPage(offerId: id);
            },
          ),
          GoRoute(
            path: '/surebets',
            builder: (context, state) => const SurebetsListPage(),
          ),
          GoRoute(
            path: '/calculator',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return CalculatorPage(extra: extra);
            },
          ),
          GoRoute(
            path: '/profit-tracker',
            builder: (context, state) => const ProfitTrackerPage(),
          ),
          GoRoute(
            path: '/profit-tracker/add',
            builder: (context, state) => const AddProfitEntryPage(),
          ),
          GoRoute(
            path: '/guides',
            builder: (context, state) => const GuidesListPage(),
          ),
          GoRoute(
            path: '/guides/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GuideDetailPage(guideId: id);
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/subscription',
            builder: (context, state) => const SubscriptionPage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (authState == null && !isAuthRoute) {
        return '/auth/onboarding';
      }
      if (authState != null && isAuthRoute) {
        return '/dashboard';
      }
      return null;
    },
  );
});

class _MainShell extends StatefulWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    // Update index based on route
    if (location.startsWith('/dashboard')) {
      _currentIndex = 0;
    } else if (location.startsWith('/offers')) {
      _currentIndex = 1;
    } else if (location.startsWith('/surebets') || location.startsWith('/calculator')) {
      _currentIndex = 2;
    } else if (location.startsWith('/profit-tracker')) {
      _currentIndex = 3;
    } else if (location.startsWith('/guides')) {
      _currentIndex = 4;
    } else if (location.startsWith('/profile') || location.startsWith('/subscription')) {
      _currentIndex = 5;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _currentIndex < 5
          ? Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF1B263B),
                selectedItemColor: AppColors.accentGold,
                unselectedItemColor: AppColors.textTertiary,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  switch (index) {
                    case 0:
                      context.go('/dashboard');
                      break;
                    case 1:
                      context.go('/offers');
                      break;
                    case 2:
                      context.go('/surebets');
                      break;
                    case 3:
                      context.go('/profit-tracker');
                      break;
                    case 4:
                      context.go('/guides');
                      break;
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_offer),
                    label: 'Offerte',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.trending_up),
                    label: 'SureBet',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics),
                    label: 'Profitti',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Guide',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

