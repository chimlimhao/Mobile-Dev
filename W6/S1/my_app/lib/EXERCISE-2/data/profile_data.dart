import 'package:flutter/material.dart';
import 'package:my_app/EXERCISE-2/model/profile_tile_model.dart';

ProfileData ronanProfile = ProfileData(
    name: "Chim Limhao",
    position: "Flutter Developer",
    avatarUrl: 'assets/images/pfp.png',
    tiles: [
      TileData(
          icon: Icons.phone, title: "Phone Number", value: "+123 456 7890"),
      TileData(
          icon: Icons.location_on, title: "Address", value: "123 Cambodia"),
      TileData(icon: Icons.email, title: "Mail", value: "limhao.chim@cadt.edu"),
    ]);
