import 'package:flutter/material.dart';
import 'package:parking_project/pages/admin/accounts_request.dart';
import 'package:parking_project/pages/client/home_client_page.dart';
import 'package:parking_project/pages/client/navigation_bar.dart';
import 'package:parking_project/pages/login/login_screen.dart';
import 'package:parking_project/pages/login/register_screen.dart';
import 'package:parking_project/pages/map/map_client.dart';
import 'package:parking_project/pages/map/map_owner.dart';
import 'package:parking_project/pages/owner/form/request_data.dart';
import 'package:parking_project/pages/owner/form/request_type.dart';
import 'package:parking_project/pages/owner/home_owner_screen.dart';
import 'package:parking_project/pages/owner/navigation_owner.dart';
import 'package:parking_project/pages/owner/parqueo/registro_parqueo.dart';
import 'package:parking_project/pages/owner/plaza/create_place.dart';
import 'package:parking_project/routes/routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.registerScreen:
        final arguments = settings.arguments;
        if (arguments is List) {
          return MaterialPageRoute(
            builder: (_) => RegisterScreen(
              userType: arguments[0],
            ),
          );
        }
      
        // case Routes.ownerParkings:
        // return MaterialPageRoute(
        //   builder: (_) => const OwnerParkingsScreen(),
        // );


      case Routes.homeScreenAdmin:
        return MaterialPageRoute(
          builder: (_) => const AccountRequestScreen(),
        );
      case Routes.homeScreenClient:
        return MaterialPageRoute(
          builder: (_) => const HomeClient(),
        );

      case Routes.homeScreenOwner:
        return MaterialPageRoute(
          builder: (_) => const HomeOwner(),
        );

      case Routes.ownerMenuScreen:
      return MaterialPageRoute(
        builder: (_) => const MenuOwner(),
      );

      case Routes.clientMenuScreen:
      return MaterialPageRoute(
        builder: (_) => const MenuClient(),
      );

      case Routes.requestForm:
        final arguments = settings.arguments;
        if (arguments is List) {
          return MaterialPageRoute(
            builder: (_) => RequetFormScreen(
              userType: arguments[0],
            ),
          );
        }
        return null;

      case Routes.requestType:
        return MaterialPageRoute(
          builder: (_) => const TypeUserRequest(),
        );


      case Routes.registerParking:
        return MaterialPageRoute(
          builder: (_) => const RegistroParqueoScreen(),
        );


      case Routes.registerPlaceScreen:
        final arguments = settings.arguments;
        if (arguments is List) {
          return MaterialPageRoute(
            builder: (_) => CreatePlaceScreen(
              seccionRef: arguments[0],
            ),
          );
        }
        return null;

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );




      case Routes.mapClientScreen:
        return MaterialPageRoute(
          builder: (_) => const MapClient(),
        );


      case Routes.mapOwnerScreen:
        return MaterialPageRoute(
          builder: (_) => const MapOwner(),
        );
    }
    return null;
  }
}