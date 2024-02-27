import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_name/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'NdKobi', votes: 10),
    Band(id: '2', name: '21 Savege', votes: 12),
    Band(id: '3', name: 'Linkin Park', votes: 9),
    Band(id: '4', name: 'Ibarra', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        title: Text(
          'BandNames',
          style: TextStyle(color: CupertinoColors.label),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandsTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: CupertinoColors.lightBackgroundGray,
        ),
        backgroundColor: CupertinoColors.activeGreen,
        onPressed: addNerBand,
      ),
    );
  }

  Widget _bandsTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('Direction: $direction');
        print('Id: ${band.id}');
        //TODO: llamar al borrado en el server
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: CupertinoColors.destructiveRed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                Icons.delete_rounded,
                color: CupertinoColors.white,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Delete Band',
                  style: TextStyle(color: CupertinoColors.systemGrey6),
                ),
              ),
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: CupertinoColors.activeGreen.withOpacity(0.4),
          //toma el arreglo de bands en la posicion index y jala el name donde jala las primeras dos letras
          child: Text(
            band.name.substring(0, 2),
            style: TextStyle(color: CupertinoColors.darkBackgroundGray),
          ),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20, color: CupertinoColors.label),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNerBand() {
    final textController = new TextEditingController();
    if (!Platform.isAndroid) {
      //ANDROID
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: CupertinoColors.activeGreen,
                onPressed: () => addBandToList(textController.text),
              )
            ],
          );
        },
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('New Band Name: '),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                'add',
                style: TextStyle(color: CupertinoColors.activeGreen),
              ),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    print(name);
    if (name.length > 1) {
      //PODEMOS AGREGAR
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
