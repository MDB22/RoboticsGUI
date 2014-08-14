/*
arduino_input
 
 Demonstrates the reading of digital and analog pins of an Arduino board
 running the StandardFirmata firmware.
 
 To use:
 * Using the Arduino software, upload the StandardFirmata example (located
 in Examples > Firmata > StandardFirmata) to your Arduino board.
 * Run this sketch and look at the list of serial ports printed in the
 message area below. Note the index of the port corresponding to your
 Arduino board (the numbering starts at 0).  (Unless your Arduino board
 happens to be at index 0 in the list, the sketch probably won't work.
 Stop it and proceed with the instructions.)
 * Modify the "arduino = new Arduino(...)" line below, changing the number
 in Arduino.list()[0] to the number corresponding to the serial port of
 your Arduino board.  Alternatively, you can replace Arduino.list()[0]
 with the name of the serial port, in double quotes, e.g. "COM5" on Windows
 or "/dev/tty.usbmodem621" on Mac.
 * Run this sketch. The squares show the values of the digital inputs (HIGH
 pins are filled, LOW pins are not). The circles show the values of the
 analog inputs (the bigger the circle, the higher the reading on the
 corresponding analog input pin). The pins are laid out as if the Arduino
 were held with the logo upright (i.e. pin 13 is at the upper left). Note
 that the readings from unconnected pins will fluctuate randomly. 
 
 For more information, see: http://playground.arduino.cc/Interfacing/Processing
 */

import controlP5.*;
import processing.serial.*;
import cc.arduino.*;

ControlP5 cp5;

Arduino arduino;

ArrayList<ServoController> servos = new ArrayList<ServoController>();
ArrayList<TextAreaGUI> display = new ArrayList<TextAreaGUI>();

float home[] = new float[Constants.NUM_SERVOS];

PFont font;

color background = color(4, 79, 111);
color outline = color(84, 145, 158);

void setup() {
  size(900, 500);
  frame.setResizable(true);

  // UNCOMMENT HERE
  //  // Prints out the available serial ports.
  //  println(Arduino.list());
  //
  //  // Modify this line, by changing the "0" to the index of the serial
  //  // port corresponding to your Arduino board (as it appears in the list
  //  // printed by the line above).
  //  arduino = new Arduino(this, "COM4", 57600);
  //
  //  // Set the Arduino digital pins as inputs.
  //  arduino.pinMode(13, Arduino.SERVO);

  cp5 = new ControlP5(this);

  // Read the home position from the text file
  home = float(loadStrings("data/home.txt"));

  font = createFont("ComicSans", 28);

  // Add buttons to UI
  addButtons();

  // Add display areas
  addDisplay();

  // Add servo controllers to UI
  addServos();

  // Allow for scrolling in knob controls
  addMouseWheelListener();
}

void draw() {
  background(background);
  stroke(outline);

  // Title text
  textSize(25);
  textAlign(CENTER);
  text("Welcome to our Robot Control Panel", width/2, 30);

  // Draw GUI text
  textSize(18);
  text("Servo Values", Constants.DISPLAY_X, Constants.DISPLAY_Y - 20);
  textAlign(LEFT);
  text("Servo Controls", Constants.XBOX, Constants.YBOX - 20);

  // Update displays with feedback from servos
  for (TextAreaGUI t : display) {
    t.updateValue();
  }
}

void addButtons() {
  for (int i = 0; i < Constants.NUM_BUTTONS; i++) {
    cp5.addButton(Constants.BUTTON_NAMES[i])
      .setPosition(Constants.BUTTON_X, Constants.BUTTON_Y + i*Constants.BUTTON_SEPARATION)
        .setSize(Constants.BUTTON_WIDTH, Constants.BUTTON_HEIGHT)
          ;
  }
}

void addDisplay() {
  for (int i = 0; i < Constants.NUM_SERVOS; i++) {
    display.add(new TextAreaGUI(arduino, Constants.ANALOG_PINS[i], cp5, 
    Constants.CONTROLLER_NAMES[i], Constants.DISPLAY_X, 
    Constants.DISPLAY_Y + i*Constants.TEXTBOX_SEPARATION, 
    Constants.TEXTBOX_WIDTH, Constants.TEXTBOX_HEIGHT, 
    0, 170, home[i]));
  }
}

void addServos() {
  for (int i = 0; i < Constants.NUM_SERVOS; i++) {    
    servos.add(new ServoController(arduino, Constants.PWM_PINS[i], cp5, 
    Constants.CONTROLLER_NAMES[i], Constants.XBOX, 
    Constants.YBOX + i*Constants.TEXTBOX_SEPARATION, 
    Constants.TEXTBOX_WIDTH, Constants.TEXTBOX_HEIGHT, 
    Constants.XKNOB[i/3], Constants.YKNOB[i%3], Constants.KNOB_RADII[i], 
    0, 170, home[i], Constants.DISPLAY_X, Constants.DISPLAY_Y + i*Constants.TEXTBOX_SEPARATION));
  }
}

// Enables mouse scrolling for knob controls
void addMouseWheelListener() {
  frame.addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
      cp5.setMouseWheelRotation(e.getWheelRotation());
    }
  }
  );
}

// Event handler for "Start" button
public void Start() {
}

// Event handler for "Stop" button
public void Stop() {
}

public void Zero() {
  for (ServoController s : servos) {
    s.setValue(0);
  }
}

// Event handler for "Home" button
public void Home() {
  int count = 0;

  for (ServoController s : servos) {
    s.setValue(home[count]);
    count++;
  }
}

// Event handler for "Record" button
public void Record() {
  String stringData[] = new String[Constants.NUM_SERVOS];

  int count = 0;

  for (ServoController s : servos) {
    stringData[count] = String.format("%3.2f", s.getValue());
    count++;
  }

  saveStrings("data/home.txt", stringData);
}

// Event handler for "Exit" button
public void Exit() {
  exit();
}

public void keyPressed() {
  switch(key) {
    case ('q') :
    exit();
    break;
  }
}

