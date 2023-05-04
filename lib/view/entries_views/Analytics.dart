import 'dart:async';
import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';
import '../metric_views/Vaccine_view.dart';
import '../metric_views/diaper_view.dart';
import '../metric_views/food_view.dart';
import '../metric_views/growth_view.dart';
import '../metric_views/sleep_view.dart';
import '../metric_views/temperature_view.dart';
import '../metric_views/throwup_view.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>{
  
 
  String phrase = "passed";
  DateTime dateA = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime dateB = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        backgroundColor: ColorPalette.backgroundRGB,
        elevation: 0,
      ),
       backgroundColor: ColorPalette.backgroundRGB,
      body: 
      Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
               
               const TextDivider(text: 'Select Start Date'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Date'),
                  TextButton(
                    child: Text(
                     dateA.month.toString()+"/" +dateA.day.toString()+"/" +dateA.year.toString()
                    ),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context, initialDate: dateA, firstDate: DateTime(2016), lastDate: DateTime(2101) );

                      if (newDate == null) return;

                      setState(() {
                        dateA = newDate;
                      });
                    },
                  ),
                ],
              ),
              const TextDivider(text: 'Select End Date'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Date'),
                  TextButton(
                    child: Text(
                     dateB.month.toString()+"/" +dateB.day.toString()+"/" +dateB.year.toString()
                    ),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context, initialDate: dateB, firstDate: DateTime(2016), lastDate: DateTime(2101) );

                      if (newDate == null) return;

                      setState(() {
                        dateB = newDate;
                      });
                    },
                  ),
                ],
              ),
      Center(
        child: ElevatedButton(
          child: const Text('Search'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SearchRoute( startDate: dateA, endDate: dateB)),
            );
          },
        ),
      ),
            ],
      ),
    ),
      ),
    );
  }
  
}


     
  
class SearchRoute extends StatelessWidget {
  
  DateTime start_Date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
   DateTime end_Date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

   int DiaperEntrys = 0;
   int FoodEntrys = 0;
   int VomitEntrys = 0;
   int GrowthEntrys = 0;
   int SleepEntrys = 0;
   int VaccineEntrys = 0;
   int TempEntrys = 0;
   int x =1;
   
   int AmtofDays = 0;
   int AmtofDaysGrowth = 0;

   double TotSleep = 0;
   double TotFeeding = 0;
   double TotLiquid = 0;
   double TotNursing = 0;
   double TotTemp = 0;
   int sleepRan = 0;
   int feedingRan = 0;
   int tempRan = 0;
   int growthRan = 0;

   double ChangeHeight = 0;
   double ChangeWeight = 0;
   double ChangeHead = 0;

   double feedingAvg = 0;
   double liquidAvg = 0;
   double nursingAvg = 0;
   double tempAvg = 0;
   double sleepAvg = 0;

   double dailyFeed = 0;
   double dailyLiquid = 0;
   double dailyNurse = 0;
   double dailySleep = 0;
   double dailyGrowthHeight = 0;
   double dailyGrowthWeight = 0;
   double dailyGrowthHC = 0;

   SearchRoute({ required startDate, required endDate})
   {
     
      start_Date = startDate;
      end_Date = endDate;
      AmtofDays = ((end_Date.difference(start_Date)).inDays) + 1;
   

   }
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
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Diaper').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index){
                DiaperEntrys = int.parse((snapshot.data?.docs.length).toString());
                 return SizedBox(height: 0);
                
                
  


      //log((DiaperEntrys).toString());
  
        
        },
        
      );
      
        }
       )]),
      
      Column(
              
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Food').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index){
                FoodEntrys = int.parse((snapshot.data?.docs.length).toString());
                if (feedingRan == 0)
                {
                for( var i = 0 ; i < FoodEntrys; i++ ) 
                { 
                  if ((snapshot.data?.docs[i]['metricType'] == "oz"))
                  {
                    TotFeeding =TotFeeding + (snapshot.data?.docs[i]['amount']);
                  }
                  else if  ((snapshot.data?.docs[i]['metricType'] == "ml"))
                  {
                    TotLiquid = TotLiquid + (snapshot.data?.docs[i]['amount']);
                  }
                
                TotNursing =TotNursing + (snapshot.data?.docs[i]['duration']);
      
                } 
  

      feedingAvg = TotFeeding / FoodEntrys;
      liquidAvg = TotLiquid / FoodEntrys;
      nursingAvg = TotNursing / FoodEntrys;
      dailyFeed = TotFeeding / AmtofDays;
      dailyNurse = TotNursing / AmtofDays;
      dailyLiquid = TotLiquid / AmtofDays;
      feedingRan = 1;
                }
     // //log((FoodEntrys).toString());
     // //log((TotFeeding).toString());
     // //log((TotNursing).toString());
      return SizedBox(height: 0);
        
        },
        
      );
      
        }
       )]),
       
       Column(    
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Growth').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index){
                if (growthRan == 0)
                {
                GrowthEntrys = int.parse((snapshot.data?.docs.length).toString());
          
                DateTime earliestDate = DateTime(2030);
                DateTime latestDate = DateTime(2016);
                

                double earliestHeight = 0;
                double earliestWeight = 0;
                double earliestHC = 0;

                double latestHeight = 0;
                double latestWeight = 0;
                double latestHC = 0;

                

                for( var i = 0 ; i < GrowthEntrys; i++ ) 
                { 
                Timestamp TTime = (snapshot.data?.docs[i]['timeCreated']);
                DateTime TempTime = DateTime.fromMicrosecondsSinceEpoch(TTime.microsecondsSinceEpoch);
                 if (TempTime.isAfter(latestDate))
                 {
                  latestDate = TempTime;
                  if ((snapshot.data?.docs[i]['weightType']) == 'lb')
                  {
                    latestWeight = (snapshot.data?.docs[i]['weight']);
                  }
                  else if ((snapshot.data?.docs[i]['weightType']) == 'kg')
                  {
                    latestWeight = ((snapshot.data?.docs[i]['weight']) * 2.2);
                  }
                  if ((snapshot.data?.docs[i]['heightType']) == 'in')
                  {
                    latestHeight = (snapshot.data?.docs[i]['height']);
                  }
                  else if ((snapshot.data?.docs[i]['heightType']) == 'cm')
                  {
                    latestHeight = ((snapshot.data?.docs[i]['height'])/2.54);
                  } 
                  if ((snapshot.data?.docs[i]['HCType']) == 'in')
                  {
                    latestHC = (snapshot.data?.docs[i]['headCircumference']);
                  }
                  else if ((snapshot.data?.docs[i]['HCType']) == 'cm')
                  {
                    latestHC = ((snapshot.data?.docs[i]['headCircumference'])/2.54);
                  }
                //  latestHeight = (snapshot.data?.docs[i]['height']);
                //  latestWeight = (snapshot.data?.docs[i]['weight']);
                //  latestHC = (snapshot.data?.docs[i]['headCircumference']);

                 }

                 if (TempTime.isBefore(earliestDate))
                 {
                  earliestDate = TempTime;
                  // height conversion
                  if ((snapshot.data?.docs[i]['weightType']) == 'lb')
                  {
                    earliestWeight = (snapshot.data?.docs[i]['weight']);
                  }
                  else if ((snapshot.data?.docs[i]['weightType']) == 'kg')
                  {
                    earliestWeight = ((snapshot.data?.docs[i]['weight']) * 2.2);
                  }
                  if ((snapshot.data?.docs[i]['heightType']) == 'in')
                  {
                    earliestHeight = (snapshot.data?.docs[i]['height']);
                  }
                  else if ((snapshot.data?.docs[i]['heightType']) == 'cm')
                  {
                    earliestHeight = ((snapshot.data?.docs[i]['height'])/2.54);
                  } 
                  if ((snapshot.data?.docs[i]['HCType']) == 'in')
                  {
                    earliestHC = (snapshot.data?.docs[i]['headCircumference']);
                  }
                  else if ((snapshot.data?.docs[i]['HCType']) == 'cm')
                  {
                    earliestHC = ((snapshot.data?.docs[i]['headCircumference'])/2.54);
                  }
                 // earliestHeight = (snapshot.data?.docs[i]['height']);
                //  earliestWeight = (snapshot.data?.docs[i]['weight']);
                 // earliestHC = (snapshot.data?.docs[i]['headCircumference']);

                 }
      
                } 
      ChangeHead = latestHC - earliestHC;
      ChangeHeight = latestHeight - earliestHeight;
      ChangeWeight = latestWeight - earliestWeight;
      AmtofDaysGrowth = ((latestDate.difference(earliestDate)).inDays) + 1;

      dailyGrowthHeight = ChangeHeight / AmtofDaysGrowth;
      dailyGrowthWeight = ChangeWeight / AmtofDaysGrowth;
      dailyGrowthHC = ChangeHead / AmtofDaysGrowth;
      growthRan = 1;
                }

      return SizedBox(height: 0);
  
        
        },
        
      );
      
        }
       )]),
          
       Column(    
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Sleep').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index){
                if (sleepRan == 0)
                {
                SleepEntrys = int.parse((snapshot.data?.docs.length).toString());
                
                for( var i = 0 ; i < SleepEntrys; i++ ) 
                { 
                TotSleep =TotSleep + (snapshot.data?.docs[i]['duration']);
                } 
                
  
      sleepAvg = TotSleep / SleepEntrys;
      dailySleep = TotSleep / AmtofDays;
      sleepRan = 1;
                }
      //log((SleepEntrys).toString());
      //log((TotSleep).toString());
  
         return SizedBox(height: 0);
        },
        
      );
      
        }
       )]),
      
       Column(    
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Temperature').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index)
              {
                if (tempRan == 0)
                {
                TempEntrys = int.parse((snapshot.data?.docs.length).toString());
                for( var i = 0 ; i < TempEntrys; i++ ) 
                { 
                  if ((snapshot.data?.docs[i]['tempType']) == 'F')
                  {
                    TotTemp =TotTemp + (snapshot.data?.docs[i]['temperature']);
                  }
                   else if ((snapshot.data?.docs[i]['tempType']) == 'C')
                  {
                    TotTemp =TotTemp + (((snapshot.data?.docs[i]['temperature'])*1.8)+32);
                  }
                
                } 
                
  
         tempAvg = TotTemp / TempEntrys;
         tempRan = 1;
                }
      //log((TempEntrys).toString());
      //log(TotTemp.toString());
  
         return SizedBox(height: 0);
        },
        
      );
      
        }
       )]),
      
       Column(    
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Throwup').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            
            return Center(
              child: CircularProgressIndicator(),
            );
          }
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index){
                VomitEntrys = int.parse((snapshot.data?.docs.length).toString());
                
  


      //log((VomitEntrys).toString());
  
         return SizedBox(height: 0);
        },
        
      );
      
        }
       )]),
      
       Column(    
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Vaccine').where('timeCreated', isGreaterThanOrEqualTo: start_Date).where('timeCreated', isLessThanOrEqualTo: end_Date).snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index){
                VaccineEntrys = int.parse((snapshot.data?.docs.length).toString());
                
          /** 
          if(x == 1)
          {
             x = x +1;
            return Column(
              children: [
              
              
              const TextDivider(text:"Amount of Entries" ),

              Row(children: [
                
                Text("Diaper entries:"),
                Text(
                (DiaperEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Feeding entries:"),
                Text(
                (FoodEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Growth entries:"),
                Text(
                (GrowthEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Sleep entries:"),
                Text(
                (SleepEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Temperature entries:"),
                Text(
                (TempEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Throw Up entries: "),
                Text(
                (VomitEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Vaccine entries:"),
                Text(
                (VaccineEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),    
              const TextDivider(text:"Average of Entries" ),
              Row(children: [
                Text("Feeding (amount in ounces/ entry):"),
                Text(
                (feedingAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
               Row(children: [
                Text("Liquid Intake (amount in ml/ entry):"),
                Text(
                (liquidAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Feeding (duration of nursing in minutes/ entry):"),
                Text(
                (nursingAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Sleep Duration (hours/entry): "),
                Text(
                (sleepAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Temperature in farenheit: "),
                Text(
                (tempAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              const TextDivider(text:"Daily averages" ),
              Row(children: [
                Text("Feeding (amount in ounces/ day):"),
                Text(
                (dailyFeed).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
              Text("Liquid intake (amount in ml/ day):"),
                Text(
                (dailyLiquid).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Feeding (duration of nursing/ day):"),
                Text(
                (dailyNurse).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
                        ]),
              Row(children: [
                Text("Sleep Duration in hours/ day: "),
                Text(
                (dailySleep).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
               Row(children: [
                Text("Change in height in inches/ day: "),
                Text(
                (dailyGrowthHeight).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  
                  )
              ]),
               Row(
              //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Change in weight in pounds/ day: "),
                Text(
                (dailyGrowthWeight).toStringAsFixed(2),
                  
                  textAlign: TextAlign.center,

                  )
              ]),
               Row(children: [
                Text("Change in head circumference in inches/ day: "),
                Text(
                (dailyGrowthHC).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
          
            ]
          

            );
          
           
          }
          else{
            return SizedBox(height: 0);
          }
      */
      //log((VaccineEntrys).toString());
  
         return SizedBox(height: 0);
        },
        
      );
      
      
        }
        
       ),
       
      
           
       ]),

        Column(    
          children: [
     StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Baby').snapshots(),
        builder: ( context,  snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          
  
          return ListView.builder 
          (
                scrollDirection: Axis.vertical,
          shrinkWrap: true,
           itemCount:snapshot.data?.docs.length,
              itemBuilder: (context,index){
                
                
          
          if(x == 1)
          {
             x = x +1;
            return Column(
              children: [
              
              
              const TextDivider(text:"Amount of Entries" ),

              Row(children: [
                
                Text("Diaper entries:"),
                Text(
                (DiaperEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Feeding entries:"),
                Text(
                (FoodEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Growth entries:"),
                Text(
                (GrowthEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Sleep entries:"),
                Text(
                (SleepEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Temperature entries:"),
                Text(
                (TempEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Throw Up entries: "),
                Text(
                (VomitEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Vaccine entries:"),
                Text(
                (VaccineEntrys).toString(),
                  textAlign: TextAlign.center,
                  )
              ]),    
              const TextDivider(text:"Average of Entries" ),
              Row(children: [
                Text("Feeding (amount in ounces/ entry):"),
                Text(
                (feedingAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
               Row(children: [
                Text("Liquid Intake (amount in ml/ entry):"),
                Text(
                (liquidAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Feeding (duration of nursing in minutes/ entry):"),
                Text(
                (nursingAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Sleep Duration (hours/entry): "),
                Text(
                (sleepAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Temperature in farenheit: "),
                Text(
                (tempAvg).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              const TextDivider(text:"Daily averages" ),
              Row(children: [
                Text("Feeding (amount in ounces/ day):"),
                Text(
                (dailyFeed).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
              Text("Liquid intake (amount in ml/ day):"),
                Text(
                (dailyLiquid).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
              Row(children: [
                Text("Feeding (duration of nursing/ day):"),
                Text(
                (dailyNurse).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
                        ]),
              Row(children: [
                Text("Sleep Duration in hours/ day: "),
                Text(
                (dailySleep).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
               Row(children: [
                Text("Change in height in inches/ day: "),
                Text(
                (dailyGrowthHeight).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  
                  )
              ]),
               Row(
              //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Change in weight in pounds/ day: "),
                Text(
                (dailyGrowthWeight).toStringAsFixed(2),
                  
                  textAlign: TextAlign.center,

                  )
              ]),
               Row(children: [
                Text("Change in head circumference in inches/ day: "),
                Text(
                (dailyGrowthHC).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  )
              ]),
          
            ]
          

            );
          
           
          }
          else{
            return SizedBox(height: 0);
          }

      //log((VaccineEntrys).toString());
  
        
        },
        
      );
      
      
        }
        
       ),
       
      
           
       ]),
       
       
     ] 
      ),
    )

    );
    
   
  
 
    }

    

}

  