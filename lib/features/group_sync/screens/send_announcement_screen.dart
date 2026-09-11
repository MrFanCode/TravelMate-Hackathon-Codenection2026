import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/announcement_provider.dart';

/// Compose a one-way broadcast to the group. Quick-pick presets cover
/// the common case; free text for anything else.
class SendAnnouncementScreen extends ConsumerStatefulWidget {
  final String tripId;
  const SendAnnouncementScreen({super.key, required this.tripId});

  @override
  ConsumerState<SendAnnouncementScreen> createState() => _SendAnnouncementScreenState();
}

class _SendAnnouncementScreenState extends ConsumerState<SendAnnouncementScreen> {
  final _controller = TextEditingController();

  static const _presets = [
    'Leaving in 5 minutes — meet at the lobby',
    "Running 10 min late, don't wait for me",
    'Change of plan — meet at the entrance instead',
    "I'm heading back to the hotel",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(announcementProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close, color: AppColors.ink),
                  ),
                  Text('Announce', style: AppTextStyles.eyebrow),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tell the group something', style: AppTextStyles.displayMedium.copyWith(fontSize: 22)),
                    Text('One-way — this isn\'t a chat, just a heads up.', style: AppTextStyles.body),
                    const SizedBox(height: 16),
                    Text('Quick picks', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    ..._presets.map((p) => _presetChip(p)),
                    const SizedBox(height: 14),
                    Text('Or write your own', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.ink, width: 1.5),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: 3,
                        style: AppTextStyles.body.copyWith(color: AppColors.ink, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintText: 'Type a message…',
                        ),
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: state.isSending ? 'Sending…' : 'Send to group',
                      onPressed: state.isSending || _controller.text.trim().isEmpty
                          ? null
                          : () async {
                              await ref.read(announcementProvider).send(widget.tripId, _controller.text.trim());
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Announcement sent.')),
                                );
                                Navigator.of(context).maybePop();
                              }
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

  Widget _presetChip(String text) {
    return InkWell(
      onTap: () => setState(() => _controller.text = text),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.pine, width: 1.5),
        ),
        child: Text(text, style: AppTextStyles.bodyStrong.copyWith(fontSize: 12.5)),
      ),
    );
  }
}
