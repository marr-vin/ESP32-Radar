#include <ESP32Servo.h>

// Defines Trig and Echo pins of the Ultrasonic Sensor

const int trigPin = 5;

const int echoPin = 18;

// Variables for the duration and the distance

long duration;

int distance;

Servo myServo;

void setup() {

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  Serial.begin(115200);

  myServo.attach(21);

}

void loop() {

  // rotates the servo motor from 15 to 165 degrees

  for(int i=11;i<=155;i++){

    myServo.write(i);

    delay(30);

    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");

  }

  // Repeats the previous lines from 165 to 15 degrees

  for(int i=155;i>11;i--){

    myServo.write(i);

    delay(30);

    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");

  }

}

// Function for calculating the distance measured by the Ultrasonic sensor

int calculateDistance(){

  digitalWrite(trigPin, LOW);

  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);

  delayMicroseconds(10);

  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH, 30000);

  if (duration == 0) {
    return 400;
  }

  distance = duration * 0.034 / 2;

  return distance;
}