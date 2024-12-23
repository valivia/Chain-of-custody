import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:math';


// TODO: Make this its own class file with all metadata later
class Evidence{
  final String id;
  final String description;
  const Evidence(this.id, this.description);
}

class EvidenceScreen extends StatelessWidget{
  EvidenceScreen({super.key, required this.evidenceItems});
  final List<Evidence> evidenceItems;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Evidence",
        style:  Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Colors.white,
        )
      ),
      ),
      body: ListView.builder(
        itemCount: evidenceItems.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(
              evidenceItems[index].id,
            )
          );
        },
      )
    );
  }
}

// Make data come from api with http request, rn random numbers
void main(){
  runApp(
    MaterialApp(
      title: "Evidence",
      home: EvidenceScreen(
        evidenceItems: List.generate(5, (i) {
            final randomId = Random().nextInt(100).toString();
          return Evidence(
            "Item ID $randomId", 
            "Description of evidence item $randomId"
          );
        })
      )
    )
  );
}