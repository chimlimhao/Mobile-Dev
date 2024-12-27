import 'package:flutter/material.dart';
import 'package:jobglide/services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title = 'JobGlide',
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading ?? const SizedBox(width: 48),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (actions != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FilterButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune),
      onPressed: onPressed,
      tooltip: 'Filter jobs',
    );
  }
}

class JobAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onFilterPressed;

  const JobAppBar({
    super.key,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      backgroundColor: Colors.transparent,
      leading: const AutoApplyButton(),
      title: 'JobGlide',
      actions: [
        FilterButton(onPressed: onFilterPressed),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AutoApplyButton extends StatefulWidget {
  const AutoApplyButton({super.key});

  @override
  State<AutoApplyButton> createState() => _AutoApplyButtonState();
}

class _AutoApplyButtonState extends State<AutoApplyButton> {
  @override
  Widget build(BuildContext context) {
    final isEnabled = AuthService.isAutoApplyEnabled();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 65),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        child: Material(
          color: isEnabled ? const Color(0xFFFFF3E0) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                AuthService.setAutoApplyEnabled(!isEnabled);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEnabled
                        ? 'Auto-apply disabled. You\'ll need to save jobs first.'
                        : 'Auto-apply enabled. Swipe right to instantly apply!',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flash_on,
                    color: isEnabled
                        ? Colors.amber.shade600
                        : Colors.grey.shade400,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'Auto',
                    style: TextStyle(
                      color: isEnabled
                          ? Colors.amber.shade800
                          : Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JobGlideTitle extends StatelessWidget {
  const JobGlideTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'JobGlide',
      style: TextStyle(
        color: Colors.purple,
        fontSize: 24,
      ),
    );
  }
}
