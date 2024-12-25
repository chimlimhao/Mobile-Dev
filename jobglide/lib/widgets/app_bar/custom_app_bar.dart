import 'package:flutter/material.dart';
import 'package:jobglide/services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title = 'JobGlide',
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
      centerTitle: centerTitle,
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Helper widget for filter button
class FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FilterButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
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
      centerTitle: true,
      actions: [
        FilterButton(onPressed: onFilterPressed),
        const AutoApplyButton(),
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
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.grey.shade100,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () {
              setState(() {
                AuthService.setAutoApplyEnabled(
                    !AuthService.isAutoApplyEnabled());
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flash_on,
                    color: AuthService.isAutoApplyEnabled()
                        ? Colors.amber.shade600
                        : Colors.grey.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Auto',
                    style: TextStyle(
                      color: AuthService.isAutoApplyEnabled()
                          ? Colors.grey.shade800
                          : Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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
        // fontWeight: FontWeight.bold,
      ),
    );
  }
}
