part of '../live_map_screen.dart';

class _MapTelemetryFilters extends StatelessWidget {
  const _MapTelemetryFilters({
    required this.selectedFilter,
    required this.allCount,
    required this.runningCount,
    required this.stopCount,
    required this.inactiveCount,
    required this.onSelected,
  });

  final _MapFilter selectedFilter;
  final int allCount;
  final int runningCount;
  final int stopCount;
  final int inactiveCount;
  final ValueChanged<_MapFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TelemetryCircleButton(
          label: 'All',
          count: allCount,
          isSelected: selectedFilter == _MapFilter.all,
          onTap: () => onSelected(_MapFilter.all),
        ),
        const SizedBox(width: 6),
        _TelemetryCircleButton(
          label: 'Running',
          count: runningCount,
          isSelected: selectedFilter == _MapFilter.running,
          onTap: () => onSelected(_MapFilter.running),
        ),
        const SizedBox(width: 6),
        _TelemetryCircleButton(
          label: 'Stop',
          count: stopCount,
          isSelected: selectedFilter == _MapFilter.stop,
          onTap: () => onSelected(_MapFilter.stop),
        ),
        const SizedBox(width: 6),
        _TelemetryCircleButton(
          label: 'Inactive',
          count: inactiveCount,
          isSelected: selectedFilter == _MapFilter.inactive,
          onTap: () => onSelected(_MapFilter.inactive),
        ),
      ],
    );
  }
}

class _TelemetryCircleButton extends StatelessWidget {
  const _TelemetryCircleButton({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: isSelected ? scheme.onSurface : scheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? scheme.onSurface : scheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? scheme.surface : scheme.onSurface,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? scheme.surface.withValues(alpha: 0.92)
                      : scheme.onSurfaceVariant,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomDrawerButton extends StatelessWidget {
  const _BottomDrawerButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: scheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: scheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 22,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
