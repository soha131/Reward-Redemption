import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Core/reward_cubit.dart';
import '../Core/reward_state.dart';
import '../Models/reward_model.dart';
import 'reward_details_screen.dart';

class RewardsScreen extends StatelessWidget {
  RewardsScreen({super.key});

  final List<Reward> rewards = [
    Reward(
      name: "10% Off Coupon",
      imageUrl: "https://static.vecteezy.com/system/resources/thumbnails/023/429/736/small_2x/10-percent-off-3d-sign-sale-up-to-ten-percent-off-big-offer-sale-offer-label-sticker-banner-advertising-offer-icon-flasher-3d-illustration-png.png",
      cost: 100,
    ),
    Reward(
      name: "Free Coffee",
      imageUrl: "https://img.freepik.com/free-photo/coffee-is-poured-from-coffee-machine_140725-9182.jpg?semt=ais_hybrid",
      cost: 150,
    ),
    Reward(
      name: "Eco Tote Bag",
      imageUrl: "https://wasteless-group.com/wp-content/uploads/2023/07/Tote-Bag-Ecologique-Coton-1024x512.png",
      cost: 300,
    ),


  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Available Rewards",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade700, Colors.teal.shade400],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<RewardCubit, RewardState>(
                  builder: (context, state) {
                    double percent = (state.points / 500).clamp(0, 1);
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Container(
                        key: ValueKey(state.points),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade200.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 70,
                              lineWidth: 12,
                              percent: percent,
                              animation: true,
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.teal,
                              backgroundColor: Colors.teal.shade100,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star_rounded,
                                      color: Colors.amber.shade700, size: 30),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${state.points} pts",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.teal.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Level Progress",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.teal.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${(percent * 100).toStringAsFixed(0)}% of Goal",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.teal.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final reward = rewards[index];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 150)),
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset((1 - value) * 50, 0),
                        child: child,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RewardDetailsScreen(reward: reward),
                          ),
                        );
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade100.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Hero(
                              tag: reward.name,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  reward.imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                reward.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal.shade100,
                                    Colors.teal.shade200
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${reward.cost} pts",
                                style: GoogleFonts.poppins(
                                  color: Colors.teal.shade900,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: rewards.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
