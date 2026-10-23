// import 'package:finoco/features/home/bloc/home_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// 
// import '../../../core/shared/widgets/button_raised.dart';
// import '../../driver/screens/driver_add.dart';
// import '../../vehicle/vehicle_add/vehicle_add.dart';

// class FleetsButtomNavButton extends StatefulWidget {
//   const FleetsButtomNavButton() : super(key: key);

//   @override
//   State<FleetsButtomNavButton> createState() => _FleetsButtomNavButtonState();
// }

// class _FleetsButtomNavButtonState extends State<FleetsButtomNavButton> {
//   
//   @override
//   void initState() {
//     
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
//       if (state.tabIndex == 1) {
//         return ButtonRaised(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const DriverAddPage(),
//               ),
//             );
//           },
//           title: newDriver,
//         );
//       } else {
//         return ButtonRaised(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const AddNewVehicle(
//                   id: "fleetID", //TODO
//                 ),
//               ),
//             );
//           },
//           title: newVehicle,
//         );
//       }
//     });
//   }
// }
