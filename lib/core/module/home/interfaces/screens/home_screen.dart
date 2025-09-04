import 'package:flirt/core/module/home/application/service/cubit/home_cubit.dart';
import 'package:flirt/core/module/home/application/service/cubit/home_dto.dart';
import 'package:flirt/core/module/home/interfaces/widgets/card_container.dart';
import 'package:flirt/core/module/home/interfaces/widgets/prompt_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Prompt currentPrompt;
  late AnimationController _bounceController;
  late AnimationController _wiggleController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchPrompt();

    // Setup animations
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _wiggleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticInOut,
    ));

    _wiggleAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _wiggleController,
      curve: Curves.easeInOut,
    ));

    // Start continuous animations
    _bounceController.repeat(reverse: true);
    _wiggleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFE8D5B7), // Light cave wall
              Color(0xFFD4B896), // Medium cave wall
              Color(0xFFC4A574), // Dark cave wall
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Header section with cave painting style
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    // Title with stone age font effect
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFF654321),
                          width: 3,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _wiggleAnimation,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.rotate(
                            angle: _wiggleAnimation.value,
                            child: const Text(
                              '🗿 Poetry For Neanderthals 🗿',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2D1810),
                                letterSpacing: 2,
                                shadows: <Shadow>[
                                  Shadow(
                                    color: Colors.white54,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Score display with bone decoration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('🦴', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5DC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF8B4513), width: 2),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: BlocBuilder<HomeCubit, HomeState>(
                            buildWhen:
                                (HomeState previous, HomeState current) =>
                                    current is UpdatePointsSuccess ||
                                    current is NewGameSuccess,
                            builder: (BuildContext context, HomeState state) {
                              return AnimatedBuilder(
                                animation: _bounceAnimation,
                                builder: (BuildContext context, Widget? child) {
                                  return Transform.scale(
                                    scale: state is UpdatePointsSuccess
                                        ? _bounceAnimation.value
                                        : 1.0,
                                    child: Text(
                                      state is UpdatePointsSuccess
                                          ? 'POINTS: ${state.points} 🍖'
                                          : 'POINTS: 0 🍖',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2D1810),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('🦴', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ),
              // New game button with club design
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black54,
                  ),
                  onPressed: () {
                    context.read<HomeCubit>().newGame();
                  },
                  label: const Text(
                    'New Game',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              // Prompt card section with cave painting frame
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (HomeState previous, HomeState current) =>
                        current is FetchPromptSuccess,
                    builder: (BuildContext context, HomeState state) {
                      if (state is FetchPromptSuccess) {
                        currentPrompt = state.data;
                        return _buildCaveFrame(PromptCard(data: state.data));
                      }
                      return _buildCaveFrame(
                        PromptCard(data: Prompt(one: '', three: '')),
                      );
                    },
                  ),
                ),
              ),

              // Scoring cards section with prehistoric styling
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CardContainer(
                      onTap: () {
                        context.read<HomeCubit>().updatePoints(
                              currentPrompt: currentPrompt,
                              score: 3,
                            );
                      },
                      color: const Color(0xFF4CAF50),
                      title: '+3',
                    ),
                    CardContainer(
                      onTap: () {
                        context.read<HomeCubit>().updatePoints(
                              currentPrompt: currentPrompt,
                              score: 1,
                            );
                      },
                      color: const Color(0xFFFF9800),
                      title: '+1',
                    ),
                    CardContainer(
                      onTap: () {
                        context.read<HomeCubit>().updatePoints(
                              currentPrompt: currentPrompt,
                              score: -1,
                            );
                      },
                      color: const Color(0xFFF44336),
                      title: '-1',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaveFrame(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8B4513).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF654321),
          width: 4,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5DC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFDEB887),
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}
