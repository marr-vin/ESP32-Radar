import processing.serial.*;

Serial myPort;

String data = "";

int iAngle = 0;
int iDistance = 0;

float[] detectedDistance = new float[181];
int[] detectedTime = new int[181];

void setup() {
  size(1000, 700);

  myPort = new Serial(this, "COM3", 115200);
  myPort.bufferUntil('.');
}

void draw() {
  background(0);

  translate(430, 590);

  drawRadar();
  drawObjects();
  drawSweep();

  resetMatrix();

  drawText();
  drawDistanceScale();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');

  if (data != null) {

    data = data.substring(0, data.length() - 1);

    int index = data.indexOf(',');

    if (index > 0) {

      iAngle = int(data.substring(0, index));
      iDistance = int(data.substring(index + 1));

      if (iAngle >= 0 && iAngle <= 180 && iDistance > 0 && iDistance <= 40) {
        detectedDistance[iAngle] = iDistance;
        detectedTime[iAngle] = millis();
      }
    }
  }
}

void drawRadar() {

  stroke(0, 255, 0);
  strokeWeight(2);
  noFill();

  arc(0, 0, 600, 600, PI, TWO_PI);
  arc(0, 0, 450, 450, PI, TWO_PI);
  arc(0, 0, 300, 300, PI, TWO_PI);
  arc(0, 0, 150, 150, PI, TWO_PI);

  line(-300, 0, 300, 0);

  line(0, 0, -260, -150);
  line(0, 0, -150, -260);
  line(0, 0, 0, -300);
  line(0, 0, 150, -260);
  line(0, 0, 260, -150);
}

void drawSweep() {

  for (int a = 0; a < 18; a++) {

    int angle = iAngle - a;

    if (angle >= 0 && angle <= 180) {

      int alpha = 160 - a * 8;

      stroke(0, 255, 0, alpha);
      strokeWeight(4);

      float x = 300 * cos(radians(angle));
      float y = -300 * sin(radians(angle));

      line(0, 0, x, y);
    }
  }

  stroke(0, 255, 0);
  strokeWeight(5);

  float x = 300 * cos(radians(iAngle));
  float y = -300 * sin(radians(iAngle));

  line(0, 0, x, y);
}

void drawObjects() {

  for (int a = 0; a < 180; a++) {

    if (detectedDistance[a] > 0) {

      int age = millis() - detectedTime[a];

      if (age < 3000) {

        float currentDistance = detectedDistance[a];
        float nextDistance = detectedDistance[a + 1];

        float distancePixels = currentDistance * 7.5;
        float nextPixels = nextDistance * 7.5;

        float x1 = distancePixels * cos(radians(a));
        float y1 = -distancePixels * sin(radians(a));

        float x2 = nextPixels * cos(radians(a + 1));
        float y2 = -nextPixels * sin(radians(a + 1));

        int alpha = 255 - age / 12;

        if (nextDistance > 0 &&
            millis() - detectedTime[a + 1] < 3000) {

          stroke(255, 0, 0, alpha);
          strokeWeight(4);

          line(x1, y1, x2, y2);
        }

        stroke(255, 0, 0, alpha);
        strokeWeight(3);

        float edgeX1 = 0.92 * x1;
        float edgeY1 = 0.92 * y1;

        line(x1, y1, edgeX1, edgeY1);
      }
    }
  }
}

void drawText() {

  fill(0, 255, 0);
  textSize(25);

  text("ESP32 RADAR", 25, 35);
  text("Angle: " + iAngle + "°", 25, 65);
  text("Distance: " + iDistance + " cm", 25, 95);
}

void drawDistanceScale() {

  fill(0, 255, 0);
  textSize(22);

  text("DISTANCE", 720, 430);

  text("10 cm", 720, 465);
  text("20 cm", 720, 505);
  text("30 cm", 720, 545);
  text("40 cm", 720, 585);

  stroke(0, 255, 0);
  strokeWeight(2);

  line(700, 450, 700, 600);

  line(690, 465, 710, 465);
  line(690, 505, 710, 505);
  line(690, 545, 710, 545);
  line(690, 585, 710, 585);
}
