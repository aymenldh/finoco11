import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/iteration.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_bloc.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_event.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_state.dart';
import 'package:finoco/features/iteration/pdf_view.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IterationDetails extends StatelessWidget {
  final Iteration iteration;
  const IterationDetails({Key key, this.iteration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AttachementsBloc>().add(LoadAttachementss(iteration.id));

    return ScaffoldHeader(
      title: 'Détail',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  iteration.name,
                  style: AppThemes.sectionTitleTextStyle,
                ),
                Text(
                  iteration.createdAt.toString().split(' ').first,
                  style: AppThemes.mediumTextStyle,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (iteration.devise != 'TND')
                  Text(
                    iteration.amountDevise.toStringAsFixed(0) +
                        ' ' +
                        iteration.devise,
                    style: AppThemes.monnaieTextStyle,
                  ),
                if (iteration.devise == 'TND') const SizedBox(),
                Text(
                  iteration.amountTND.toStringAsFixed(0) + ' TND',
                  style: AppThemes.monnaieTextStyle,
                ),
              ],
            ),
            if (iteration.devise != 'TND') ...[
              const SizedBox(
                height: 2.5,
              ),
              Text(
                'Taux : ' + iteration.taux.toStringAsFixed(0),
                style: AppThemes.mediumTextStyle,
              ),
              const SizedBox(
                height: 2.5,
              ),
              Text(
                'Opération : ' + iteration.operation,
                style: AppThemes.mediumTextStyle,
              ),
            ],
            const SizedBox(
              height: 25,
            ),
            Text(
              iteration.description ?? '',
              style: AppThemes.kbirShwyTextStyle,
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pièces jointes : ',
                    style: AppThemes.titleTextStyle,
                  ),
                ),
                IconButton(
                  onPressed: (() {}),
                  icon: const Icon(
                    Icons.attach_file,
                    color: AppColor.appSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<AttachementsBloc, AttachementsState>(
                builder: (context, state) {
                  if (state is AttachementssLoaded) {
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      children: state.attachements
                          .map(
                            (item) => InkWell(
                              onTap: () {
                                clientNavigatorKey.currentState
                                    .push(MaterialPageRoute(
                                  builder: (context) => PDFViewerPage(
                                    name: item.name,
                                    url: item.type.toLowerCase() == 'pdf'
                                        ? item.url
                                        : null,
                                    imageUrl: item.type.toLowerCase() != 'pdf'
                                        ? item.url
                                        : null,
                                  ),
                                ));
                              },
                              child: Card(
                                child: ListTile(
                                  leading: Icon(
                                    item.type != 'pdf'
                                        ? Icons.image
                                        : Icons.picture_as_pdf,
                                    color: item.type != 'pdf'
                                        ? AppColor.appPrimaryColor
                                        : AppColor.appSecondaryColor,
                                  ),
                                  title: Text(item.name,
                                      style: AppThemes.kbirShwyTextStyle),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  } else if (state is AttachementssError) {
                    return const Center(
                      child: Text('Erreur'),
                    );
                  } else if (state is AttachementssLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
