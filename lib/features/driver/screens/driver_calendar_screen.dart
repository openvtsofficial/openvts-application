import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/helpers/mobile_text.dart';
import '../../../shared/widgets/open_vts_page_scaffold.dart';
import '../controllers/driver_providers.dart';
import 'driver_trips_screen.dart';
import 'driver_widgets.dart';

class DriverCalendarScreen extends ConsumerStatefulWidget {
  const DriverCalendarScreen({super.key});
  @override
  ConsumerState<DriverCalendarScreen> createState() =>
      _DriverCalendarScreenState();
}

class _DriverCalendarScreenState extends ConsumerState<DriverCalendarScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  @override
  Widget build(BuildContext context) {
    final provider = driverCalendarProvider(_month),
        calendar = ref.watch(driverCalendarProvider(_month));
    return OpenVtsPageScaffold(
      title: context.mobileText('Calendar'),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: context.mobileText('Previous month'),
                onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month - 1),
                ),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(
                    Localizations.localeOf(context).toLanguageTag(),
                  ).format(_month),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: context.mobileText('Next month'),
                onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month + 1),
                ),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              context.mobileText(
                'Completed trips by service date. Upcoming assignments are available in Trips.',
              ),
            ),
          ),
          Expanded(
            child: DriverAsyncBody(
              value: calendar,
              onRetry: () => ref.invalidate(provider),
              builder: (trips) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(provider);
                  await ref.read(provider.future);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (trips.isEmpty)
                      DriverEmpty(
                        context.mobileText('No completed trips this month.'),
                        icon: Icons.calendar_month_outlined,
                      ),
                    for (var i = 0; i < trips.length; i++) ...[
                      if (i == 0 ||
                          trips[i].serviceDate != trips[i - 1].serviceDate)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                          child: Text(
                            trips[i].serviceDate == null
                                ? context.mobileText('Date unavailable')
                                : DateFormat.yMMMEd(
                                    Localizations.localeOf(
                                      context,
                                    ).toLanguageTag(),
                                  ).format(trips[i].serviceDate!),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      DriverTripCard(
                        trip: trips[i],
                        onTap: () => openDriverTrip(context, trips[i].id),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
