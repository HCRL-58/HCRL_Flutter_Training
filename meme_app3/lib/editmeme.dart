// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class EditMeme extends StatefulWidget {
  final String imageName;
  const EditMeme({Key? key, required this.imageName}) : super(key: key);

  @override
  _EditMemeState createState() => _EditMemeState();
}

class _EditMemeState extends State<EditMeme> {
  String topText = '';
  String bottomText = '';
  GlobalKey globalKey = new GlobalKey();
  double xTop = 60, yTop = 30, xBot = 60, yBot = 130;
  double fontSize = 52;

  void initState() {
    super.initState();
    topText = "Top Text";
    bottomText = "Bottom Text";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Meme', style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: Stack(
              children: [
                DragTarget<String>(builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejectedm,
                ) {
                  return Image.asset('assets/meme/${widget.imageName}.jpg');
                }, onAcceptWithDetails: (DragTargetDetails<String> details) {
                  // print(details.data);
                  // print(details.offset);
                  var newX =
                      details.offset.dx - MediaQuery.of(context).padding.left;
                  var newY = details.offset.dy -
                      MediaQuery.of(context).padding.top -
                      AppBar().preferredSize.height;
                  setState(() {
                    if (details.data == 'top') {
                      xTop = newX;
                      yTop = newY;
                    } else if (details.data == 'bottom') {
                      xBot = newX;
                      yBot = newY;
                    }
                  });
                }),
                Positioned(
                  top: yTop,
                  left: xTop,
                  child: Draggable<String>(
                    data: "top",
                    child: buildStorkText(topText, fontSize),
                    feedback: buildStorkText(topText, fontSize),
                    childWhenDragging: Container(),
                  ),
                ),
                Positioned(
                  top: yBot,
                  left: xBot,
                  child: Draggable<String>(
                    data: "bottom",
                    child: buildStorkText(bottomText, fontSize),
                    feedback: buildStorkText(bottomText, fontSize),
                    childWhenDragging: Container(),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SizedBox(height: 24),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      topText = text;
                    });
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE8E8E6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE8E8E6)),
                      ),
                      fillColor: Color(0xFFF7F7F7),
                      filled: true,
                      hintText: "add top text"),
                ),
                SizedBox(height: 24),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      bottomText = text;
                    });
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE8E8E6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE8E8E6)),
                      ),
                      fillColor: Color(0xFFF7F7F7),
                      filled: true,
                      hintText: "add top text"),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            print("- font size");
                            fontSize -= 2;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red[400]),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            print("+ font size");
                            fontSize += 2;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[400]),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  height: 52,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      print("Export");
                      exportMeme();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF0880AE))),
                    child: Text('Export',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack buildStorkText(String text, double inputSize) {
    return Stack(
      children: [
        Text(text,
            style: TextStyle(
              fontSize: inputSize,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = Colors.black,
            )),
        Text(text,
            style: TextStyle(
                fontSize: inputSize,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  void exportMeme() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();

    final directory = (await getApplicationDocumentsDirectory()).path;

    ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    Uint8List pngByte = byteData.buffer.asUint8List();
    File imageFile = File('$directory/meme.png');
    imageFile.writeAsBytesSync(pngByte);

    Share.shareFiles(['$directory/meme.png']);
  }
}
