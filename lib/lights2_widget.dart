import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'models/vessel_config.dart' as vessel_config;

class Lights2Widget extends StatefulWidget {
  final double angle;
  final bool showHull;
  final bool showBowArrow;
  final vessel_config.VesselType? vesselConfig;
  final double shipLength;
  final double shipBeam;
  final double shipHeight;
  
  const Lights2Widget({
    super.key,
    required this.angle,
    this.showHull = true,
    this.showBowArrow = true,
    this.vesselConfig,
    this.shipLength = 115.0, // Default size in meters
    this.shipBeam = 24.0,
    this.shipHeight = 18.0,
  });

  @override
  State<StatefulWidget> createState() {
    return Lights2WidgetState();
  }
}

class Lights2WidgetState extends State<Lights2Widget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 600,
      child: Container(
        color: Colors.black,
        child: CustomPaint(
          painter: Lights2Painter(
            widget.angle,
            showHull: widget.showHull,
            showBowArrow: widget.showBowArrow,
            vesselConfig: widget.vesselConfig,
            shipLength: widget.shipLength,
            shipBeam: widget.shipBeam,
            shipHeight: widget.shipHeight,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class Lights2Painter extends CustomPainter {
  final double angle;
  final bool showHull;
  final bool showBowArrow;
  final vessel_config.VesselType? vesselConfig;
  final double shipLength;
  final double shipBeam;
  final double shipHeight;
  
  Lights2Painter(
    this.angle, {
    this.showHull = true,
    this.showBowArrow = true,
    this.vesselConfig,
    this.shipLength = 115.0,
    this.shipBeam = 24.0,
    this.shipHeight = 18.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5, paint);

    Ship3DPainter().paint(
      canvas,
      size,
      angle,
      showHull: showHull,
      showBowArrow: showBowArrow,
      vesselConfig: vesselConfig,
      shipLength: shipLength,
      shipBeam: shipBeam,
      shipHeight: shipHeight,
    );
  }

  @override
  bool shouldRepaint(covariant Lights2Painter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.showHull != showHull ||
        oldDelegate.showBowArrow != showBowArrow ||
        oldDelegate.vesselConfig != vesselConfig ||
        oldDelegate.shipLength != shipLength ||
        oldDelegate.shipBeam != shipBeam ||
        oldDelegate.shipHeight != shipHeight;
  }
}

class Ship3DPainter {
  void paint(
    Canvas canvas,
    Size size,
    double angle, {
    bool showHull = true,
    bool showBowArrow = true,
    vessel_config.VesselType? vesselConfig,
    double shipLength = 115.0,
    double shipBeam = 24.0,
    double shipHeight = 18.0,
  }) {
    // angle przychodzi w stopniach (0-360) ze slidera
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Górna część kadłuba (z = 15) - zwiększona wysokość
    List<Point3D> topHull = [
      // Dziobus - zaokrąglony (przód - X pozytywne)
      Point3D(180, 0, 15),
      Point3D(165, -9, 15),
      Point3D(150, -15, 15),
      Point3D(120, -18, 15),
      // Burta lewa (szeroka)
      Point3D(60, -30, 15),
      Point3D(0, -36, 15),
      Point3D(-60, -36, 15),
      // Rafa (tył - X negatywne)
      Point3D(-120, -30, 15),
      Point3D(-135, -18, 15),
      Point3D(-150, -9, 15),
      Point3D(-165, 0, 15),
      // Burta prawa (powrót)
      Point3D(-150, 9, 15),
      Point3D(-135, 18, 15),
      Point3D(-120, 30, 15),
      Point3D(-60, 36, 15),
      Point3D(0, 36, 15),
      Point3D(60, 30, 15),
      Point3D(120, 18, 15),
      Point3D(150, 15, 15),
      Point3D(165, 9, 15),
      Point3D(180, 0, 15),  // Zamknięcie
    ];

    // Dolna część kadłuba (z = -15) - zwiększona wysokość
    List<Point3D> bottomHull = [
      // Dziobus - zaokrąglony (przód - X pozytywne)
      Point3D(180, 0, -15),
      Point3D(165, -9, -15),
      Point3D(150, -15, -15),
      Point3D(120, -18, -15),
      // Burta lewa
      Point3D(60, -30, -15),
      Point3D(0, -36, -15),
      Point3D(-60, -36, -15),
      // Rafa (tył - X negatywne)
      Point3D(-120, -30, -15),
      Point3D(-135, -18, -15),
      Point3D(-150, -9, -15),
      Point3D(-165, 0, -15),
      // Burta prawa (powrót)
      Point3D(-150, 9, -15),
      Point3D(-135, 18, -15),
      Point3D(-120, 30, -15),
      Point3D(-60, 36, -15),
      Point3D(0, 36, -15),
      Point3D(60, 30, -15),
      Point3D(120, 18, -15),
      Point3D(150, 15, -15),
      Point3D(165, 9, -15),
      Point3D(180, 0, -15),  // Zamknięcie
    ];

    // Nadbudówka (superstructure) - pomniejszona, mniejsza wysokość
    List<Point3D> superstructure = [
      // Dół nadbudówki
      Point3D(-90, -8, 15),
      Point3D(-90, -8, 35),
      Point3D(-40, -8, 35),
      Point3D(-40, -8, 15),
      // Prawo
      Point3D(-40, 8, 15),
      Point3D(-40, 8, 35),
      Point3D(-90, 8, 35),
      Point3D(-90, 8, 15),
      // Zamknięcie
      Point3D(-90, -8, 15),
    ];

    // Dach nadbudówki - pomniejszony
    List<Point3D> cabinRoof = [
      Point3D(-90, -8, 35),
      Point3D(-40, -8, 35),
      Point3D(-40, 8, 35),
      Point3D(-90, 8, 35),
      Point3D(-90, -8, 35),
    ];

    // Ściany łączące przód i tył - SKALOWANE 3x
    List<Point3D> connectingWalls = [
      // Dziobus (przód - X pozytywne)
      Point3D(180, 0, 10),
      Point3D(180, 0, -10),
      // Lewa burta przód
      Point3D(120, -18, 10),
      Point3D(120, -18, -10),
      // Lewa burta środek
      Point3D(0, -36, 10),
      Point3D(0, -36, -10),
      // Lewa burta tył
      Point3D(-120, -30, 10),
      Point3D(-120, -30, -10),
      // Rafa (tył - X negatywne)
      Point3D(-165, 0, 10),
      Point3D(-165, 0, -10),
      // Prawa burta tył
      Point3D(-120, 30, 10),
      Point3D(-120, 30, -10),
      // Prawa burta środek
      Point3D(0, 36, 10),
      Point3D(0, 36, -10),
      // Prawa burta przód
      Point3D(120, 18, 10),
      Point3D(120, 18, -10),
    ];

    // Światła - SKALOWANE 3x
    List<Point3D> lights = [
      Point3D(150, 0, 0),   // Przód - żółte (masthead)
      Point3D(-150, 0, 0),    // Tył - białe (sternlight)
    ];

    void drawPath(List<Point3D> points, Canvas canvas, Paint paint, Matrix4 matrix, Offset center) {
      // Najpierw transformuj punkty 3D macierzą
      List<Point3D> transformedPoints = points.map((p) {
        final v = matrix.transform3(Vector3(p.x, p.y, p.z));
        return Point3D(v.x, v.y, v.z);
      }).toList();

      // Potem rzutuj na 2D z perspektywą - rzutuj na XZ (widok boczny)
      List<Point> points2D = transformedPoints
          .map((point) => point.point3Dto2D(Surfaces.xz, perspective: 500))
          .toList();
      
      // Przesunięcie do środka canvasa (center.dx i center.dy to współrzędne środka)
      final List<Offset> pointsOffseted = points2D
          .map((point) => Offset(point.x.toDouble() + center.dx, point.y.toDouble() + center.dy))
          .toList();

      if (pointsOffseted.isEmpty) return;
      Path path = Path();
      path.moveTo(pointsOffseted[0].dx, pointsOffseted[0].dy);
      for (int i = 1; i < pointsOffseted.length; i++) {
        path.lineTo(pointsOffseted[i].dx, pointsOffseted[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    canvas.save();

    // Rysuj cień pod statkiem dla lepszej percepcji głębi - SKALOWANY 3x
    final shadowPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3);
    final shadowEllipse = Rect.fromCenter(
      center: center,
      width: 360,
      height: 120,
    );
    canvas.drawOval(shadowEllipse, shadowPaint);

    // Transformacja 3D - punkt obrotu to (0,0,0) w lokalnych współrzędnych statku
    // Statek ma współrzędne wokół (0,0,0), więc możemy obracać bezpośrednio
    final matrix = Matrix4.identity();
    // Obrót wokół Z - heading angle statku (bez dodatkowego flipa)
    // angle=270° to front view (patrz na dziobus)
    matrix.rotateZ(degrees2Rad(angle));

    // Rysuj górną część
    if (showHull) {
      final paintTop = Paint()
        ..color = Colors.blueAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      drawPath(topHull, canvas, paintTop, matrix, center);

      // Rysuj dolną część
      final paintBottom = Paint()
        ..color = Colors.lightBlueAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      drawPath(bottomHull, canvas, paintBottom, matrix, center);

      // Rysuj ściany łączące
      final paintWalls = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      for (int i = 0; i < connectingWalls.length - 1; i += 2) {
        List<Point3D> wall = [connectingWalls[i], connectingWalls[i + 1]];
        drawPath(wall, canvas, paintWalls, matrix, center);
      }

      // Rysuj nadbudówkę
      final paintSuperstructure = Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      drawPath(superstructure, canvas, paintSuperstructure, matrix, center);

      // Rysuj dach nadbudówki
      final paintRoof = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      drawPath(cabinRoof, canvas, paintRoof, matrix, center);
    }

    // Rysuj światła
    const observerAngleGlobal = 270.0;  // Obserwator patrzy zawsze ze globalnego kierunku 270° (z przodu)
    double angleDegrees = angle;  // Heading statku
    
    // Oblicz kąt obserwatora w LOKALNYM układzie statku
    // Gdy statek się obraca, obserwator również obraca się względem lokalnego układu
    var observerAngleLocal = observerAngleGlobal - angleDegrees;
    // Normalizuj do zakresu -180..180
    while (observerAngleLocal > 180) observerAngleLocal -= 360;
    while (observerAngleLocal < -180) observerAngleLocal += 360;

    if (vesselConfig != null) {
      // Rysuj światła ze konfiguracji JSON
      debugPrint('🚢 Rendering vessel: ship heading=$angleDegrees°, observer global=$observerAngleGlobal°, observer local=${observerAngleLocal.toStringAsFixed(1)}°, lights=${vesselConfig.lights.length}');
      
      for (final light in vesselConfig.lights) {
        // Sektory w JSON są już w lokalnym układzie statku
        // NIE trzeba ich rotować, bo obserwator jest w lokalnym układzie
        final minAngle = light.sector.start;
        final maxAngle = light.sector.end;
        
        // Sprawdź czy obserwator (w lokalnym układzie) jest w sektorze światła
        if (_isAngleInSector(observerAngleLocal, minAngle, maxAngle)) {
          debugPrint('✅ ${light.id}: sector [${minAngle.toStringAsFixed(1)}°, ${maxAngle.toStringAsFixed(1)}°] observer=${observerAngleLocal.toStringAsFixed(1)}° - VISIBLE');
          // Konwertuj pozycję ze ułamków L,B,H na rzeczywiste współrzędne
          final lightWorldPos = light.position.toWorldCoords(shipLength, shipBeam, shipHeight);
          
          // Utwórz Point3D lokalny
          final lightPointLocal = Point3D(lightWorldPos.x, lightWorldPos.y, lightWorldPos.z);
          
          List<Point3D> lightPoints = [lightPointLocal];
          List<Point3D> transformedLight = lightPoints.map((p) {
            final v = matrix.transform3(Vector3(p.x, p.y, p.z));
            return Point3D(v.x, v.y, v.z);
          }).toList();
          
          List<Point> lightPos2D = transformedLight
              .map((point) => point.point3Dto2D(Surfaces.xz, perspective: 500))
              .toList();
          
          final lightOffset = Offset(
            lightPos2D[0].x.toDouble() + center.dx,
            lightPos2D[0].y.toDouble() + center.dy,
          );
          
          // Pobierz kolor ze wspólnych definicji (będziemy potrzebować commonLightDefs)
          // Na razie używamy basic'ego mapowania kolorów
          final lightColor = _getLightColor(light.color);
          
          final paintLight = Paint()
            ..color = lightColor
            ..style = PaintingStyle.fill;
          
          canvas.drawCircle(lightOffset, 5, paintLight);
          
          // Rysuj również lśniący efekt wokół światła
          final glowPaint = Paint()
            ..color = lightColor.withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;
          canvas.drawCircle(lightOffset, 9, glowPaint);
        } else {
          debugPrint('❌ ${light.id}: sector [${minAngle.toStringAsFixed(1)}°, ${maxAngle.toStringAsFixed(1)}°] observer=${observerAngleLocal.toStringAsFixed(1)}° - NOT visible');
        }
      }
    } else {
      // Fallback na hardkodowane światła jeśli nie ma konfiguracji
      // Światło z przodu (żółte) - widoczne w sektorze 112.5° od dziobu (sektor: -112.5 do 112.5)
      const mastheadMinAngle = -112.5;
      const mastheadMaxAngle = 112.5;
      
      // Sprawdź czy obserwator jest w sektorze masthead
      bool isInMastheadSector = _isAngleInSector(observerAngleLocal, mastheadMinAngle, mastheadMaxAngle);
      
      if (isInMastheadSector) {
        List<Point3D> frontLight = [lights[0]];
        final paintFrontLight = Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill;
        
        List<Point3D> transformedFront = frontLight.map((p) {
          final v = matrix.transform3(Vector3(p.x, p.y, p.z));
          return Point3D(v.x, v.y, v.z);
        }).toList();
        
        List<Point> frontLight2D = transformedFront
            .map((point) => point.point3Dto2D(Surfaces.xz, perspective: 500))
            .toList();
        
        final frontLightOffset = Offset(
          frontLight2D[0].x.toDouble() + center.dx,
          frontLight2D[0].y.toDouble() + center.dy,
        );
        canvas.drawCircle(frontLightOffset, 6, paintFrontLight);
      }

      // Światło z tyłu (czerwone) - widoczne w sektorze 135° od rufy (sektor: 112.5 do 247.5)
      const sternMinAngle = 112.5;
      const sternMaxAngle = 247.5;
      
      bool isInSternSector = _isAngleInSector(observerAngleLocal, sternMinAngle, sternMaxAngle);
      
      if (isInSternSector) {
        List<Point3D> rearLight = [lights[1]];
        final paintRearLight = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;
        
        List<Point3D> transformedRear = rearLight.map((p) {
          final v = matrix.transform3(Vector3(p.x, p.y, p.z));
          return Point3D(v.x, v.y, v.z);
        }).toList();
        
        List<Point> rearLight2D = transformedRear
            .map((point) => point.point3Dto2D(Surfaces.xz, perspective: 500))
            .toList();
        
        final rearLightOffset = Offset(
          rearLight2D[0].x.toDouble() + center.dx,
          rearLight2D[0].y.toDouble() + center.dy,
        );
        canvas.drawCircle(rearLightOffset, 6, paintRearLight);
      }
    }

    canvas.restore();

    // Rysuj strzałkę pokazującą dziobus (bow)
    if (showBowArrow) {
      final arrowPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      // Dziobus to punkt (180, 0, 0) - transformuj go
      final bowPoint3D = Point3D(180, 0, 0);
      final bowTransformed = matrix.transform3(Vector3(bowPoint3D.x, bowPoint3D.y, bowPoint3D.z));
      final bowPoint2D = Point3D.fromVector3(bowTransformed).point3Dto2D(Surfaces.xz, perspective: 500);
      final bowOffset = Offset(bowPoint2D.x.toDouble() + center.dx, bowPoint2D.y.toDouble() + center.dy);

      // Rysuj linię od środka do dziobu
      canvas.drawLine(center, bowOffset, arrowPaint);

      // Rysuj strzałkę na końcu
      final towardsBow = bowOffset - center;
      final bowDistance = towardsBow.distance;
      if (bowDistance > 0) {
        final direction = towardsBow / bowDistance;
        final arrowSize = 15.0;
        
        // Punkty ramion strzałki
        final perpendicular = Offset(-direction.dy, direction.dx);
        final arrowTip = bowOffset;
        final arrowBase = bowOffset - direction * arrowSize;
        
        canvas.drawLine(arrowTip, arrowBase + perpendicular * 5, arrowPaint);
        canvas.drawLine(arrowTip, arrowBase - perpendicular * 5, arrowPaint);
      }

      // Tekst "BOW" przy strzałce
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'BOW',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(bowOffset.dx + 10, bowOffset.dy - 15),
      );
    }
  }
  
  // Sprawdza czy kąt jest w sektorze (obsługuje zawinięcie kątów 0-360°)
  bool _isAngleInSector(double observerAngle, double minAngle, double maxAngle) {
    // Normalizuj obserwatora do 0-360°
    double observer = observerAngle % 360;
    if (observer < 0) observer += 360;
    
    // Obsługa sektora all-round (zakres >= 360)
    if ((maxAngle - minAngle) >= 360) {
      return true;
    }
    
    // Normalizuj oba końce sektora do zakresu, który zachowuje relację
    // Konwertuj min i max do zakresu [observer-180, observer+180] dla łatwości porównania
    double min = minAngle;
    double max = maxAngle;
    
    // Dostosuj min i max aby były bliskie observer
    while (min < observer - 180) min += 360;
    while (min > observer + 180) min -= 360;
    while (max < observer - 180) max += 360;
    while (max > observer + 180) max -= 360;
    
    // Teraz sprawdzaj normalnie - sektor wrapping jest obsługiwany
    if (min <= max) {
      return observer >= min && observer <= max;
    } else {
      // Sektor wraps around
      return observer >= min || observer <= max;
    }
  }

  // Konwertuj nazwę koloru na Color
  Color _getLightColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'amber':
        return Colors.amber;
      case 'blue':
        return Colors.blue;
      case 'cyan':
        return Colors.cyan;
      default:
        return Colors.white;
    }
  }
}

class Point3D {
  final double x;
  final double y;
  final double z;
  Point3D(this.x, this.y, this.z);

  // Twórz Point3D z Vector3
  static Point3D fromVector3(Vector3 v) => Point3D(v.x, v.y, v.z);

  // Rzutowanie 3D na 2D z perspektywą
  Point point3Dto2D(Surfaces surface, {double perspective = 500}) {
    switch (surface) {
      case Surfaces.xy:
        // Perspektywa: obiekty dalsze (większy z) są mniejsze
        final scale = perspective / (perspective + z);
        return Point(x * scale, y * scale);
      case Surfaces.xz:
        final scale = perspective / (perspective + y);
        // Zaneguj Z aby topHull (Z>0) był u góry ekranu
        return Point(x * scale, -z * scale);
      case Surfaces.yz:
        final scale = perspective / (perspective + x);
        return Point(y * scale, z * scale);
    }
  }
}

enum Surfaces { xy, xz, yz }

double degrees2Rad(double degrees) {
  return (degrees / 180) * pi;
}

Offset tfLocalPointOffset(Point point, Offset target) {
  return Offset(point.x.toDouble() + target.dx, point.y.toDouble() + target.dy);
}
