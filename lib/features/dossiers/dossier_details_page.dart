import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/dossiers/export/export_bloc.dart';
import 'package:finoco/features/dossiers/export/export_event.dart';
import 'package:finoco/features/dossiers/export/export_state.dart';
import 'package:finoco/features/iteration/add_transaction_screen.dart';
import 'package:finoco/features/iteration/paiements_screen.dart';
import 'package:finoco/features/iteration/pdf_view.dart';
import 'package:finoco/features/iteration/services_screen.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DossierDetails extends StatefulWidget {
  final Dossier dossier;
  const DossierDetails({Key key, this.dossier}) : super(key: key);

  @override
  State<DossierDetails> createState() => _DossierDetailsState();
}

class _DossierDetailsState extends State<DossierDetails> {
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
    return BlocListener<ExportBloc, ExportState>(
      listener: (context, state) async {
        if (EasyLoading.isShow) {
          await EasyLoading.dismiss();
        }
        if (state is ExportsLoading) {
          await EasyLoading.show(
            dismissOnTap: false,
            indicator: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Loading',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is ExportsLoaded) {
          clientNavigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => PDFViewerPage(
              pdf: state.file,
              name: widget.dossier.name + '.pdf',
            ),
          ));
        }
      },
      child: DefaultTabController(
        length: 2,
        child: ScaffoldHeader(
          title: widget.dossier.name,
          showBackButton: true,
          titleLineWidget: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.local_print_shop_outlined),
                  onPressed: () => context
                      .read<ExportBloc>()
                      .add(ExportDossier(widget.dossier.id))),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () => clientNavigatorKey.currentState.push(
                  MaterialPageRoute(
                    builder: (context) => AddTransactonScreen(
                      dossier: widget.dossier,
                      typeTransaction: currentIndex == 0
                          ? TypeTransaction.SERVICE
                          : TypeTransaction.PAIEMENT,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              tabs: ['Services', 'Paiements']
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
              ServicesScreen(
                dossier: widget.dossier,
              ),
              PaiementsScreen(
                dossier: widget.dossier,
              )
            ],
          ),
        ),
      ),
    );
  }
}
