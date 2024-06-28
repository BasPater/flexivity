import 'package:flexivity/app/widgets/navbar_widget.dart';
import 'package:flexivity/presentation/prediction_view_model/prediction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/errors/api_exception.dart';
import '../../../data/models/prediction.dart';
import '../../models/ui_state.dart';
import '../../widgets/ui_state_switcher/ui_state_switcher.dart';
import 'bar_graph/bar_graph.dart';

class PredictionScreen extends State<PredictionViewModel> {
  @override
  void initState() {
    super.initState();
    widget.loadData(context).then(
      (_) {
        setState(
          () {
            widget.uiState = UIState.normal;
          },
        );
      },
    ).catchError(
      (e) {
        if (e is ApiException) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Prediction')),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
      body: UIStateSwitcher(
        uiState: widget.uiState,
        loadingState: const Center(
          child: CircularProgressIndicator(),
        ),
        normalState: PredictionContent(viewModel: widget),
      ),
      bottomNavigationBar: NavbarWidget(index: 3),
    );
  }
}

class PredictionContent extends StatefulWidget {
  final PredictionViewModel viewModel;

  const PredictionContent({super.key, required this.viewModel});

  @override
  State<PredictionContent> createState() => _PredictionContentState();
}

class _PredictionContentState extends State<PredictionContent> {
  Future<List<Prediction>> refactorData() async {
    double minValue = widget.viewModel.predictions
        .map((prediction) => prediction.score)
        .reduce((curr, next) => curr < next ? curr : next);
    double offset = minValue < 0 ? minValue.abs() + 1 : 0;
    List<Prediction> refactoredData = widget.viewModel.predictions
        .map((value) =>
            Prediction(date: value.date, score: value.score + offset))
        .toList();

    // Sort the refactoredData list by date in ascending order
    refactoredData.sort((a, b) => a.date.compareTo(b.date));
    widget.viewModel.predictions = refactoredData;
    return refactoredData;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Suggested walking days',
                style: Theme.of(context).textTheme.titleLarge),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'In this page you can see the prediction of your score for the next 5 days. The '),
                  TextSpan(
                      text: 'lower',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text:
                        ' the score, the better. So ${DateFormat('d MMM', 'en_US').format(DateTime.parse(widget.viewModel.predictions.first.date))} is the best day for you to walk.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              height: 400,
              child: FutureBuilder<List<Prediction>>(
                future: refactorData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Prediction>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // or some other widget while waiting
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return BarGraph(weeklySummery: snapshot.data!);
                  }
                },
              ),
            ),
            SizedBox(height: 32),
            Text('Suggested step goal',
                style: Theme.of(context).textTheme.titleLarge),
            Text(
              'Your current step goal is ${widget.viewModel.currentStepGoal}. Based on your previous activities, we suggest you to ${widget.viewModel.suggestedStepGoal > widget.viewModel.currentStepGoal ? "increase" : "decrease"} it to ${widget.viewModel.suggestedStepGoal} steps per day.',
            ),
            SizedBox(height: 20),
            FilledButton(
              child: const Text("Apply suggestion"),
              onPressed: () {
                widget.viewModel.setStepGoal(widget.viewModel.suggestedStepGoal);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Step goal updated successfully'),
                  ),
                );
                setState(() {
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
