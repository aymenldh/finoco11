import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is StatsSuccess) {
          return ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                          'Totale : ',
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
                          state.statistiques.totaleServices.toStringAsFixed(0),
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
                          state.statistiques.totalePaiements.toStringAsFixed(0),
                          style: AppThemes.monnaieTextStyle
                              .copyWith(color: Colors.red),
                        )
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
                          (state.statistiques.totaleServices -
                                  state.statistiques.totalePaiements)
                              .toStringAsFixed(0),
                          style: AppThemes.monnaieTextStyle.copyWith(
                              color: (state.statistiques.totaleServices -
                                          state.statistiques.totalePaiements)
                                      .isNegative
                                  ? Colors.red
                                  : Colors.green),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                          'Totale devises :',
                          style: AppThemes.titleTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                        direction: Axis.horizontal,
                        spacing: 30,
                        children: state.statistiques.montantDevises
                            .map(
                              (e) => SelectableText(
                                  e.montant.toStringAsFixed(0) +
                                      ' ' +
                                      e.devise.toString(),
                                  style: e.montant.isNegative
                                      ? AppThemes.monnaieTextStyle
                                          .copyWith(color: Colors.red)
                                      : AppThemes.monnaieTextStyle),
                            )
                            .toList()),
                  ],
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 20),
              //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              //   decoration: BoxDecoration(
              //     boxShadow: [
              //       BoxShadow(
              //           offset: const Offset(0, 4),
              //           blurRadius: 15,
              //           spreadRadius: 0,
              //           color: const Color(0xffCDCDCD).withOpacity(.4)),
              //     ],
              //     color: AppColor.appSecondaryBackground,
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: const [
              //           SelectableText(
              //             '30 derniers jours ?',
              //             style: AppThemes.titleTextStyle,
              //           ),
              //           SelectableText(
              //             'TND',
              //             style: AppThemes.monnaieTextStyle,
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 15),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const SelectableText(
              //             'Débit :',
              //             style: AppThemes.kbirShwyTextStyle,
              //           ),
              //           SelectableText(
              //             formatWithCommas(state.statistiques.totaleServices30.toInt()),
              //             style: AppThemes.monnaieTextStyle,
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 5),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const SelectableText(
              //             'Crédit :',
              //             style: AppThemes.kbirShwyTextStyle,
              //           ),
              //           SelectableText(
              //             formatWithCommas(state.statistiques.totalePaiements30.toInt()),
              //             style: AppThemes.monnaieTextStyle,
              //           )
              //         ],
              //       ),
              //       const SizedBox(height: 5),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const SelectableText(
              //             'Balance :',
              //             style: AppThemes.kbirShwyTextStyle,
              //           ),
              //           SelectableText(
              //             formatWithCommas((state.statistiques.totaleServices30 -
              //                     state.statistiques.totalePaiements30)
              //                 .toInt()),
              //             style: AppThemes.monnaieTextStyle,
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
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
