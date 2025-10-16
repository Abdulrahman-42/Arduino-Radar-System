# Arduino ToF Scanning Radar

This project is a 270-degree scanning radar built with an Arduino and a Time-of-Flight (ToF) sensor. It scans its environment, identifies objects (bogeys), and sends the data to a computer running a Processing sketch.

The Processing sketch visualizes this data in real-time, showing:
1.  A classic circular radar sweep.
2.  Red blips for any detected objects.
3.  A terminal log at the bottom that lists all bogey detections with their angle, distance, and a timestamp.

---

## Project Gallery

Here is the final assembled project, including the 3D-printed base and sensor housing.

!([(https://github.com/Abdulrahman-42/Arduino-Radar-System/blob/766738540ad9d52a4cac35fa6b18725326e47a54/Gallery/Prototype.jpg)](https://github.com/Abdulrahman-42/Arduino-Radar-System/blob/68eed43f196c8ac779676b4764b3be81bc979381/Gallery/Prototype.jpg)](https://github.com/Abdulrahman-42/Arduino-Radar-System/blob/68eed43f196c8ac779676b4764b3be81bc979381/Gallery/Prototype.jpg))



## 3D Models

The custom-designed radar base and sensor housing were created in FreeCAD. The design files are available in the `cad_models` folder.

* `radar_base.stl` - The main base that holds the servo.
* `sensor_housing.stl` - The housing that attaches the ToF sensor to the servo arm.

You will need a 3D printer or slicing software to view and print these models.

---

## Hardware

* **Microcontroller:** Arduino Nano (or any compatible board)
* **Sensor:** VL53L1X Time-of-Flight Laser Range Sensor
* **Actuator:** 270-degree Servo Motor
* **Pin Connections:**
    * Servo Signal: Pin D5
    * VL53L1X SCL: Pin SCL (A5)
    * VL53L1X SDA: Pin SDA (A4)
    * VL53L1X XSHUT: Pin D3
    * VL53L1X IRQ: Pin D2

## Software

This project consists of two parts:

1.  **Arduino Firmware (`.ino`):**
    * Runs on the Arduino board.
    * Controls the servo's 270-degree sweep using precise pulse widths.
    * Reads distance data from the ToF sensor at each step.
    * Sends `angle,distance` data to the computer via the serial (USB) port.
    * Required Libraries: `Adafruit_VL53L1X`, `Servo`, `Wire`.

2.  **Processing Visualization (`.pde`):**
    * Runs on a computer.
    * Listens for serial data from the Arduino.
    * Draws the radar grid, sweep, and bogey blips.
    * Logs all confirmed detections in a terminal-style window.
    * Required Library: `processing.serial`

## How to Use

1.  3D print the parts from the `cad_models` folder.
2.  Assemble the hardware according to the pin connections.
3.  Upload the `.ino` sketch to your Arduino board.
4.  Open the `.pde` sketch in the Processing IDE.
5.  Run the Processing sketch. You may need to change the `Serial.list()[4]` line to match the COM port of your Arduino.
