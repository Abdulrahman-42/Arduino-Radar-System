import processing.serial.*;

Serial myPort;
float angle = 0;
float distance = 0;

float maxRange = 3000.0;

ArrayList<Bogey> bogeys = new ArrayList<Bogey>();
ArrayList<String> terminalLog = new ArrayList<String>();

PFont terminalFont;

int radarHeight = 600;
int terminalHeight = 200;

// A class to define what a "Bogey" is
class Bogey {
  float x, y;
  int lifetime;
  
  Bogey(float pixelDist, float a) {
    this.x = pixelDist * cos(radians(a - 90));
    this.y = pixelDist * sin(radians(a - 90));
    this.lifetime = 255;
  }
  
  void update() {
    this.lifetime -= 2;
  }
  
  void display() {
    stroke(255, 0, 0, this.lifetime);
    fill(255, 0, 0, this.lifetime - 100);
    ellipse(this.x, this.y, 15, 15);
  }
  
  boolean isDead() {
    return this.lifetime < 0;
  }
}

// NEW: settings() function runs before setup() to configure the window
void settings() {
  size(800, radarHeight + terminalHeight);
}


void setup() {
  // The size() call has been moved to settings()
  
  terminalFont = createFont("Monospaced", 14);
  
  printArray(Serial.list());
  String portName = Serial.list()[4]; // Set to your COM port index
  
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0);
  
  drawRadar();
  drawTerminal();
}

void drawRadar() {
  pushMatrix(); 
  translate(width / 2, radarHeight / 2);
  
  drawRadarGrid();
  drawRadarSweep();
  
  for (int i = bogeys.size() - 1; i >= 0; i--) {
    Bogey b = bogeys.get(i);
    b.update();
    b.display();
    if (b.isDead()) {
      bogeys.remove(i);
    }
  }
  popMatrix();
}

void drawTerminal() {
  stroke(0, 255, 0);
  line(0, radarHeight, width, radarHeight);
  
  textFont(terminalFont);
  textAlign(LEFT);
  fill(0, 255, 0);
  textSize(16);
  
  for (int i = 0; i < terminalLog.size(); i++) {
    String message = terminalLog.get(i);
    text(message, 10, radarHeight + 25 + (i * 20));
  }
}

void serialEvent(Serial p) {
  String inString = p.readStringUntil('\n');
  
  if (inString != null) {
    inString = trim(inString);
    String[] parts = split(inString, ',');
    
    if (parts.length == 2) {
      angle = float(parts[0]);
      distance = float(parts[1]);
      
      if (distance > 0 && distance < maxRange) {
        float pixelDist = map(distance, 0, maxRange, 0, (radarHeight/2) * 0.9);
        bogeys.add(new Bogey(pixelDist, angle));
        
        String timestamp = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
        String logMessage = "[" + timestamp + "] Bogey Detected: " + int(angle) + "°, " + int(distance) + "mm";
        terminalLog.add(logMessage);
        
        if (terminalLog.size() > 8) {
          terminalLog.remove(0);
        }
      }
    }
  }
}

void drawRadarGrid() {
  stroke(0, 255, 0, 100);
  noFill();
  strokeWeight(1);
  float circleStep = ((radarHeight/2) * 0.9) / 4;
  for (int i = 1; i <= 4; i++) {
    ellipse(0, 0, circleStep * i * 2, circleStep * i * 2);
  }
}

void drawRadarSweep() {
  stroke(0, 255, 0, 150);
  strokeWeight(3);
  float sweepRadius = (radarHeight/2) * 0.9;
  float sweepX = cos(radians(angle - 90)) * sweepRadius;
  float sweepY = sin(radians(angle - 90)) * sweepRadius;
  line(0, 0, sweepX, sweepY);
}
