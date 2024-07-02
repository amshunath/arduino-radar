import processing.serial.*; // Imports library for serial communication
import java.awt.event.KeyEvent; // Imports library for handling key events
import java.io.IOException; // Imports library for handling I/O exceptions

Serial myPort; // Defines Serial object for communication
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
PFont orcFont; // Font used for displaying text on screen

void setup() {
  size(1920, 1080); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
  smooth();
  myPort = new Serial(this, "COM3", 9600); // Starts the serial communication
  myPort.bufferUntil('.'); // Reads data from the serial port up to the character '.'
  orcFont = loadFont("OCRAExtended-48.vlw"); // Loads the custom font
}

void draw() {
  fill(98, 245, 31); // Sets the color for text
  textFont(orcFont); // Sets the font
  // Simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0, 4); 
  rect(0, 0, width, height - height * 0.065); 
  
  fill(98, 245, 31); // Green color

  // Calls the functions for drawing the radar components
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) { 
  // Reads data from the Serial Port
  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length() - 1);

  index1 = data.indexOf(","); // Finds the character ',' and stores its position in "index1"
  angle = data.substring(0, index1); // Extracts the angle value
  distance = data.substring(index1 + 1, data.length()); // Extracts the distance value
  
  // Converts the String variables into integers
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // Moves the starting coordinates to a new location
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  // Draws the arc lines
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);
  
  // Draws the angle lines
  line(-width / 2, 0, width / 2, 0);
  line(0, 0, (-width / 2) * cos(radians(30)), (-width / 2) * sin(radians(30)));
  line(0, 0, (-width / 2) * cos(radians(60)), (-width / 2) * sin(radians(60)));
  line(0, 0, (-width / 2) * cos(radians(90)), (-width / 2) * sin(radians(90)));
  line(0, 0, (-width / 2) * cos(radians(120)), (-width / 2) * sin(radians(120)));
  line(0, 0, (-width / 2) * cos(radians(150)), (-width / 2) * sin(radians(150)));
  
  line((-width / 2) * cos(radians(30)), 0, width / 2, 0);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // Moves the starting coordinates to a new location
  strokeWeight(9);
  stroke(255, 10, 10); // Red color

  // Converts the distance from cm to pixels
  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025); 
  
  // Limits the range to 40 cm
  if (iDistance < 40) {
    // Draws the object according to the angle and the distance
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), 
         (width - width * 0.505) * cos(radians(iAngle)), 
         -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60); // Green color for the line
  translate(width / 2, height - height * 0.074); // Moves the starting coordinates to a new location
  // Draws the line according to the angle
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), 
       -(height - height * 0.12) * sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  // Draws the text on the screen
  pushMatrix();
  if (iDistance > 40) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }
  
  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);
  
  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);
  textSize(40);

  text("Object: " + noObject, width - width * 0.875, height - height * 0.0277);
  text("Angle: " + iAngle + "°", width - width * 0.48, height - height * 0.0277);
  text("Distance: ", width - width * 0.26, height - height * 0.0277);
  
  if (iDistance < 40) {
    text(" " + iDistance + " cm", width - width * 0.225, height - height * 0.0277);
  }

  textSize(25);
  fill(98, 245, 60);
  
  drawAngleText(30);
  drawAngleText(60);
  drawAngleText(90);
  drawAngleText(120);
  drawAngleText(150);

  popMatrix(); 
}

void drawAngleText(int angle) {
  translate((width - width * 0.4994) + width / 2 * cos(radians(angle)),
            (height - height * 0.0907) - width / 2 * sin(radians(angle)));
  rotate(-radians(60 - angle));
  text(angle + "°", 0, 0);
  resetMatrix();
}
