import 'package:flirt/core/module/home/application/service/cubit/home_cubit.dart';
import 'package:flirt/core/module/home/application/service/cubit/home_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardContainer extends StatefulWidget {
  const CardContainer({
    required this.color,
    required this.title,
    required this.onTap,
    super.key,
  });
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getCardEmoji() {
    switch (widget.title) {
      case '+3':
        return '🌟';
      case '+1':
        return '👍';
      case '-1':
        return '🏏';
      default:
        return '🗿';
    }
  }

  String _getCardSubtitle() {
    switch (widget.title) {
      case '+3':
        return 'GREAT HUNT!';
      case '+1':
        return 'GOOD TRY!';
      case '-1':
        return 'BONK!';
      default:
        return 'CAVE SPEAK';
    }
  }

  Color _getDarkerColor(Color color) {
    final int r = (color.toARGB32() >> 16) & 0xFF;
    final int g = (color.toARGB32() >> 8) & 0xFF;
    final int b = (color.toARGB32()) & 0xFF;

    return Color.fromRGBO(
      (r * 0.7).round(),
      (g * 0.7).round(),
      (b * 0.7).round(),
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color:
                          _getDarkerColor(widget.color).withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                      widget.onTap();
                    },
                    onTapDown: (_) => _animationController.forward(),
                    onTapUp: (_) => _animationController.reverse(),
                    onTapCancel: () => _animationController.reverse(),
                    splashColor: Colors.white.withValues(alpha: 0.3),
                    highlightColor: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getDarkerColor(widget.color),
                          width: 3,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            widget.color,
                            _getDarkerColor(widget.color),
                          ],
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          // Header section with emoji and title
                          Container(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  _getCardEmoji(),
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _getCardSubtitle(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider with cave painting style
                          Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),

                          // Word history section
                          Expanded(
                            child: BlocBuilder<HomeCubit, HomeState>(
                              buildWhen:
                                  (HomeState previous, HomeState current) =>
                                      current is FetchScoredWordsSuccess,
                              builder: (BuildContext context, HomeState state) {
                                if (state is FetchScoredWordsSuccess) {
                                  final List<Prompt> data = <Prompt>[];
                                  switch (widget.title) {
                                    case '+3':
                                      data.addAll(state.three);
                                    case '+1':
                                      data.addAll(state.one);
                                    case '-1':
                                      data.addAll(state.minusOne);
                                    default:
                                  }

                                  if (data.isEmpty) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '🪨',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white
                                                  .withValues(alpha: 0.7),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'NO WORDS\nYET',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white
                                                  .withValues(alpha: 0.8),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        alignment: WrapAlignment.center,
                                        children: data.map((Prompt item) {
                                          return _buildWordChip(item);
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '🏺',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'READY TO\nHUNT!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }

  Widget _buildWordChip(Prompt item) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5DC), // Beige parchment color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B4513), // Brown border
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            item.one.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D1810),
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            width: 30,
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(0.5),
            ),
          ),
          Text(
            item.three.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D1810),
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
