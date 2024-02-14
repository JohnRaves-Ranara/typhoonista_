
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import '../entities2/Province.dart';
import '../entities2/Day.dart';
import '../entities2/Municipality.dart';
import '../entities2/Typhoon.dart';
import '../entities2/Owner.dart';

class test4 extends StatefulWidget {
  const test4({super.key});

  @override
  State<test4> createState() => _test4State();
}

class _test4State extends State<test4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<Typhoon>(
              stream: FirestoreService2().streamOngoingTyphoon(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  Typhoon ongoingTyphoon = snapshot.data!;
                  String typhoonID = ongoingTyphoon.id;
                  return Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.yellow,
                    child: Column(
                      children: [
                        Text("ONGOING TYPHOON NAME: ${snapshot.data!.typhoonName}"),
                        SizedBox(height: 20,),
                        StreamBuilder<List<Province>>(
                          stream: FirestoreService2().streamProvinces(typhoonID),
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              List<Province> provinces = snapshot.data!;
                              return Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.blue,
                                child: Column(
                                  children: provinces.map((province){
                                    return Column(
                                      children: [
                                        ListTile(title: Text("PROVINCE: ${province.provName}"), trailing: Text(ongoingTyphoon.typhoonName),),
                                        StreamBuilder(
                                          stream: FirestoreService2().streamMunicipalities(typhoonID, province.id),
                                          builder: (context, snapshot){
                                            if(snapshot.hasData){
                                              List<Municipality> municipalities = snapshot.data!;
                                              return Container(
                                                color: Colors.green,
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  children: municipalities.map((mun){
                                                    return Column(
                                                      children: [
                                                        ListTile(title: Text("MUNICIPALITY: ${mun.munName}"), trailing: Text(province.provName),),
                                                        StreamBuilder<List<Owner>>(
                                                          stream: FirestoreService2().streamOwners(typhoonID, province.id, mun.id),
                                                          builder: (context, snapshot){
                                                            if(snapshot.hasData){
                                                              List<Owner> owners = snapshot.data!;
                                                              return Container(
                                                                padding: EdgeInsets.all(10),
                                                                color: Colors.orange.shade500,
                                                                child: Column(
                                                                  children: owners.map((owner){
                                                                    return Column(
                                                                      children: [
                                                                        ListTile(title: Text("OWNER: ${owner.ownerName}"), trailing: Text(mun.munName),),
                                                                        StreamBuilder<List<Day>>(
                                                                          stream: FirestoreService2().streamDays(typhoonID, province.id, mun.id, owner.id),
                                                                          builder: (context, snapshot){
                                                                            if(snapshot.hasData){
                                                                              List<Day> days = snapshot.data!;
                                                                              return Container(
                                                                                padding: EdgeInsets.all(10),
                                                                                color: Colors.cyan,
                                                                                child: Column(
                                                                                  children: days.map((day){
                                                                                    return Column(
                                                                                      children: [
                                                                                        ListTile(title: Text("Day ${day.dayNum}"), subtitle: Text(day.id), trailing: Text(owner.ownerName),)
                                                                                      ],
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              );
                                                                            }else{
                                                                              return Center(child: Text('no days'),);
                                                                            }
                                                                            
                                                                          }
                                                                          )
                                                                      ],
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              );
                                                            }else{
                                                              return Center(child: Text("no owners"),);
                                                            }
                                                          }
                                                          )
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              );
                                            }else{
                                              return Center(child: Text("no municipalities"),);
                                            }
                                          }
                                          )
                                      ],
                                    );
                                  }).toList(),
                                ),
                              );
                            } 
                            else{
                              return Center(child: Text("no provinces"),);
                            }
                          }),
                      ],
                    ),
                  );
                }
                else{
                  return Center(child: Text("no typhoons"),);
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}