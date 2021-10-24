// ignore_for_file: prefer_const_constructors, unnecessary_new, avoid_print, sized_box_for_whitespace

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

  // function ที่จะทำงานก่อนตอนเริ่มทำงาน class นี้
  @override
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
        // เพื่อให้ appBar ไม่มีเงาด้านล่าง
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Meme', style: TextStyle(color: Colors.black)),
      ),
      //ส่วนรูปภาพ
      body: ListView(
        children: [
          RepaintBoundary(
            key: globalKey,
            // รูปภาพจะโดนทับด้วยข้อความจึงต้องใช้ Stack
            child: Stack(
              children: [
                // DragTarget เอาไว้ทำ action ต่างคู่กับตัว Draggable
                DragTarget<String>(builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejectedm,
                ) {
                  return Image.asset('assets/meme/${widget.imageName}.jpg');
                }, onAcceptWithDetails: (DragTargetDetails<String> details) {
                  // print(details.data);
                  // print(details.offset);

                  // เพื่อให้พิกัดจุดที่วางของเราตรง
                  // แกน X ลบด้วย padding ของทางซ้าย
                  // แกน Y ลบด้วย padding ด้านบนและลบด้วยความสูงของ AppBar อีกที
                  var newX =
                      details.offset.dx - MediaQuery.of(context).padding.left;
                  var newY = details.offset.dy -
                      MediaQuery.of(context).padding.top -
                      AppBar().preferredSize.height;
                  // เช็คว่าตัวที่ลากมาวางคือตัวไหนแล้วเปลี่ยนพิกัดของตัวนั้นๆ
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
                // ใช้ Positioned เพื่อให้กำหนดจุดพิกัดของ widget ได้
                Positioned(
                  top: yTop,
                  left: xTop,
                  // Draggable สามารถลากไปที่ต่างๆได้
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
          // ส่วนด้านล่างของภาพ
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                //ใช้ SizedBox เพื่อเว้นช่องว่างในแนวตั้ง
                SizedBox(height: 24),
                // ช่องกรอกเอาไว้ปรับตัวข้อความที่แสดงบนภาพ
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
                // ปุ่มปรับขนาด
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
                // ปุ่ม Export
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

  // สร้างข้อความที่มี stork รอบๆโดยการเอาตัวอักษรสองตัวมาทับกัน
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
    try {
      // RenderRepaintBoundary จะหา widget Boundary ของเรา จาก key ที่เรากำหนดให้
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      //แปลง Boundary ที่ได้มาเป็น image แต่เป็น image จาก lib dart UI
      ui.Image image = await boundary.toImage();

      //? เวลาแชร์เราจะแชร์ได้เฉพาะจากไฟล์ในเครื่องเราเลยต้องเซฟรูปลงเครื่องออก เราเลยจะเอามาเซฟในแอพ
      // เราเลย get directory ของ app
      final directory = (await getApplicationDocumentsDirectory()).path;
      // แปลงรูปเป็น bytedata ใน format ที่เราต้องการ (png)
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
      // แปลงรูปเป็น Uint8List ถึงจะเขียนลงเครื่องได้
      Uint8List pngByte = byteData.buffer.asUint8List();

      // ประกาศตัวแปรไฟล์ (ถ้าไม่มีก็จะสร้าง มีก็จะได้แก้ไข)
      File imageFile = File('$directory/meme.png');
      // เขียนลงไปในไฟล์
      imageFile.writeAsBytesSync(pngByte);

      // แชร์
      Share.shareFiles(['$directory/meme.png']);
    } catch (error) {
      print(error);
    }
  }
}

// ?------------------------- Link Referent ------------------------------------
// Library
// https://pub.dev/packages/share
// https://pub.dev/packages/path_provider

// Draggaber
// https://api.flutter.dev/flutter/widgets/Draggable-class.html
// https://blog.logrocket.com/drag-and-drop-ui-elements-in-flutter-with-draggable-and-dragtarget/

// margin vs padding
// https://iamgique.medium.com/%E0%B8%84%E0%B8%A7%E0%B8%B2%E0%B8%A1%E0%B9%81%E0%B8%95%E0%B8%81%E0%B8%95%E0%B9%88%E0%B8%B2%E0%B8%87%E0%B8%82%E0%B8%AD%E0%B8%87-margin-%E0%B9%81%E0%B8%A5%E0%B8%B0-padding-%E0%B9%83%E0%B8%99-css-50cb254c6ccc
// ?----------------------------------------------------------------------------