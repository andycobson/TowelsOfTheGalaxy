
import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';



class WeeksView extends StatefulWidget {
  const WeeksView({super.key});

  @override
  State<WeeksView> createState() => _WeeksViewState();
}

class _WeeksViewState extends State<WeeksView>{
    DateTime start_Date = DateTime(DateTime.now().subtract(Duration(days: 6)).year,DateTime.now().subtract(Duration(days: 6)).month, DateTime.now().subtract(Duration(days: 6)).day);
   DateTime end_Date = DateTime(DateTime.now().add(Duration(days: 1)).year,DateTime.now().add(Duration(days: 1)).month, DateTime.now().add(Duration(days: 1)).day);
Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: ColorPalette.backgroundRGB,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 67, 67, 209),
      body:
      
     
        SingleChildScrollView(
        child: Column(
          
            children: [
       Column(
               //   height: 200.0,
               //   width: 2000.0,       
                  children: [StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Diaper').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
                child: Column(
            children: [
             
              const TextDivider(text: 'New Entry'),  
              const TextDivider(text: 'Occured at:'),    
                Center(
                  child: Text( doc.data().toString().contains('timeCreated') ? doc.get('timeCreated').toDate().toString() : (2016).toString())
                ),
               const TextDivider(text: 'Status'),      
                Center(
                  child: Text( doc.data().toString().contains('diaperContents') ? doc.get('diaperContents') : '')
                ),
                const TextDivider(text: 'Notes'),      
                Center(
                  child: Text( doc.data().toString().contains('notes') ? doc.get('notes') : '')
                ),
                 SizedBox( 
                height: 50,
                width: 100,
                child: ElevatedButton(                   
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                   log("Todo: Create delete method");
                  },
                  child: const Text('Delete'),
                  
                ),
              ), //
                const TextDivider(text: '')
            ]
                )    
              );
            }).toList(),
          );
        },
        
      ),
            ]),

       Column(
        //  height: 2000.0,
        //  width: 2000.0,       
          children: [
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Food').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
                child: Column(
            children: [
             
              const TextDivider(text: 'New Entry'),  
              const TextDivider(text: 'Occured at:'),    
                Center(
                  child: Text( doc.data().toString().contains('timeCreated') ? doc.get('timeCreated').toDate().toString() : (2016).toString())
                ),
               const TextDivider(text: 'Nursing, Feeding, or Both?'),      
                Center(
                  child: Text( doc.data().toString().contains('feedingType') ? doc.get('feedingType') : '')
                ),
                 const TextDivider(text: 'Feeding Amount'),      
                Center(
                  child: Text( (doc.data().toString().contains('amount') ? doc.get('amount').toString() : 0.toString()) +(doc.data().toString().contains('metricType') ? doc.get('metricType') : ''))
                ),
                const TextDivider(text: 'Times of Nursing'),      
                Center(
                  child: Text((doc.data().toString().contains('startTime') ? doc.get('startTime').toDate().toString() : (2016).toString())+' to '+(doc.data().toString().contains('endTime') ? doc.get('endTime').toDate().toString() : (2016).toString()))
                ),
                const TextDivider(text: 'Nursing Duration'),      
                Center(
                  child: Text(( doc.data().toString().contains('duration') ? doc.get('duration').toString() : 0.toString()) + (" Minutes"))
                ),
                const TextDivider(text: 'Notes'),      
                Center(
                  child: Text( doc.data().toString().contains('notes') ? doc.get('notes') : '')
                ),
                 SizedBox( 
                height: 50,
                width: 100,
                child: ElevatedButton(                   
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                   log("Todo: Create delete method");
                  },
                  child: const Text('Delete'),
                  
                ),
              ), //
                const TextDivider(text: '')
            ]
                )    
              );
            }).toList(),
          );
        },
      ),
            
            ]),
      
       Column(
       // height:2000,
       // width: 2000,
        children: [
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Growth').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
                child: Column(
            children: [
             
              const TextDivider(text: 'New Entry'),  
              const TextDivider(text: 'Occured at:'),    
                Center(
                  child: Text( doc.data().toString().contains('timeCreated') ? doc.get('timeCreated').toDate().toString() : (2016).toString())
                ),
               const TextDivider(text: 'Head Circumference'),      
                Center(
                  child: Text( (doc.data().toString().contains('headCircumference') ? doc.get('headCircumference').toString() : 0.toString()) + (" inches"))
                ),
                const TextDivider(text: 'Head Circumference'),      
                Center(
                  child: Text( (doc.data().toString().contains('headCircumference') ? doc.get('headCircumference').toString() : 0.toString()) + (" inches"))
                ),
                const TextDivider(text: 'Height'),      
                Center(
                  child: Text( (doc.data().toString().contains('height') ? doc.get('height').toString() : 0.toString()) + (" Inches"))
                ),
                const TextDivider(text: 'Weight'),      
                Center(
                  child: Text(( doc.data().toString().contains('weight') ? doc.get('weight').toString() : 0.toString()) + (" Pounds"))
                ),
                const TextDivider(text: 'Notes'),      
                Center(
                  child: Text( doc.data().toString().contains('notes') ? doc.get('notes') : '')
                ),
                 SizedBox( 
                height: 50,
                width: 100,
                child: ElevatedButton(                   
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                   log("Todo: Create delete method");
                  },
                  child: const Text('Delete'),
                  
                ),
              ), //
                const TextDivider(text: '')
            ]
                )    
              );
            }).toList(),
          );
        },
      ),    
            
            ]),
      
       Column(
        //height:2000,
       // width: 2000,
        children: [
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Sleep').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
                child: Column(
            children: [
             
              const TextDivider(text: 'New Entry'),  
              const TextDivider(text: 'Entry posted at:'),    
                Center(
                  child: Text( doc.data().toString().contains('timeCreated') ? doc.get('timeCreated').toDate().toString() : (2016).toString())
                ),
                const TextDivider(text: 'Times frame of nap'),      
                Center(
                  child: Text((doc.data().toString().contains('startTime') ? doc.get('startTime').toDate().toString() : (2016).toString())+' to '+(doc.data().toString().contains('endTime') ? doc.get('endTime').toDate().toString() : (2016).toString()))
                ),
                const TextDivider(text: 'Duration'),      
                Center(
                  child: Text(( doc.data().toString().contains('duration') ? doc.get('duration').toString() : 0.toString()) + (" Hours"))
                ),
                const TextDivider(text: 'Notes'),      
                Center(
                  child: Text( doc.data().toString().contains('notes') ? doc.get('notes') : '')
                ),
                 SizedBox( 
                height: 50,
                width: 100,
                child: ElevatedButton(                   
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                   log("Todo: Create delete method");
                  },
                  child: const Text('Delete'),
                  
                ),
              ), //
                const TextDivider(text: '')
            ]
                )    
              );
            }).toList(),
          );
        },
      ),      
            
            ]),
      
       Column(
       // height:2000,
       // width: 2000,
        children: [
      StreamBuilder(
        
        stream: FirebaseFirestore.instance.collection('Temperature').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
                child: Column(
            children: [
             
              const TextDivider(text: 'New Entry'),  
              const TextDivider(text: 'Entry posted at:'),    
                Center(
                  child: Text( doc.data().toString().contains('timeCreated') ? doc.get('timeCreated').toDate().toString() : (2016).toString())
                ),
                const TextDivider(text: 'Temperature'),      
                Center(
                  child: Text((doc.data().toString().contains('temperature') ? doc.get('temperature').toString() : 0.toString())+' ° '+(doc.data().toString().contains('tempType') ? doc.get('tempType') : ''))
                ),
                
                const TextDivider(text: 'Taken at:'),      
                Center(
                  child: Text( doc.data().toString().contains('TempTime') ? doc.get('TempTime').toDate().toString() : (2016).toString())
                ),
                const TextDivider(text: 'Notes'),      
                Center(
                  child: Text( doc.data().toString().contains('notes') ? doc.get('notes') : '')
                ),
                 SizedBox( 
                height: 50,
                width: 100,
                child: ElevatedButton(                   
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                   log("Todo: Create delete method");
                  },
                  child: const Text('Delete'),
                  
                ),
              ), //
                const TextDivider(text: '')
            ]
                )    
              );
            }).toList(),
          );
        },
      ),      
            
            ]),
      
       Column(
      //  height:2000,
      //  width: 2000,
        children: [
        StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Throwup').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
                child: Column(
            children: [
             
              const TextDivider(text: 'New Entry'),  
              const TextDivider(text: 'Entry Created at:'),    
                Center(
                  child: Text( doc.data().toString().contains('timeCreated') ? doc.get('timeCreated').toDate().toString() : (2016).toString())
                ),
                const TextDivider(text: 'Color'),      
                Center(
                  child: Text(doc.data().toString().contains('ThrowUpColor') ? doc.get('ThrowUpColor') : '' )
                ),
                
                const TextDivider(text: 'Taken at:'),      
                Center(
                  child: Text( doc.data().toString().contains('startTime') ? doc.get('startTime').toDate().toString() : (2016).toString())
                ),
                const TextDivider(text: 'Notes'),      
                Center(
                  child: Text( doc.data().toString().contains('notes') ? doc.get('notes') : '')
                ),
                 SizedBox( 
                height: 50,
                width: 100,
                child: ElevatedButton(                   
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                   log("Todo: Create delete method");
                  },
                  child: const Text('Delete'),
                  
                ),
              ), //
                const TextDivider(text: '')
            ]
                )    
              );
            }).toList(),
          );
        },
      ),      
            
            ]),
      
       Column(
       // height:2000,
       // width: 2000,
        children: [
        StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Vaccine').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView(
            shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
                child: Column(
            children: [
             
              const TextDivider(text: 'New Entry'),  
              const TextDivider(text: 'Entry Created at:'),    
                Center(
                  child: Text( doc.data().toString().contains('timeCreated') ? doc.get('timeCreated').toDate().toString() : (2016).toString())
                ),
                const TextDivider(text: 'Vaccine'),      
                Center(
                  child: Text((doc.data().toString().contains('Vaccine') ? doc.get('Vaccine') : '') + " Series: " + (doc.data().toString().contains('series') ? doc.get('series').toString() : 0.toString()))
                ),
                
                const TextDivider(text: 'Taken at:'),      
                Center(
                  child: Text( doc.data().toString().contains('startTime') ? doc.get('startTime').toDate().toString() : (2016).toString())
                ),
                const TextDivider(text: 'Notes'),      
                Center(
                  child: Text( doc.data().toString().contains('notes') ? doc.get('notes') : '')
                ),
                 SizedBox( 
                height: 50,
                width: 100,
                child: ElevatedButton(                   
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                   log("Todo: Create delete method");
                  },
                  child: const Text('Delete'),
                  
                ),
              ), //
                const TextDivider(text: '')
            ]
                )    
              );
            }).toList(),
          );
        },
      ),      
            ])
        
        ]
      ),
    )

    );
    
    }
    

 
}
    
  
