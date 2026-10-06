import 'live_vehicle_presentation.dart';

/// Resolves the existing bundled icons using the web's type aliases and colors.
String liveVehicleIconAsset(String? vehicleType, LiveVehicleStatus status) {
  final slug = (vehicleType ?? '')
      .trim()
      .replaceAll(RegExp(r'[\s_]+'), '-')
      .replaceAll(RegExp('-+'), '-')
      .toLowerCase();
  const aliases = <String, String>{
    'aeroplane': 'airplane',
    'school-bus': 'schoolbus',
    'tector': 'tractor',
  };
  final compact = (aliases[slug] ?? slug).replaceAll('-', '');
  const types = <String>[
    'airplane',
    'ambulance',
    'bag',
    'bike',
    'boat',
    'bus',
    'car',
    'car2',
    'car3',
    'cat',
    'child',
    'concreteMixer',
    'consignment',
    'container',
    'crane',
    'cycle',
    'dog',
    'drone',
    'dustbinTruck',
    'eRickshaw',
    'employee',
    'fireVehicle',
    'girl',
    'golfCart',
    'helicopter',
    'jcb',
    'jeep',
    'loadingTempo',
    'miniTruck',
    'oilTanker',
    'person',
    'policeCar',
    'recyclingTruck',
    'schoolbus',
    'scooty',
    'securityGuard',
    'ship',
    'sportCar',
    'tampo',
    'tractor',
    'train',
    'truck',
    'truck2',
    'truck3',
    'van',
    'woman',
  ];
  String? type;
  for (final known in types) {
    if (known.toLowerCase() == compact) {
      type = known;
      break;
    }
  }
  if (type == null ||
      (status == LiveVehicleStatus.inactive &&
          const {'airplane', 'cat', 'consignment', 'dog'}.contains(type))) {
    return 'assets/images/vehicleicons/default.png';
  }
  final color = switch (status) {
    LiveVehicleStatus.running => 'Green',
    LiveVehicleStatus.stop => 'Red',
    LiveVehicleStatus.inactive => 'White',
  };
  return 'assets/images/vehicleicons/$type$color.png';
}
