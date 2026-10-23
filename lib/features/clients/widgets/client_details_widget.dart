import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/models/statistiques.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:flutter/material.dart';

class ClientDetailsWidget extends StatelessWidget {
  const ClientDetailsWidget({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      scrollable: true,
      insetPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(
                  client.fullName,
                  style: AppThemes.sectionTitleTextStyle,
                ),
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close))
              ],
            ),
            _buildRowTitleAndSelectableText(
                'Date création', client.createdAt.toString().split(' ').first),
            _buildRowTitleAndSelectableText('E-mail', client.email ?? '-'),
            _buildRowTitleAndSelectableText('Téléphone', client.phone ?? '-'),
            _buildRowTitleAndSelectableText('Adresse', client.address ?? '-'),
            _buildRowTitleAndSelectableText('Remarques', client.notes ?? '-'),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<Statistiques>(
              future: DatabaseHelper.instance.getStatsByClient(client.id!),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const SizedBox();
                }
                return Column(
                  children: [
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
                              SelectableText(
                                'Tous dossiers :',
                                style: AppThemes.titleTextStyle,
                              ),
                              SelectableText(
                                'TND',
                                style: AppThemes.monnaieTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SelectableText(
                                'Débit :',
                                style: AppThemes.kbirShwyTextStyle,
                              ),
                              SelectableText(
                                snap.data!.totaleServices.toStringAsFixed(0),
                                style: AppThemes.monnaieTextStyle
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SelectableText(
                                'Crédit :',
                                style: AppThemes.kbirShwyTextStyle,
                              ),
                              SelectableText(
                                  snap.data!.totalePaiements
                                      .toInt()
                                      .toStringAsFixed(0),
                                  style: AppThemes.monnaieTextStyle
                                      .copyWith(color: Colors.red))
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SelectableText(
                                'Balance :',
                                style: AppThemes.kbirShwyTextStyle,
                              ),
                              SelectableText(
                                  (snap.data!.totaleServices -
                                          snap.data!.totalePaiements)
                                      .toStringAsFixed(0),
                                  style: (snap.data!.totaleServices -
                                              snap.data!.totalePaiements)
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
                    Container(
                      margin: const EdgeInsets.only(top: 20),
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
                            children: const [
                              SelectableText(
                                'Devises :',
                                style: AppThemes.titleTextStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: snap.data!.montantDevises
                                  .map(
                                    (e) => SelectableText(
                                        e.montant.toStringAsFixed(0) +
                                            ' ' +
                                            e.devise,
                                        style: e.montant.isNegative
                                            ? AppThemes.monnaieTextStyle
                                                .copyWith(color: Colors.red)
                                            : AppThemes.monnaieTextStyle),
                                  )
                                  .toList()),
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

  Padding _buildRowTitleAndSelectableText(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          SelectableText(
            '$title : ',
            style: AppThemes.kbirShwyTextStyle,
          ),
          SelectableText(
            text,
            style: AppThemes.regularTextStyle,
          ),
        ],
      ),
    );
  }

  // String formatWithCommas(int number) {
  //   // Convert the number to a string
  //   String numStr = number.toString();

  //   // Use a regular expression to add commas every three digits from the end
  //   String formatted = numStr.replaceAllMapped(
  //     RegExp(r'(\d)(?=(\d{3})+$)'),
  //     (Match match) => '${match[1]},',
  //   );

  //   return formatted;
  // }
}
