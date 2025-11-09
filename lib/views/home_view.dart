import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import '../view_models/stock_market_view_model.dart';
import '../models/loan_type.dart';
import '../models/stock.dart';
import '../navigation/app_router.dart';
import '../theme/app_theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final loanTypes = LoanType.allTypes;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPainter(isDark: isDark),
            ),
          ),
          
          // Floating Orbs
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: 100 + _floatingAnimation.value,
                    right: 30,
                    child: _buildFloatingOrb(size: 120, color: AppTheme.primaryBlue),
                  ),
                  Positioned(
                    bottom: 200 - _floatingAnimation.value,
                    left: -20,
                    child: _buildFloatingOrb(size: 160, color: AppTheme.primaryPink),
                  ),
                  Positioned(
                    top: size.height * 0.4 + _floatingAnimation.value * 0.5,
                    right: -40,
                    child: _buildFloatingOrb(size: 100, color: AppTheme.primaryTeal),
                  ),
                ],
              );
            },
          ),

          // Main Content
          Column(
            children: [
              // App Bar with Tabs
              ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                                  AppTheme.primaryBlue.withOpacity(0.4),
                                  AppTheme.primaryPurple.withOpacity(0.3),
                                  theme.scaffoldBackgroundColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                        child: Column(
                          children: [
                          // Header
                          Padding(
                            padding: Responsive.getPadding(context).copyWith(bottom: 10),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'app_icon',
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: AppTheme.getPrimaryGradient(),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryBlue.withOpacity(0.5),
                                          blurRadius: 29,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome_outlined,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [Colors.white70, Colors.white],
                                        ).createShader(bounds),
                                        child: Text(
                                          "AI-Powered Assistant",
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: AppTheme.getSecondaryGradient(),
                                        ).createShader(bounds),
                                        child: Text(
                                          "Loan Advisor",
                                          style: theme.textTheme.displaySmall?.copyWith(
                                            letterSpacing: -1,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.history, color: theme.colorScheme.onSurface),
                                  onPressed: () {
                                    Navigator.pushNamed(context, AppRouter.chatHistory);
                                  },
                                ),
                              ],
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Main Content
              Expanded(
                child: _getCurrentPage(vm, loanTypes),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildIOSBottomNavBar(),
    );
  }

  Widget _getCurrentPage(HomeViewModel vm, List<LoanType> loanTypes) {
    switch (_currentIndex) {
      case 0:
        return _buildLoanTypeTab(vm, loanTypes);
      case 1:
        return _buildQuickActionsTab(context);
      case 2:
        return _buildStockMarketTab(context);
      case 3:
        // Settings tab - this should not be reached as it navigates directly
        return _buildLoanTypeTab(vm, loanTypes);
      default:
        return _buildLoanTypeTab(vm, loanTypes);
    }
  }

  Widget _buildIOSBottomNavBar() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return Container(
          color: Colors.transparent,
          child: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6, top: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildIOSNavItem(
                          context,
                          icon: Icons.category_outlined,
                          activeIcon: Icons.category,
                          label: 'Loan Type',
                          index: 0,
                        ),
                        _buildIOSNavItem(
                          context,
                          icon: Icons.flash_on_outlined,
                          activeIcon: Icons.flash_on,
                          label: 'Quick Actions',
                          index: 1,
                        ),
                        _buildIOSNavItem(
                          context,
                          icon: Icons.trending_up_outlined,
                          activeIcon: Icons.trending_up,
                          label: 'Stock Market',
                          index: 2,
                        ),
                        _buildIOSNavItem(
                          context,
                          icon: Icons.settings_outlined,
                          activeIcon: Icons.settings,
                          label: 'Settings',
                          index: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIOSNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors
    final activeColor = isDark ? Colors.white : Colors.black;
    final inactiveColor = isDark 
        ? Colors.white.withOpacity(0.6) 
        : Colors.black.withOpacity(0.6);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Haptic feedback simulation
          HapticFeedback.selectionClick();
          
          // Navigate directly to Settings or Chat History if those tabs are tapped
          if (index == 3) {
            // Settings tab - navigate directly
            Navigator.pushNamed(context, AppRouter.settings);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect for active item (iridescent blue-green)
                  if (isActive)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryBlue.withOpacity(0.35),
                            AppTheme.primaryTeal.withOpacity(0.25),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 1.5,
                          ),
                          BoxShadow(
                            color: AppTheme.primaryTeal.withOpacity(0.4),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  // Icon container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isActive ? activeIcon : icon,
                      color: isActive ? activeColor : inactiveColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontSize: isActive ? 9 : 8,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? activeColor : inactiveColor,
                  letterSpacing: -0.2,
                  height: 1.0,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingOrb({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSectionHeader(String title, IconData icon, BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.getPrimaryGradient(),
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white70],
          ).createShader(bounds),
          child: Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanTypeTab(HomeViewModel vm, List<LoanType> loanTypes) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern Section Header
              _buildModernSectionHeader('Select Loan Type', Icons.apps_rounded, context),
              const SizedBox(height: 2),
              
              // Premium Loan Cards
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.getGridCrossAxisCount(context),
                  crossAxisSpacing: Responsive.isMobile(context) ? 16 : 20,
                  mainAxisSpacing: Responsive.isMobile(context) ? 16 : 20,
                  childAspectRatio: Responsive.getCardAspectRatio(context),
                ),
                        itemCount: loanTypes.length,
                        itemBuilder: (context, index) {
                          final loan = loanTypes[index];
              final isSelected = vm.loanType == loan.name;
              final loanColor = Color(loan.colorValue);
                          
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 400 + (index * 100)),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: GestureDetector(
                      onTap: () => vm.setLoanType(loan.name),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [
                                    loanColor,
                                    loanColor.withOpacity(0.7),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : LinearGradient(
                                              colors: [
                                                theme.colorScheme.surface,
                                                theme.colorScheme.surfaceVariant,
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: isSelected
                                ? loanColor.withOpacity(0.5)
                                            : AppTheme.getGlassBorder(isDark),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                    color: loanColor.withOpacity(0.4),
                                                blurRadius: 25,
                                                offset: const Offset(0, 12),
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                        child: Container(
                              padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                    loan.emoji,
                                                style: TextStyle(fontSize: 28),
                                              ),
                                              const SizedBox(height: 6),
                                              Flexible(
                                                child: Text(
                                      loan.name,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.3,
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected) ...[
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    '✓',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Question Section
                      _buildModernSectionHeader('Your Question', Icons.chat_bubble_outline, context),
                      const SizedBox(height: 20),
                      
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                      AppTheme.getGlassBackground(isDark),
                      AppTheme.getGlassBackground(isDark).withOpacity(0.5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                    color: AppTheme.getGlassBorder(isDark),
                                width: 1.5,
                              ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: TextField(
                                    onChanged: vm.setQuery,
                                    maxLines: 5,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      height: 1.6,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Ask anything about ${vm.loanType.toLowerCase()}...',
                                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: AppTheme.getGlassBorder(isDark),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.lightbulb_outline,
                                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                                              size: 10,
                                            ),
                                            Text(
                                              'Be specific',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Row(
                                          children: [
                                            if (vm.isLoading)
                                              GestureDetector(
                                                onTap: () {
                                                  // Call stop method if available in your view model
                                                  // vm.stopGeneration();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [AppTheme.primaryRed, AppTheme.primaryRed.withOpacity(0.8)],
                                                    ),
                                                    borderRadius: BorderRadius.circular(14),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppTheme.primaryRed.withOpacity(0.4),
                                                        blurRadius: 12,
                                                        offset: const Offset(0, 6),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.stop_circle_outlined,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        'Stop',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 0.3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (vm.isLoading) const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: vm.isLoading ? null : vm.generateContent,
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: vm.isLoading
                                                        ? [Colors.grey, Colors.grey.shade700]
                                                        : AppTheme.getPrimaryGradient(),
                                                  ),
                                                  borderRadius: BorderRadius.circular(14),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppTheme.primaryBlue.withOpacity(0.4),
                                                      blurRadius: 12,
                                                      offset: const Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    if (vm.isLoading)
                                                      SizedBox(
                                                        height: 14,
                                                        width: 14,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    else
                                                      Icon(
                                                        Icons.send_rounded,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      vm.isLoading ? 'Processing' : 'Ask Ai',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                        letterSpacing: 0.3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // AI Response Section
                      if (vm.isLoading || vm.response.isNotEmpty)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildModernSectionHeader(
                                      'AI Response',
                                      Icons.auto_awesome,
                                      context,
                                    ),
                                    const SizedBox(height: 20),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 500),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                      AppTheme.primaryBlue.withOpacity(0.2),
                                      AppTheme.primaryPurple.withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(28),
                                            border: Border.all(
                                    color: AppTheme.primaryBlue.withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryBlue.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                          ),
                                          padding: const EdgeInsets.all(24),
                                          child: vm.isLoading
                                              ? Column(
                                                  children: [
                                                    Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 3,
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                              AppTheme.primaryBlue,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            // Call stop method
                                                            // vm.stopGeneration();
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              color: AppTheme.primaryRed,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Icon(
                                                              Icons.stop_rounded,
                                                              color: Colors.white,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      "Analyzing your query with AI...",
                                                      style: theme.textTheme.bodyLarge?.copyWith(
                                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      "Tap the stop icon to cancel",
                                                      style: theme.textTheme.bodySmall?.copyWith(
                                                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : AnimatedTextKit(
                                                  isRepeatingAnimation: false,
                                                  totalRepeatCount: 1,
                                                  displayFullTextOnTap: true,
                                                  animatedTexts: [
                                                    TypewriterAnimatedText(
                                                      vm.response,
                                                      textStyle: theme.textTheme.bodyLarge?.copyWith(
                                                        height: 1.8,
                                                        color: theme.colorScheme.onSurface.withOpacity(0.9),
                                                        letterSpacing: 0.3,
                                                      ),
                                                      speed: const Duration(milliseconds: 25),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 60),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildQuickActionsTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: Responsive.getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Modern Section Header
          _buildModernSectionHeader('Quick Actions', Icons.flash_on, context),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: _buildQuickActionCard(
                    context,
                    'EMI Calculator',
                    Icons.calculate,
                    AppTheme.primaryBlue,
                    () => Navigator.pushNamed(context, AppRouter.emiCalculator),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: _buildQuickActionCard(
                    context,
                    'Eligibility',
                    Icons.verified_user,
                    AppTheme.primaryPink,
                    () => Navigator.pushNamed(context, AppRouter.loanEligibility),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: _buildQuickActionCard(
                    context,
                    'Compare Loans',
                    Icons.compare_arrows,
                    AppTheme.primaryTeal,
                    () => Navigator.pushNamed(context, AppRouter.loanComparison),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: _buildQuickActionCard(
                    context,
                    'Documents',
                    Icons.folder_open,
                    AppTheme.primaryOrange,
                    () => Navigator.pushNamed(context, AppRouter.documentChecklist),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: _buildQuickActionCard(
              context,
              'Loan Tips & Advice',
              Icons.lightbulb_outline,
              AppTheme.primaryGold,
              () => Navigator.pushNamed(context, AppRouter.loanTips),
              fullWidth: true,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: _buildQuickActionCard(
                    context,
                    'Amortization',
                    Icons.table_chart,
                    AppTheme.primaryBlue,
                    () => Navigator.pushNamed(context, AppRouter.amortizationSchedule),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: _buildQuickActionCard(
                    context,
                    'Prepayment',
                    Icons.trending_down,
                    AppTheme.primaryTeal,
                    () => Navigator.pushNamed(context, AppRouter.prepaymentCalculator),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1100),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: _buildQuickActionCard(
              context,
              'Banks & NBFCs',
              Icons.account_balance,
              AppTheme.primaryPink,
              () => Navigator.pushNamed(context, AppRouter.bankDirectory),
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
              gradient: LinearGradient(
          colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
          ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockMarketTab(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockMarketViewModel(),
      child: Consumer<StockMarketViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: Responsive.getPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
                // Market Summary
                _buildMarketSummaryCard(vm, context),
                const SizedBox(height: 20),

                // Quick Actions
                _buildModernSectionHeader('Quick Actions', Icons.flash_on, context),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: _buildStockActionCard(
                          context,
                          'Dashboard',
                          Icons.dashboard,
                          AppTheme.primaryBlue,
                          () => Navigator.pushNamed(context, AppRouter.stockMarketDashboard),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: _buildStockActionCard(
                          context,
                          'Portfolio',
                          Icons.account_balance_wallet,
                          AppTheme.primaryTeal,
                          () => Navigator.pushNamed(context, AppRouter.virtualPortfolio),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: _buildStockActionCard(
                          context,
                          'News',
                          Icons.newspaper,
                          AppTheme.primaryPink,
                          () => Navigator.pushNamed(context, AppRouter.marketNews),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: _buildStockActionCard(
                          context,
                          'AI Insights',
                          Icons.auto_awesome,
                          AppTheme.primaryOrange,
                          () => _showAIInsights(context, vm),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Top Stocks
                _buildModernSectionHeader('Top Gainers', Icons.trending_up, context),
                const SizedBox(height: 12),
                _buildTopStocksList(context, vm.topGainers),
                const SizedBox(height: 20),

                // Portfolio Summary
                if (vm.holdings.isNotEmpty) ...[
                  _buildModernSectionHeader('Your Portfolio', Icons.account_balance_wallet, context),
                  const SizedBox(height: 12),
                  _buildPortfolioSummary(context, vm),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarketSummaryCard(StockMarketViewModel vm, BuildContext context) {
    final summary = vm.marketSummary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.getPrimaryGradient(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Nifty 50',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        summary['nifty50'] as String,
                        style: const TextStyle(
            color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
          ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Sensex',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
        ),
                      const SizedBox(height: 4),
                      Text(
                        summary['sensex'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
          child: Text(
                  "Today's Mood: ${summary['mood']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 12),
                Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopStocksList(BuildContext context, List<Stock> stocks) {
    return Column(
      children: stocks.take(5).map((stock) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.stockDetail,
                arguments: stock,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Builder(
                  builder: (context) {
                    final theme = Theme.of(context);
                    final isDark = theme.brightness == Brightness.dark;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.getGlassBackground(isDark),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.getGlassBorder(isDark),
                        ),
                      ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock.symbol,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              stock.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${stock.currentPrice.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                stock.changePercent >= 0
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: stock.changePercent >= 0
                                    ? AppTheme.primaryTeal
                                    : AppTheme.primaryRed,
                                size: 12,
                              ),
                              Text(
                                '${stock.changePercent >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: stock.changePercent >= 0
                                      ? AppTheme.primaryTeal
                                      : AppTheme.primaryRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPortfolioSummary(BuildContext context, StockMarketViewModel vm) {
    final totalValue = vm.totalPortfolioValue;
    final profitLoss = vm.totalProfitLoss;
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.getTealGradient().map((c) => c.withOpacity(0.2)).toList(),
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryTeal.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portfolio Value',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${totalValue.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'P&L',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${profitLoss.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: profitLoss >= 0
                              ? AppTheme.primaryTeal
                              : AppTheme.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.virtualPortfolio);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppTheme.getTealGradient(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'View Full Portfolio',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ],
          ),
        ),
      ),
    );
  }

  void _showAIInsights(BuildContext context, StockMarketViewModel vm) {
    final insights = vm.getAIInsights();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppTheme.primaryPink),
                    const SizedBox(width: 12),
                    Text(
                      'AI Insights',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...insights.take(5).map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.primaryPink,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              insight,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final bool isDark;
  
  BackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                AppTheme.darkBackground,
                AppTheme.darkSurface,
                AppTheme.darkSurfaceVariant,
              ]
            : [
                AppTheme.lightBackground,
                AppTheme.lightSurface,
                AppTheme.lightSurfaceVariant,
              ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Grid pattern
    final gridPaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.02)
          : Colors.black.withOpacity(0.02)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}