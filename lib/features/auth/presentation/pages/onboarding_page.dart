import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      icon: Icons.account_balance_wallet,
      title: 'Trasforma i bonus in profitto',
      description: 'Sfrutta i bonus dei bookmaker per ottenere guadagni garantiti senza rischi',
      color: AppColors.accentGold,
    ),
    OnboardingItem(
      icon: Icons.trending_up,
      title: 'Scopri le SureBet e ValueBet',
      description: 'Identifica automaticamente le opportunità di profitto con i nostri strumenti avanzati',
      color: AppColors.accentTeal,
    ),
    OnboardingItem(
      icon: Icons.analytics,
      title: 'Tieni traccia dei tuoi guadagni',
      description: 'Monitora i tuoi profitti nel tempo con dashboard dettagliate e statistiche',
      color: AppColors.accentCyan,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: const Text(
                    'Salta',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildIndicator(index == _currentPage),
                ),
              ),

              const SizedBox(height: 32),

              // Next button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: PrimaryButton(
                  text: _currentPage == _pages.length - 1 ? 'Inizia' : 'Avanti',
                  onPressed: _nextPage,
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 60,
              color: item.color,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            item.title,
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            item.description,
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentGold : AppColors.textTertiary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

