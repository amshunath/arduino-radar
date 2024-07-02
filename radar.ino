#include <Servo.h>

const int trigPin = 12;
const int echoPin = 11;
Servo s1;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  s1.attach(9);
}

void loop() {
  sweepServo(0, 180, 1);
  sweepServo(180, 0, -1);
}

void sweepServo(int startAngle, int endAngle, int step) {
  for (int i = startAngle; (step > 0) ? i <= endAngle : i >= endAngle; i += step) {
    s1.write(i);
    delay(30);
    int distance = calDist();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

int calDist() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  long duration = pulseIn(echoPin, HIGH);
  int distance = duration * 0.034 / 2;
  return distance;
}
