import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/dossiers/add_dossier/add_dossier_screen.dart';
import 'package:finoco/features/dossiers/widgets/dossier_fermer.dart';
import 'package:finoco/features/dossiers/widgets/dossier_ouvert.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';

class DossiersScreen extends StatefulWidget {
  final Client client;
  const DossiersScreen(this.client, {Key key}) : super(key: key);

  @override
  State<DossiersScreen> createState() => _DossiersScreenState();
}

class _DossiersScreenState extends State<DossiersScreen> {
  TextEditingController searchTEC = TextEditingController();
  int currentIndex = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ScaffoldHeader(
        title: widget.client.fullName,
        showBackButton: true,
        bottomAppbar: Container(
          height: 70,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: AppColor.appPrimaryBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TabBar(
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            labelColor: AppColor.sectionTitleColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            unselectedLabelColor: AppColor.darkGray,
            labelStyle: AppThemes.titleTextStyle,
            tabs: ['Ouvert', 'Clôturer']
                .map(
                  (e) => Tab(
                    child: Center(child: Text(e)),
                  ),
                )
                .toList(),
          ),
        ),
        child: TabBarView(
          children: [
            DossierOuvert(
              client: widget.client,
            ),
            DossierFermer(
              client: widget.client,
            ),
          ],
        ),
        titleLineWidget: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.add_circle,
              ),
              onPressed: () {
                clientNavigatorKey.currentState.push(MaterialPageRoute(
                  builder: (context) => AddDossierScreen(
                    client: widget.client,
                  ),
                ));
              },
            ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.star_border,
            //   ),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
