import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/providers/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List<Band> bands =[
Band(id: '1',name: 'cami',votes: 1),
Band(id: '2',name: 'cris',votes: 2),
Band(id: '3',name: 'jacobo',votes: 3),
Band(id: '4',name: 'ceci',votes: 4),
];


@override
void initState() {
  final  socketService = Provider.of<SocketService>(context, listen: false);
  socketService.socket.on('active-bands', (payload){
    bands=(payload as List).map((band) => 
        Band.fromMap(band)).toList();

    setState(() {});

  });
  super.initState();
}

@override
  void dispose() {
  final  socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final  socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
       title: const Text('BandNames',style: TextStyle(color: Colors.black87),), 
       backgroundColor: Colors.white,
       elevation: 1,
       actions: [
         Container(
           margin: const EdgeInsets.only(right: 10),
           child:
           (socketService.getServerStatus==ServerStatus.Online) ?
           Icon(Icons.check_circle_rounded, color: Colors.blue[300]):
           Icon(Icons.offline_bolt_rounded, color: Colors.red[300])
         )
       ],
      ),
     
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context,  i)=>  _bandTile(bands[i])   
        ),
      floatingActionButton:FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
        elevation: 1,
        ),
      );
  }

  Widget _bandTile(Band band) {

    final socketService=Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        // ignore: avoid_print
        print('direction:$direction');
        // ignore: avoid_print
        print('deleted band:${band.id}');
      },
      background: Container(
        color: Colors.red.shade400,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style:TextStyle(color: Colors.white),)
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name!.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name!), 
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
        // ignore: avoid_print
        onTap: (){
          socketService.socket.emit('vote-band',{'id': band.id});
        },  
      ),
    );
  }

addNewBand(){
  final textController=TextEditingController();
  if (Platform.isAndroid) {
    return showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: const Text('New Band name'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            child: const Text('Add'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: ()=>addBandToList(textController.text),
            )
        ],
      );
     }
    );
    }
    showCupertinoDialog(
      context: context,
       builder: (_){
         return CupertinoAlertDialog(
           title: const Text('New Band name:'),
           content: CupertinoTextField(
             controller: textController,
           ),
           actions: [
            CupertinoDialogAction(
             child:const Text('Add'),
             isDefaultAction: true,
             onPressed: ()=>addBandToList(textController.text),
            ),
            CupertinoDialogAction(
             child:const Text('Dismiss'),
             isDestructiveAction: true,
             onPressed: ()=>Navigator.pop(context),
            ),
          ],
        );
       }
    );
  }

void addBandToList(String name){
  // ignore: avoid_print
  print(name);
  if (name.length>1) {
    bands.add(Band(id: DateTime.now().toString(),name:name, votes: 0));
    setState(() {});
  
  }


  Navigator.pop(context);
}  
}