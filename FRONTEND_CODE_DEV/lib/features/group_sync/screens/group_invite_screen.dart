import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/group_provider.dart';
import 'group_voting_screen.dart';

/// Screen 8 — Group Invite.
class GroupInviteScreen extends ConsumerStatefulWidget {
  final String tripId;
  final String inviteCode;
  const GroupInviteScreen({super.key, required this.tripId, required this.inviteCode});

  @override
  ConsumerState<GroupInviteScreen> createState() => _GroupInviteScreenState();
}

class _GroupInviteScreenState extends ConsumerState<GroupInviteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(groupProvider).loadMembers(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 24, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bring your crew', style: AppTextStyles.displayMedium),
                    Text('Anyone with the link can join and vote.', style: AppTextStyles.body),
                    const SizedBox(height: 26),
                    // QR placeholder — swap for a real QR generator package later.
                    Center(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          border: Border.all(color: AppColors.ink, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.qr_code_2, size: 90, color: AppColors.ink),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.ink, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('travelmate.app/t/${widget.inviteCode}', style: AppTextStyles.label.copyWith(color: AppColors.ink)),
                          Text('COPY', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.rust)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Already joined', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    if (state.isLoadingMembers)
                      const CircularProgressIndicator(color: AppColors.rust)
                    else
                      Row(
                        children: state.members
                            .map((m) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CircleAvatar(
                                        radius: 17,
                                        backgroundColor: AppColors.pine,
                                        child: Text(m.initial, style: AppTextStyles.label.copyWith(color: AppColors.cream)),
                                      ),
                                      Positioned(
                                        right: -1,
                                        bottom: -1,
                                        child: Container(
                                          width: 11,
                                          height: 11,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: m.isActive ? AppColors.mustard : AppColors.line,
                                            border: Border.all(color: AppColors.paper, width: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 6),
                    Text('● mustard = sharing location now', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.inkSoft)),
                    const Spacer(),
                    PrimaryButton(
                      label: 'Continue to voting',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => GroupVotingScreen(tripId: widget.tripId)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
