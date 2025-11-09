import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import '../models/loan_type.dart';
import '../navigation/app_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

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

    final loanTypes = LoanType.allTypes;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPainter(),
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
                    child: _buildFloatingOrb(size: 120, color: Color(0xFF667eea)),
                  ),
                  Positioned(
                    bottom: 200 - _floatingAnimation.value,
                    left: -20,
                    child: _buildFloatingOrb(size: 160, color: Color(0xFFf093fb)),
                  ),
                  Positioned(
                    top: size.height * 0.4 + _floatingAnimation.value * 0.5,
                    right: -40,
                    child: _buildFloatingOrb(size: 100, color: Color(0xFF4ECDC4)),
                  ),
                ],
              );
            },
          ),

          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Ultra Modern App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.history, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.chatHistory);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.settings);
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF667eea).withOpacity(0.3),
                          Color(0xFF764ba2).withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 50, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Hero(
                                  tag: 'app_icon',
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF667eea).withOpacity(0.5),
                                          blurRadius: 20,
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
                                        child: const Text(
                                          "AI-Powered Assistant",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [Color(0xFFf093fb), Color(0xFF667eea)],
                                        ).createShader(bounds),
                                        child: const Text(
                                          "Loan Advisor",
                                          style: TextStyle(
                                            fontSize: 34,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -1,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Modern Section Header
                      _buildModernSectionHeader('Select Loan Type', Icons.apps_rounded),
                      const SizedBox(height: 20),
                      
                      // Premium Loan Cards
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.4,
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
                                                Color(0xFF1A1A2E),
                                                Color(0xFF16213E),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: isSelected
                                            ? loanColor.withOpacity(0.5)
                                            : Colors.white.withOpacity(0.05),
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
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
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
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
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

                      // Quick Actions Section
                      _buildModernSectionHeader('Quick Actions', Icons.flash_on),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              'EMI Calculator',
                              Icons.calculate,
                              Color(0xFF667eea),
                              () => Navigator.pushNamed(context, AppRouter.emiCalculator),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              'Eligibility',
                              Icons.verified_user,
                              Color(0xFFf093fb),
                              () => Navigator.pushNamed(context, AppRouter.loanEligibility),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              'Compare Loans',
                              Icons.compare_arrows,
                              Color(0xFF4ECDC4),
                              () => Navigator.pushNamed(context, AppRouter.loanComparison),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              'Documents',
                              Icons.folder_open,
                              Color(0xFFFFB84D),
                              () => Navigator.pushNamed(context, AppRouter.documentChecklist),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildQuickActionCard(
                        context,
                        'Loan Tips & Advice',
                        Icons.lightbulb_outline,
                        Color(0xFFFFD700),
                        () => Navigator.pushNamed(context, AppRouter.loanTips),
                        fullWidth: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              'Amortization',
                              Icons.table_chart,
                              Color(0xFF667eea),
                              () => Navigator.pushNamed(context, AppRouter.amortizationSchedule),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildQuickActionCard(
                              context,
                              'Prepayment',
                              Icons.trending_down,
                              Color(0xFF4ECDC4),
                              () => Navigator.pushNamed(context, AppRouter.prepaymentCalculator),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildQuickActionCard(
                        context,
                        'Banks & NBFCs',
                        Icons.account_balance,
                        Color(0xFFf093fb),
                        () => Navigator.pushNamed(context, AppRouter.bankDirectory),
                        fullWidth: true,
                      ),

                      const SizedBox(height: 40),

                      // Question Section
                      _buildModernSectionHeader('Your Question', Icons.chat_bubble_outline),
                      const SizedBox(height: 20),
                      
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: TextField(
                                    onChanged: vm.setQuery,
                                    maxLines: 5,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Ask anything about ${vm.loanType.toLowerCase()}...',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.3),
                                        fontSize: 15,
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
                                        color: Colors.white.withOpacity(0.1),
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
                                              color: Colors.white.withOpacity(0.5),
                                              size: 16,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Be specific',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.5),
                                                fontSize: 11,
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
                                                      colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                                                    ),
                                                    borderRadius: BorderRadius.circular(14),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0xFFFF6B6B).withOpacity(0.4),
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
                                                        : [Color(0xFF667eea), Color(0xFF764ba2)],
                                                  ),
                                                  borderRadius: BorderRadius.circular(14),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF667eea).withOpacity(0.4),
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
                                                      vm.isLoading ? 'Processing' : 'Ask AI',
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
                                    ),
                                    const SizedBox(height: 20),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 500),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF667eea).withOpacity(0.1),
                                                Color(0xFF764ba2).withOpacity(0.05),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(28),
                                            border: Border.all(
                                              color: Color(0xFF667eea).withOpacity(0.2),
                                              width: 1.5,
                                            ),
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
                                                              Color(0xFF667eea),
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
                                                              color: Color(0xFFFF6B6B),
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
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.7),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      "Tap the stop icon to cancel",
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.4),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
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
                                                      textStyle: TextStyle(
                                                        fontSize: 15,
                                                        height: 1.8,
                                                        color: Colors.white.withOpacity(0.9),
                                                        fontWeight: FontWeight.w400,
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
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildModernSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF667eea).withOpacity(0.4),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
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
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F0F1E),
          Color(0xFF1A1A2E),
          Color(0xFF16213E),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Grid pattern
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
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