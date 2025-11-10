import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class LightsWidget extends StatefulWidget{
  final double angle;
  const LightsWidget({super.key, required this.angle});

  @override
  State<StatefulWidget> createState() {
    return LightsWidgetState();
  }
}

class LightsWidgetState extends State<LightsWidget>{

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 600,
      child: Container(
        color: Colors.black,
        child: CustomPaint(
          painter: LightsPainter(widget.angle),
          size: Size.infinite,
        ),
      ),
    );
  }

}

class LightsPainter extends CustomPainter{
  final double angle;
  LightsPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width/2, size.height/2); 
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5, paint);

    ShipPainter().paint(canvas, size, angle);
    
    //canvas.drawPath(pointsOffseted[0], pointsOffseted[1], paint);

  }

  @override
  bool shouldRepaint(covariant LightsPainter oldDelegate) {
    return (oldDelegate.angle != this.angle) ? true : false;
  }
  
}

class ShipPainter{
    paint(Canvas canvas, Size size, double angle) {
    final Offset center = Offset(size.width/2, size.height/2); 
    final paint = Paint()
    ..color = Colors.blueAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

    List<Point3D> points3D = [
      Point3D(-40, 0, 0),
      Point3D(-40, -4, 0),
      Point3D(-50, 0, 0),
      Point3D(-40, 4, 0),
      Point3D(-40, 0, 0),
      Point3D(40, 0, 0),
      Point3D(40, -14, 0),
      Point3D(40, 0, 0),
      Point3D(32, 0, 0),
      Point3D(32, -14, 0), 
    ];
    List<Point> points2D = points3D.map((point)=>point.point3Dto2D(Surfaces.xy)).toList(); 
    final List<Offset> pointsOffseted = points2D.map((point)=>tfLocalPointOffset(point, center)).toList();
   
    if (pointsOffseted.isEmpty) return;
    Path pointsPath = Path();
    pointsPath.moveTo(pointsOffseted[0].dx, pointsOffseted[0].dy);
    for (int i = 1; i < pointsOffseted.length; i++) {
      pointsPath.lineTo(pointsOffseted[i].dx, pointsOffseted[i].dy);
    }

    // Prawdziwa transformacja 3D
    canvas.save();
    
    // Utwórz macierz transformacji 4x4
    // final matrix4 = Matrix4.identity()
    //   ..setEntry(3, 2, 0.001) // perspektywa
    //   ..translate(size.width / 2, size.height / 2) // przesuń do środka
    //   ..rotateZ(angle) // obrót wokół osi Z
    //   ..rotateY(angle * 0.5) // obrót wokół Y dla efektu 3D
    //   ..translate(-size.width / 2, -size.height / 2); // wróć do początku
      
    final matrix = Matrix4.identity();
    //przesuniecie ukladu wsp do srodka canvas
    matrix.translateByVector3(Vector3(center.dx, center.dy, 0));
    //obrot
    matrix.rotateY(degrees2Rad(angle));
    //przesuniecie ukladu wsp zpowrotem
    matrix.translateByVector3(Vector3(-center.dx, -center.dy, 0));

    // Zastosuj transformację
    canvas.transform(matrix.storage);
    
    // Narysuj ścieżkę
    canvas.drawPath(pointsPath, paint);
    
    canvas.restore();

  }
}


class Point3D{
  final double x;
  final double y;
  final double z;
  Point3D(this.x, this.y, this.z);

  Point point3Dto2D(Surfaces surface){
    switch(surface){
      case Surfaces.xy : return Point(x, y);
      case Surfaces.xz : return Point(x, z);
      case Surfaces.yz : return Point(y, z);
    }
  }
}

enum Surfaces{
  xy,
  xz,
  yz
}

double degrees2Rad(double degrees){
  return (degrees/180) * pi;
}

Offset tfLocalPointOffset(Point point, Offset target){
  // Ensure numeric values are doubles for Offset
  return Offset(point.x.toDouble() + target.dx, point.y.toDouble() + target.dy);
}