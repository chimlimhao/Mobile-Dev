import 'package:flutter/material.dart';
import 'package:jobglide/services/auth_service.dart';

class JobAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onFilterPressed;

  const JobAppBar({
    super.key,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AutoApplyButton(),
          const JobGlideTitle(),
          FilterButton(onPressed: onFilterPressed),
        ],
      ),
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

class FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FilterButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.purple,
      icon: const Icon(Icons.tune),
      onPressed: onPressed,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
      iconSize: 24,
    );
  }
}
