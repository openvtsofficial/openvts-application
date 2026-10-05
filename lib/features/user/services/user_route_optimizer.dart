import 'dart:math' as math;
import '../models/user_route_stop.dart';

/// Matches the web's geographic-distance objective. This determines visiting
/// order only; OSRM independently calculates an actual drivable road path.
List<UserRouteStop> optimizeUserRouteStops(
  List<UserRouteStop> source, {
  required bool roundTrip,
}) {
  final points = source.where((point) => !point.isVia).toList();
  if (points.length < 3) return points;
  if (points.length > 100 || points.any((point) => !point.validCoordinates)) {
    throw ArgumentError('Invalid route stops');
  }
  final distances = List.generate(
    points.length,
    (i) => List.generate(points.length, (j) {
      final p = points[i], q = points[j];
      final dLat = (q.latitude - p.latitude) * math.pi / 180;
      final dLon = (q.longitude - p.longitude) * math.pi / 180;
      final a =
          math.pow(math.sin(dLat / 2), 2) +
          math.cos(p.latitude * math.pi / 180) *
              math.cos(q.latitude * math.pi / 180) *
              math.pow(math.sin(dLon / 2), 2);
      return 6371000 * 2 * math.asin(math.sqrt(a.clamp(0, 1)));
    }),
  );
  final order = points.length <= 12
      ? _exact(distances, roundTrip)
      : _heuristic(distances, roundTrip);
  return order.map((i) => points[i]).toList();
}

List<int> _exact(List<List<double>> d, bool roundTrip) {
  final n = d.length, full = (1 << d.length) - 1;
  final costs = List.generate(full + 1, (_) => List.filled(n, double.infinity));
  final parent = List.generate(full + 1, (_) => List.filled(n, -1));
  costs[1][0] = 0;
  for (var mask = 1; mask <= full; mask++) {
    for (var last = 0; last < n; last++) {
      if (!costs[mask][last].isFinite) continue;
      for (var next = 1; next < n; next++) {
        if ((mask & (1 << next)) != 0) continue;
        final nextMask = mask | (1 << next),
            cost = costs[mask][last] + d[last][next];
        if (cost < costs[nextMask][next]) {
          costs[nextMask][next] = cost;
          parent[nextMask][next] = last;
        }
      }
    }
  }
  var last = n - 1;
  if (roundTrip) {
    for (var i = 1; i < n; i++) {
      if (costs[full][i] + d[i][0] < costs[full][last] + d[last][0]) last = i;
    }
  }
  var mask = full;
  final result = <int>[];
  while (last >= 0) {
    result.add(last);
    final previous = parent[mask][last];
    mask ^= 1 << last;
    last = previous;
  }
  return result.reversed.toList();
}

List<int> _heuristic(List<List<double>> d, bool roundTrip) {
  final n = d.length, fixedEnd = roundTrip ? -1 : d.length - 1;
  final remaining = {
    for (var i = 1; i < n; i++)
      if (i != fixedEnd) i,
  };
  final greedy = <int>[0];
  while (remaining.isNotEmpty) {
    final next = remaining.reduce(
      (a, b) => d[greedy.last][a] <= d[greedy.last][b] ? a : b,
    );
    greedy.add(next);
    remaining.remove(next);
  }
  if (!roundTrip) greedy.add(fixedEnd);
  double cost(List<int> order) {
    var value = 0.0;
    for (var i = 1; i < n; i++) {
      value += d[order[i - 1]][order[i]];
    }
    if (roundTrip) value += d[order.last][order.first];
    return value;
  }

  final original = List.generate(n, (i) => i);
  var order = cost(greedy) < cost(original) ? greedy : original;
  for (var pass = 0; pass < 40; pass++) {
    var improved = false;
    for (var i = 1; i < n - 1; i++) {
      for (var j = i + 1; j < (roundTrip ? n : n - 1); j++) {
        final a = order[i - 1],
            b = order[i],
            c = order[j],
            next = order[(j + 1) % n];
        if (d[a][c] + d[b][next] + 0.001 < d[a][b] + d[c][next]) {
          order = [
            ...order.take(i),
            ...order.sublist(i, j + 1).reversed,
            ...order.skip(j + 1),
          ];
          improved = true;
        }
      }
    }
    if (!improved) break;
  }
  return order;
}
