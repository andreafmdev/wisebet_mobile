import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../domain/models/guide.dart';

class GuideDetailPage extends ConsumerWidget {
  final String guideId;

  const GuideDetailPage({
    super.key,
    required this.guideId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesRepo = ref.watch(guidesRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guida'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: FutureBuilder<Guide?>(
          future: guidesRepo.getGuideById(guideId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Guida non trovata'));
            }

            final guide = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.title,
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          guide.description,
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${guide.estimatedReadTime} minuti di lettura',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: _MarkdownContent(content: guide.content),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MarkdownContent extends StatelessWidget {
  final String content;

  const _MarkdownContent({required this.content});

  @override
  Widget build(BuildContext context) {
    // Simple markdown parser (per MVP)
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 16));
        continue;
      }

      if (line.startsWith('# ')) {
        widgets.add(
          Text(
            line.substring(2),
            style: AppTextStyles.h2,
          ),
        );
        widgets.add(const SizedBox(height: 8));
      } else if (line.startsWith('## ')) {
        widgets.add(
          Text(
            line.substring(3),
            style: AppTextStyles.h3,
          ),
        );
        widgets.add(const SizedBox(height: 8));
      } else if (line.startsWith('- ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppColors.accentGold)),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: AppTextStyles.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith('**') && line.endsWith('**')) {
        widgets.add(
          Text(
            line.substring(2, line.length - 2),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        widgets.add(const SizedBox(height: 8));
      } else {
        widgets.add(
          Text(
            line,
            style: AppTextStyles.bodyLarge,
          ),
        );
        widgets.add(const SizedBox(height: 8));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

