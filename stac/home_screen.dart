import 'package:stac/stac_core.dart';

@StacScreen(screenName: 'home_screen')
StacWidget homeScreen() {
  return StacScaffold(
    appBar: StacAppBar(title: StacText(data: 'SDUI Research App')),
    body: StacColumn(
      mainAxisAlignment: StacMainAxisAlignment.center,
      crossAxisAlignment: StacCrossAxisAlignment.stretch,
      children: [
        StacText(
          data: 'This UI was rendered from the server!',
          textAlign: StacTextAlign.center,
          style: StacTextStyle(fontSize: 20, fontWeight: StacFontWeight.bold),
        ),
        StacSizedBox(height: 20),
        StacElevatedButton(
          onPressed: StacNavigateAction(routeName: 'detail_screen'),
          child: StacText(data: 'Go to Detail'),
        ),
      ],
    ),
  );
}
