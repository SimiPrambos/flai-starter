import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:template_vgv_app/core/error/failures.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';
import 'package:template_vgv_app/core/theme/app_spacing.dart';
import 'package:template_vgv_app/l10n/l10n.dart';
import 'package:template_vgv_app/shared/widgets/app_button.dart';
import 'package:template_vgv_app/shared/widgets/error_retry_widget.dart';

class PaginatedListPage<T> extends StatelessWidget {
  const PaginatedListPage({
    required this.title,
    required this.value,
    required this.itemBuilder,
    required this.skeletonItem,
    required this.onRefresh,
    required this.onLoadMore,
    required this.hasMore,
    this.skeletonCount = 6,
    this.actions,
    super.key,
  });

  final String title;
  final AsyncValue<List<T>> value;
  final Widget Function(T) itemBuilder;
  final Widget skeletonItem;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final int skeletonCount;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: value.when(
          skipLoadingOnReload: true,
          loading: () => Skeletonizer(
            effect: const ShimmerEffect(
              baseColor: AppColors.skeletonBase,
              highlightColor: AppColors.skeletonHighlight,
              duration: Duration(milliseconds: 1200),
            ),
            child: ListView.builder(
              itemCount: skeletonCount,
              itemBuilder: (_, _) => skeletonItem,
            ),
          ),
          error: (error, _) => ErrorRetryWidget(
            message: error is Failure
                ? error.readableMessage
                : error.toString(),
            onRetry: onRefresh,
          ),
          data: (items) {
            final isLoadingMore = value.isLoading && value.valueOrNull != null;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: items.length + 1,
              itemBuilder: (_, i) {
                if (i < items.length) return itemBuilder(items[i]);
                if (isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (hasMore) {
                  return Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: AppButton(
                      label: context.l10n.loadMore,
                      onPressed: onLoadMore,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
