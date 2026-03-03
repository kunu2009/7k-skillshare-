import 'package:flutter/material.dart';
import 'package:skillswap/config/app_theme.dart';

// Custom Loading Widget
class CustomLoadingWidget extends StatelessWidget {
  final String? message;

  const CustomLoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor,
            ),
          ),
          if (message != null) ...[
            SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Custom Error Widget
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.errorColor,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Custom Empty State Widget
class CustomEmptyWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const CustomEmptyWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Custom Snackbar Helper
class CustomSnackbar {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.infoColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Status Badge
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'online':
        return AppColors.onlineStatus;
      case 'offline':
        return AppColors.offlineStatus;
      case 'away':
        return AppColors.awayStatus;
      default:
        return AppColors.offlineStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: _getStatusColor()),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Rating Display
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingDisplay({
    Key? key,
    required this.rating,
    this.reviewCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: AppColors.warningColor,
            size: 16,
          );
        }),
        SizedBox(width: AppSpacing.sm),
        Text(
          '${rating.toStringAsFixed(1)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        if (reviewCount > 0) ...[
          SizedBox(width: AppSpacing.xs),
          Text(
            '($reviewCount)',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
