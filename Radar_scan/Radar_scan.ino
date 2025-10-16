#include <Wire.h>
#include <Servo.h>
#include "Adafruit_VL53L1X.h"

// -- Pin Definitions --
#define IRQ_PIN 2
#define XSHUT_PIN 3
#define SERVO_PIN 5

// -- Servo Pulse Width Constants --
const int MIN_PULSE = 500;  // Pulse width for 0 degrees
const int MAX_PULSE = 2500; // Pulse width for 270 degrees

// -- Object Declarations --
Adafruit_VL53L1X vl53 = Adafruit_VL53L1X(XSHUT_PIN, IRQ_PIN);
Servo myServo;

int servoAngle = 0;
int scanDirection = 1;

void setup() {
  Serial.begin(115200);
  Wire.begin();

  // Initialize Sensor
  if (!vl53.begin(0x29, &Wire) || !vl53.startRanging()) {
    while (1) delay(10); // Halt on error
  }
  vl53.setTimingBudget(33);

  // Initialize Servo
  myServo.attach(SERVO_PIN, MIN_PULSE, MAX_PULSE);
  myServo.writeMicroseconds(MIN_PULSE);
  delay(1000);
}

void loop() {
  // Move the servo one step
  servoAngle += scanDirection;
  int pulseWidth = map(servoAngle, 0, 270, MIN_PULSE, MAX_PULSE);
  myServo.writeMicroseconds(pulseWidth);

  // Reverse direction at the limits
  if (servoAngle >= 270 || servoAngle <= 0) {
    scanDirection *= -1;
  }

  // Take a reading and send it to the computer
  int16_t distance = -1;
  if (vl53.dataReady()) {
    distance = vl53.distance();
    vl53.clearInterrupt();
  }
  
  // Send data in "angle,distance" format for Processing to read
  Serial.println(String(servoAngle) + "," + String(distance));

  delay(15); // Controls the speed of the sweep
}