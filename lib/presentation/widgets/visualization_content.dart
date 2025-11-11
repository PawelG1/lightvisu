import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deckmate/lights2_widget.dart';
import 'package:deckmate/models/vessel_config.dart' as vc;
import 'package:deckmate/core/di/service_locator.dart';
import 'package:deckmate/data/repositories/visualization_repository_impl.dart';
import 'package:deckmate/presentation/cubit/visualization/visualization_cubit.dart';

class VisualizationContent extends StatelessWidget {
  final VisualizationLoaded state;

  const VisualizationContent({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Pobierz repository z GetIt (service locator), a nie z context.read (Provider)
    final repository = getIt<VisualizationRepositoryImpl>();
    final cubit = context.read<VisualizationCubit>();
    final currentVessel = repository.getVesselType(state.selectedVesselType);

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            _buildShipVisualization(currentVessel),
            SizedBox(height: 20),
            _buildHeadingDisplay(),
            SizedBox(height: 20),
            _buildHeadingSlider(context, cubit),
            SizedBox(height: 20),
            _buildPresetViewButtons(context, cubit),
            SizedBox(height: 20),
            _buildVesselTypeSelector(context, cubit),
            SizedBox(height: 20),
            _buildVesselInformation(currentVessel),
            SizedBox(height: 20),
            _buildVisualizationOptions(context, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildShipVisualization(vc.VesselType? currentVessel) {
    return Lights2Widget(
      angle: state.heading,
      showHull: state.showHull,
      showBowArrow: state.showBowArrow,
      vesselConfig: currentVessel,
      shipLength: 115.0,
      shipBeam: 24.0,
      shipHeight: 18.0,
    );
  }

  Widget _buildHeadingDisplay() {
    return Text(
      "Heading: ${state.heading.toStringAsFixed(1)}°",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHeadingSlider(BuildContext context, VisualizationCubit cubit) {
    return SizedBox(
      width: 400,
      child: Slider(
        min: 0,
        max: 360,
        divisions: 360,
        value: state.heading,
        onChanged: (val) {
          val = double.parse(val.toStringAsFixed(2));
          cubit.updateHeading(val);
        },
      ),
    );
  }

  Widget _buildPresetViewButtons(BuildContext context, VisualizationCubit cubit) {
    return Wrap(
      spacing: 8,
      children: [
        TextButton(
          onPressed: () => cubit.updateHeading(270.0),
          child: Text("Front View"),
        ),
        TextButton(
          onPressed: () => cubit.updateHeading(180.0),
          child: Text("Port Side"),
        ),
        TextButton(
          onPressed: () => cubit.updateHeading(0.0),
          child: Text("Starboard Side"),
        ),
        TextButton(
          onPressed: () => cubit.updateHeading(90.0),
          child: Text("Stern View"),
        ),
      ],
    );
  }

  Widget _buildVesselTypeSelector(BuildContext context, VisualizationCubit cubit) {
    return DropdownButton<String>(
      value: state.selectedVesselType,
      items: state.availableVesselTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          cubit.updateVesselType(value);
        }
      },
    );
  }

  Widget _buildVesselInformation(vc.VesselType? currentVessel) {
    if (currentVessel == null || currentVessel.notes.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vessel Information:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...currentVessel.notes.map((note) => Padding(
              padding: EdgeInsets.only(bottom: 4, left: 8),
              child: Text(
                '• $note',
                style: TextStyle(fontSize: 12),
                softWrap: true,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationOptions(BuildContext context, VisualizationCubit cubit) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: state.showHull,
                onChanged: (val) => cubit.toggleHull(),
              ),
              Text("Show Hull"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: state.showBowArrow,
                onChanged: (val) => cubit.toggleBowArrow(),
              ),
              Text("Show BOW Arrow"),
            ],
          ),
        ],
      ),
    );
  }
}
