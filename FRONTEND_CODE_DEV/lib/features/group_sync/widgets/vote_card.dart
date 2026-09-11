import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/group_models.dart';

class VoteCard extends StatelessWidget {
  final Proposal proposal;
  final bool selected;
  final VoidCallback onTap;

  const VoteCard({super.key, required this.proposal, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.rust : AppColors.ink, width: selected ? 2 : 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(proposal.title, style: AppTextStyles.bodyStrong.copyWith(fontSize: 14)),
                Text('${proposal.votes}/${proposal.totalVoters}', style: AppTextStyles.label.copyWith(fontSize: 10.5)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: proposal.ratio,
                minHeight: 8,
                backgroundColor: AppColors.line,
                color: selected ? AppColors.rust : AppColors.pine,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
