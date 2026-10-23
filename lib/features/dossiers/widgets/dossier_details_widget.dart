import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/statistiques.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:flutter/material.dart';

class DossierDetailsWidget extends StatefulWidget {
  final Dossier? dossier;
  const DossierDetailsWidget({Key? key, this.dossier}) : super(key: key);

  @override
  State<DossierDetailsWidget> createState() => _DossierDetailsWidgetState();
}

class _DossierDetailsWidgetState extends State<DossierDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dossier!.name!,
                  style: AppThemes.sectionTitleTextStyle,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            _buildRowTitleAndText(
              'Date création',
              widget.dossier!.createdAt!.toIso8601String().substring(0, 10),
            ),
            _buildRowTitleAndText(
              'Devise',
              widget.dossier!.devise!,
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<Statistiques>(
              future:
                  DatabaseHelper.instance.getDossierStats(widget.dossier!.id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.dossier!.devise != 'TND') ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 15,
                                spreadRadius: 0,
                                color: const Color(0xffCDCDCD).withOpacity(.4)),
                          ],
                          color: AppColor.appSecondaryBackground,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Totale :',
                                  style: AppThemes.titleTextStyle,
                                ),
                                Text(
                                  widget.dossier!.devise!,
                                  style: AppThemes.monnaieTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Débit :',
                                  style: AppThemes.kbirShwyTextStyle,
                                ),
                                Text(
                                  snapshot.data!.totaleServices30
                                      .toStringAsFixed(0),
                                  style: AppThemes.monnaieTextStyle
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Crédit :',
                                  style: AppThemes.kbirShwyTextStyle,
                                ),
                                Text(
                                  snapshot.data!.totalePaiements30
                                      .toStringAsFixed(0),
                                  style: AppThemes.monnaieTextStyle
                                      .copyWith(color: Colors.red),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Balance :',
                                  style: AppThemes.kbirShwyTextStyle,
                                ),
                                Text(
                                    snapshot.data!.sommeDevise
                                        .toStringAsFixed(0),
                                    style: snapshot.data!.sommeDevise.isNegative
                                        ? AppThemes.monnaieTextStyle
                                            .copyWith(color: Colors.red)
                                        : AppThemes.monnaieTextStyle
                                            .copyWith(color: Colors.green))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 15,
                              spreadRadius: 0,
                              color: const Color(0xffCDCDCD).withOpacity(.4)),
                        ],
                        color: AppColor.appSecondaryBackground,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Totale :',
                                style: AppThemes.titleTextStyle,
                              ),
                              Text(
                                'TND',
                                style: AppThemes.monnaieTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Débit :',
                                style: AppThemes.kbirShwyTextStyle,
                              ),
                              Text(
                                snapshot.data!.totaleServices
                                    .toStringAsFixed(0),
                                style: AppThemes.monnaieTextStyle.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Crédit :',
                                style: AppThemes.kbirShwyTextStyle,
                              ),
                              Text(
                                snapshot.data!.totalePaiements
                                    .toStringAsFixed(0),
                                style: AppThemes.monnaieTextStyle
                                    .copyWith(color: Colors.red),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Balance :',
                                style: AppThemes.kbirShwyTextStyle,
                              ),
                              Text(
                                  (snapshot.data!.totaleServices -
                                          snapshot.data!.totalePaiements)
                                      .toStringAsFixed(0),
                                  style: (snapshot.data!.totaleServices -
                                              snapshot.data!.totalePaiements)
                                          .isNegative
                                      ? AppThemes.monnaieTextStyle
                                          .copyWith(color: Colors.red)
                                      : AppThemes.monnaieTextStyle
                                          .copyWith(color: Colors.green))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildRowTitleAndText(String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title : ',
          style: AppThemes.kbirShwyTextStyle,
        ),
        Text(
          text,
          style: AppThemes.regularTextStyle,
        ),
      ],
    );
  }
}
