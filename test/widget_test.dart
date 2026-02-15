import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart'; 

void main() {
  testWidgets('Vérifie que la page de connexion s\'affiche', (WidgetTester tester) async {

    await tester.pumpWidget(const MyApp());
    expect(find.text('Bon retour !'), findsOneWidget);


    expect(find.text('Créer un compte'), findsOneWidget);

    
    expect(find.text('0'), findsNothing);
  });
}