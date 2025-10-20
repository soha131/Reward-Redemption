import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Core/reward_cubit.dart';
import '../Core/reward_state.dart';
import '../Models/reward_model.dart';

class RewardDetailsScreen extends StatelessWidget {
  final Reward reward;

  const RewardDetailsScreen({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RewardCubit, RewardState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: const EdgeInsets.all(16),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: state.message!.contains("redeemed")
                  ? Colors.teal.shade600
                  : Colors.redAccent,
              content: Row(
                children: [
                  Icon(
                    state.message!.contains("redeemed")
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.message!,
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
          context.read<RewardCubit>().clearMessage();

          if (state.message!.contains("redeemed")) {
            Future.delayed(const Duration(milliseconds: 800), () {
              Navigator.pop(context);
            });
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: reward.name,
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(reward.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        reward.name,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.teal.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Cost: ${reward.cost} points",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<RewardCubit, RewardState>(
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: state.isLoading
                                ? const CircularProgressIndicator(
                              key: ValueKey("loading"),
                              color: Colors.teal,
                            )
                                : ElevatedButton(
                              key: const ValueKey("button"),
                              onPressed: () async {
                                HapticFeedback.mediumImpact();
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Confirm Redemption",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Redeem ${reward.name} for ${reward.cost} points?",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context, false),
                                                child: Text(
                                                  "Cancel",
                                                  style:
                                                  GoogleFonts.poppins(
                                                      color: Colors
                                                          .grey),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                  Colors.teal,
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context, true),
                                                child: Text(
                                                  "Redeem",
                                                  style:
                                                  GoogleFonts.poppins(
                                                      color: Colors
                                                          .white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                if (confirm == true) {
                                  context.read<RewardCubit>().redeem(reward);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                const Size(double.infinity, 60),
                                backgroundColor: Colors.teal.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "Redeem Now",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
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
    );
  }
}