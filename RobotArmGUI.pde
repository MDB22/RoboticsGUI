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

// GUI elements
ArrayList<ServoController> servos = new ArrayList<ServoController>();
ArrayList<TextAreaGUI> display = new ArrayList<TextAreaGUI>();
MatrixGUI matrixDisplay;

// Global variables for stored/logged data, and controls
float home[] = new float[Constants.NUM_SERVOS];
ArrayList<float[]> data = new ArrayList<float[]>();
Toggle logData;

// MATLAB control variables
MatlabComm comm;
MatlabTypeConverter converter;
MatlabNumericArray array;

// Simulator
RobotGUI robotDisplay;

// Colours for rendering
color background = color(4, 79, 111);
color outline = color(84, 145, 158);

// Keeps track of timefor computations
long time = 0;

// Variable to indicate a motion command
boolean move = false;

void setup() {
  size(1200, 800, P3D);

  cp5 = new ControlP5(this);
  frame.setResizable(true);
  frame.setTitle("Controller");

  /*
   //UNCOMMENT HERE
   // Prints out the available serial ports.
   println(Arduino.list());
   
   // Modify this line, by changing the "0" to the index of the serial
   // port corresponding to your Arduino board (as it appears in the list
   // printed by the line above).
   arduino = new Arduino(this, "COM4", 57600);
   
   // Set the Arduino digital pins as inputs.
   arduino.pinMode(13, Arduino.SERVO);
   
*/
  // Read the home position from the text file
  home = float(loadStrings("data/home.txt"));

  // Add buttons to UI
  addButtons();

  // Add logging control to UI
  addLogging();

  // Add display areas
  addDisplay();

  // Add display for the matrix
  addMatrixDisplay();

  // Add servo controllers to UI
  addServos();

  // Add user input commands
  addUserInput();

  // Add simulated robot
  addRobotDisplay();

  // Allow for scrolling in knob controls
  addMouseWheelListener();

  // Initialise MATLAB communication
  //initMATLAB();
}

void draw() {
  background(background);
  stroke(outline);

  drawText();

  // Update displays with feedback from servos
  for (TextAreaGUI t : display) {
    t.updateValue();

  }

  //rect(matrixDisplay.jointAngles[0],70,10,100);
  robotDisplay.drawRobot();
}

void drawText() {
  // Title text
  textSize(25);
  textAlign(CENTER);
  text("Welcome to our Robot Control Panel", width/2, 30);

  // Draw GUI text
  textSize(18);
  text("Servo Values", Constants.DISPLAY_X, Constants.DISPLAY_Y - 20);
  textAlign(LEFT);
  text("Servo Controls", Constants.XBOX, Constants.YBOX - 20);
  text("Transformation Matrix", Constants.MATRIX_X, Constants.MATRIX_Y - 20);
  text("Jacobian Matrix", Constants.MATRIX_X, Constants.MATRIX_Y +120);

  textSize(10);
  text("Rotation", Constants.MATRIX_X, Constants.MATRIX_Y -5);
  text("x-translation", Constants.MATRIX_X_LABEL, Constants.MATRIX_Y_LABEL);
  text("y-translation", Constants.MATRIX_X_LABEL, Constants.MATRIX_Y_LABEL+Constants.MATRIX_ELEMENT_HEIGHT);
  text("z-translation", Constants.MATRIX_X_LABEL, Constants.MATRIX_Y_LABEL+2*Constants.MATRIX_ELEMENT_HEIGHT);

  text("JOmega", Constants.MATRIX_X_LABEL+2*Constants.MATRIX_ELEMENT_WIDTH, Constants.MATRIX_Y_LABEL+155);
  text("JV", Constants.MATRIX_X_LABEL+2*Constants.MATRIX_ELEMENT_WIDTH, Constants.MATRIX_Y_LABEL+225);
}

void addButtons() {
  for (int i = 0; i < Constants.NUM_BUTTONS; i++) {
    cp5.addButton(Constants.BUTTON_NAMES[i])
      .setPosition(Constants.BUTTON_X, Constants.BUTTON_Y + i*Constants.BUTTON_SEPARATION)
        .setSize(Constants.BUTTON_WIDTH, Constants.BUTTON_HEIGHT)
          ;
  }
}

void addLogging() {
  logData = new Toggle(cp5, Constants.LOGBUTTON_NAME);
  logData.setPosition(Constants.LOG_XPOS, Constants.LOG_YPOS);
  logData .setSize(Constants.LOG_XSIZE, Constants.LOG_YSIZE);
}

void addDisplay() {
  for (int servoID = 0; servoID < Constants.NUM_SERVOS; servoID++) {
    display.add(new TextAreaGUI(arduino, cp5, servoID));
  }
}

void addMatrixDisplay() {
  matrixDisplay = new MatrixGUI(cp5, Constants.MATRIX_X, Constants.MATRIX_Y, 
  Constants.MATRIX_X_SEPARATION, Constants.MATRIX_Y_SEPARATION, 
  Constants.MATRIX_ELEMENT_WIDTH+5, Constants.MATRIX_ELEMENT_HEIGHT);
}

void addServos() {
  for (int servoID = 0; servoID < Constants.NUM_SERVOS; servoID++) {    
    servos.add(new ServoController(arduino, cp5, servoID, matrixDisplay));
  }
}

void addUserInput() {
  for (int i = 0; i < Constants.NUM_POSE_INPUTS; i++) {
    cp5.addTextfield(Constants.POSE_INPUT_NAMES[i], Constants.POSE_INPUT_X, Constants.POSE_INPUT_Y + 
      i*(Constants.POSE_INPUT_Y_SEP + Constants.POSE_INPUT_HEIGHT), Constants.POSE_INPUT_WIDTH, Constants.POSE_INPUT_HEIGHT)
      .setText("0");
  }
}

void addRobotDisplay() {
  robotDisplay = new RobotGUI(matrixDisplay);
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

void initMATLAB() {
  try {
    // Set up new MATLAB proxy session
    comm = new MatlabComm();
    comm.proxy.eval("clc");
    comm.proxy.eval("clear all");

    // Converts MATLAB data types to Java types and vice versa
    converter = new MatlabTypeConverter(comm.proxy);

    for (TextAreaGUI d : display) {
      comm.proxy.setVariable("q" + d.getLabel(), float(d.getText()));
    }
  } 
  catch (Exception e) {
    println("Exception caught!");
  }
}

// Event handler for "Start" button
public void Start() {
  // Checks to see if desired pose is possible
  // CheckValues();

  try {
    // Then sends desired position to MATLAB workspace
    for (int i = 0; i < Constants.NUM_POSE_INPUTS; i++) {
      Textfield t = (Textfield) cp5.getController(Constants.POSE_INPUT_NAMES[i]);
      comm.proxy.setVariable(t.getName(), float(t.getText()));
    }

    // Then sends the current joint angles (given by feedback) to MATLAB workspace
    for (TextAreaGUI d : display) {
      comm.proxy.setVariable("q" + d.getLabel(), float(d.getText()));
    }

    // Enables motion
    move = true;

    // Then gets MATLAB to generate the desired path 
    // based on the initial and final points
    comm.proxy.eval("runTJ");
  }
  catch(Exception e) {
    println("Bad MATLAB");
  }
}

// Event handler for "Stop" button
public void Stop() {
  move = false;
}

public void Zero() {
  for (ServoController s : servos) {
    s.setJointAngle(0);
  }
}

// Event handler for "Home" button
public void Home() {
  int count = 0;

  for (ServoController s : servos) {
    s.setJointAngle(home[count]);
    count++;
  }
}

// Event handler for "SetHome" button
public void SetHome() {
  String stringData[] = new String[Constants.NUM_SERVOS];

  int count = 0;

  for (TextAreaGUI d : display) {
    stringData[count] = d.getText();
    count++;
  }

  saveStrings("data/home.txt", stringData);
}

// Event handler for "Record" button
public void Record() {

  // Make sure that logging is enabled
  logData.setState(true);

  // Collect the data and add it to our list
  float[] d = new float[Constants.NUM_SERVOS];
  for (TextAreaGUI t : display) {
    d[t.getID()] = float(t.getText());
  }

  data.add(d);
}

// Event handler for "Exit" button
public void Exit() {

  if (logData.getState()) {
    String stringData[] = new String[data.size()];

    int count = 0;

    for (float[] f : data) {
      stringData[count] = "";

      for (int i = 0; i < f.length; i++) {
        stringData[count] += String.format("%3.2f", f[i]) + " ";
      }
      count++;
    }

    saveStrings("data/log.txt", stringData);
  }

  exit();
}

public void LogData(boolean flag) {
}

public void keyPressed() {
  switch(key) {
    case ('q') :
    exit();
    break;
  }
}

