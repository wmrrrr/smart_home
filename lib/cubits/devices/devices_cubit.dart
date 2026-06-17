import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/cubits/devices/devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit()
      : super(const DevicesState([
          DeviceItem(id: 0, name: 'Освітлення', icon: Icons.lightbulb_outline, isActive: true),
          DeviceItem(id: 1, name: 'Термостат', icon: Icons.thermostat, isActive: false),
          DeviceItem(id: 2, name: 'Камера', icon: Icons.videocam_outlined, isActive: true),
          DeviceItem(id: 3, name: 'Замок', icon: Icons.lock_outline, isActive: false),
          DeviceItem(id: 4, name: 'Вентиляція', icon: Icons.air, isActive: false),
          DeviceItem(id: 5, name: 'Розетка', icon: Icons.electrical_services, isActive: true),
        ]));

  void toggle(final int id) => emit(state.toggle(id));
}
