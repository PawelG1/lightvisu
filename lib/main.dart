import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightvisu/bloc/slider_cubit.dart';
import 'package:lightvisu/lights2_widget.dart';
import 'package:lightvisu/models/vessel_config_loader.dart';
import 'package:lightvisu/models/vessel_config.dart' as vc;
import 'package:lightvisu/quiz_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late SliderCubit sliderCubit;
  bool showHull = true;
  bool showBowArrow = true;
  String selectedVesselType = 'power_driven_underway_upto_50m';
  vc.VesselConfig? vesselConfig;
  List<String> availableVesselTypes = [];
  int _currentPage = 0; // 0 = Visualization, 1 = Quiz

  @override
  void initState() {
    super.initState();
    sliderCubit = SliderCubit(90);
    _loadVesselConfig();
  }

  Future<void> _loadVesselConfig() async {
    try {
      final config = await VesselConfigLoader.loadFromAssets('assets/vessel_config.json');
      final types = await VesselConfigLoader.getAvailableVesselTypes('assets/vessel_config.json');
      setState(() {
        vesselConfig = config;
        availableVesselTypes = types;
        if (types.isNotEmpty && !types.contains(selectedVesselType)) {
          selectedVesselType = types.first;
        }
      });
    } catch (e) {
      print('Error loading vessel config: $e');
    }
  }

  @override
  void dispose() {
    sliderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _currentPage == 0 ? _buildVisualizationPage() : QuizScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.sailing),
              label: 'Visualization',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'Quiz',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationPage() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            BlocBuilder(
              bloc: sliderCubit,
              builder: (context, state) {
                vc.VesselType? currentVessel;
                if (vesselConfig != null) {
                  currentVessel = vesselConfig!.vessels[selectedVesselType];
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Lights2Widget(
                        angle: state as double,
                        showHull: showHull,
                        showBowArrow: showBowArrow,
                        vesselConfig: currentVessel,
                        shipLength: 345.0,  // 115 * 3
                        shipBeam: 72.0,     // 24 * 3
                        shipHeight: 54.0,   // 18 * 3
                      ),
                      SizedBox(height: 20),
                      Text("Heading: ${(state).toStringAsFixed(1)}°"),
                      SizedBox(
                        width: 400,
                        child: Slider(
                          min: 0,
                          max: 360,
                          divisions: 360,
                          value: sliderCubit.state,
                          onChanged: (val) {
                            val = double.parse(val.toStringAsFixed(2));
                            sliderCubit.change(val);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton(onPressed: ()=>sliderCubit.change(270.0), child: Text("Front View")),
                          TextButton(onPressed: ()=>sliderCubit.change(180.0), child: Text("Port Side")),
                          TextButton(onPressed: ()=>sliderCubit.change(0.0), child: Text("Starboard Side")),
                          TextButton(onPressed: ()=>sliderCubit.change(90.0), child: Text("Stern View")),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (availableVesselTypes.isNotEmpty)
                        DropdownButton<String>(
                          value: selectedVesselType,
                          items: availableVesselTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedVesselType = value;
                              });
                            }
                          },
                        ),
                      // Vessel information
                      if (currentVessel != null && currentVessel.notes.isNotEmpty)
                        Padding(
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
                                )).toList(),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      Container(
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
                                  value: showHull,
                                  onChanged: (val) {
                                    setState(() {
                                      showHull = val ?? true;
                                    });
                                  },
                                ),
                                Text("Show Hull"),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: showBowArrow,
                                  onChanged: (val) {
                                    setState(() {
                                      showBowArrow = val ?? true;
                                    });
                                  },
                                ),
                                Text("Show BOW Arrow"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
