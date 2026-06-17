import 'package:flutter/widgets.dart';

class DeviceItem {
  const DeviceItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.isActive,
  });

  final int id;
  final String name;
  final IconData icon;
  final bool isActive;

  DeviceItem copyWith({bool? isActive}) => DeviceItem(
        id: id,
        name: name,
        icon: icon,
        isActive: isActive ?? this.isActive,
      );
}

class DevicesState {
  const DevicesState(this.devices);

  final List<DeviceItem> devices;

  int get activeCount => devices.where((d) => d.isActive).length;

  DevicesState toggle(final int id) => DevicesState(
        devices
            .map((d) => d.id == id ? d.copyWith(isActive: !d.isActive) : d)
            .toList(),
      );
}
