/*
 
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
float poses[][];
float jointSequence[][];
String gripper_actions[];
int numActions;
int numJointActions;
String gripper_joint_actions[];
ArrayList<float[]> data = new ArrayList<float[]>();

Toggle logData;
Toggle attach;

// MATLAB control variables
MatlabComm comm;
MatlabTypeConverter converter;
MatlabNumericArray array;
boolean invalidLinearTrajectory;
boolean invalidp2pTrajectory;

// Simulator
RobotGUI robotDisplay;

// Colours for rendering
color background = color(4, 79, 111);
color outline = color(84, 145, 158);

// Keeps track of time for computations
long time = 0;

float currentTime = 0;
float lastTime = 0;
float timeSinceCommand = 0;
float finalTime = 0;
int movementNum = 0;
int trajectory_iteration = 1;          // use this to get the correct column from the joint angle matrix q

// Variable to indicate a motion command
boolean move = false;
boolean inSequence = false;
boolean inJointSequence = false;

int kinect_number = 0;
String buffer = "";

Serial myPort;

void setup() {
  size(1200, 800, P3D);

  cp5 = new ControlP5(this);
  frame.setResizable(true);
  frame.setTitle("Controller");
  
//  println(Serial.list());
//  myPort = new Serial(this, "COM6", 9600);

  //UNCOMMENT HERE
  // Prints out the available serial ports.
  println(Arduino.list());

  //   // Modify this line, by changing the "0" to the index of the serial
  //   // port corresponding to your Arduino board (as it appears in the list
  //   // printed by the line above).
  //   arduino = new Arduino(this, "COM4", 57600);
  //   
  //   // Set the Arduino digital pins as inputs.
  //   arduino.pinMode(13, Arduino.SERVO);
  //   println("connected.");   

  // Read the home position from the text file
  home = float(loadStrings("data/home.txt"));
  String[] strings = loadStrings("data/positions.txt");
  numActions = strings.length;
  gripper_actions = new String[numActions];
  poses = new float[numActions][6];
  println(strings.length);
  for (int i=0; i<strings.length; i++) {
    String[] data = split(strings[i], ' ');
    float[] pose_i = float(split(data[0], ','));
    gripper_actions[i] = data[1];
    poses[i] = pose_i;
  }

  for (int j=0; j<numActions; j++) {
    println(poses[j][0]+","+poses[j][1]);
  }
  
  //for joints
  String[] jointStrings = loadStrings("data/jointSequence.txt");
  numJointActions = jointStrings.length;
  gripper_joint_actions = new String[numJointActions];
  jointSequence = new float[numJointActions][6];
  println("numJointActions is "+numJointActions);
  for (int i=0; i<jointStrings.length; i++) {
    String[] jointData = split(jointStrings[i], ' ');
    println("jointData is "+jointData[0]+", "+jointData[1]);
    float[] joints_i = float(split(jointData[0], ','));
    gripper_joint_actions[i] = jointData[1];
    jointSequence[i] = joints_i;
  }
    

  // Add buttons to UI
  addButtons();

  // Add logging control to UI
  addLogging();

  // Add servo attach/detach control to UI
  addAttach();

  // Add display areas
  addDisplay();

  // Add display for the matrix
  addMatrixDisplay();

  // Add servo controllers to UI
  addServos();

  // Add user input commands
  addUserInput();
  //println("added user input");
  // Add simulated robot
  addRobotDisplay();

  //println("added user display");

  // Allow for scrolling in knob controls
  addMouseWheelListener();
  // Initialise MATLAB communication
  initMATLAB();
  Home();
  println("----------------------------------------------------------------------");
}

void draw() {
  //println("start draw");
  //try {
  //println("starting draw");
  background(background);
  stroke(outline);
  lastTime = currentTime;
  currentTime = millis();
  
//while (myPort.available() > 0) {
//int inByte = myPort.read();
//char charByte = (char) inByte;
//if (charByte=='\n'){
//  //parse_current_line(buffer);
//  println(buffer);
////  println(" yay");
//  buffer = "";
//  
//}
//else{
//  buffer = buffer+charByte;
//}/*
//  kinect_number++;
//  if(kinect_number==11){
//    kinect_number=0;
//  }
//  print(" <"+kinect_number+"> ");
//} else {
//  if (kinect_number==1){
//    //get x value.
//    print(charByte);
//  }
//}*/
//
//}// my robot is first one position xyz in our reference fram.e


  drawText();
  if (arduino!=null) {
    //println("gripper feedback"+arduino.analogRead(Constants.GRIPPER_A_PIN));
  }

  // Update displays with feedback from servos
  for (TextAreaGUI t : display) {
    t.updateValue();
  }

  try {
    if (move) { 
      trajectory_iteration++;
      float dt = currentTime - lastTime;
      //println("moving: t="+currentTime);

      // Get next set of joint angles for motion
      comm.proxy.eval("qNew = getNextPosition2(q_array,"+trajectory_iteration+");");
      double[][] qNew = converter.getNumericArray("qNew").getRealArray2D();

      //print("iteration is "+String.format("%d",trajectory_iteration)+"\n");
      //print("qNew is: [");
      //for (int i=0; i<6; i++){
      //  print(String.format("%3.2f, ",qNew[i][0]));
      //}
      //print("]\n");

      timeSinceCommand += dt;

      //println("current: "+currentTime + "  last: " + lastTime + "  timesincecommand: " + timeSinceCommand + "  dt: " + dt + "  final: " + finalTime);

      int count = 0;
      for (ServoController s : servos) {
        s.knob.setValue((float) (qNew[count][0]));
        count++;
        if (count == 6) {
          break;
        }
      }

      //if (timeSinceCommand > finalTime) {
      if (trajectory_iteration==150) {
        move = false;
        timeSinceCommand = 0;
      }
      //println("finished one move");
    } else if (inSequence) {
      String gripper_action = gripper_actions[movementNum];
      println(gripper_action);
      if (gripper_action.equals("close")) {
        println("command is close");
        closeGripper();
      } else {
        println("command is open");
        openGripper();
      }
      println("starting next sequence");
      movementNum++;
      if (movementNum<numActions) {
        float[] pose = poses[movementNum];
        for (int i=0; i< 6; i++) {
          Textfield t = (Textfield) cp5.getController(Constants.POSE_INPUT_NAMES[i]);
          println(pose[i]);
          t.setText(pose[i]+"");
        }
        Start_p2p();
      } else {
        inSequence = false;
      }
    } else if (inJointSequence) {
      String gripper_action = gripper_joint_actions[movementNum];
      println(gripper_action);
      if (gripper_action.equals("close")) {
        println("command is close");
        closeGripper();
      } else {
        println("command is open");
        openGripper();
      }
      println("starting next sequence");
      movementNum++;
      if (movementNum<numJointActions) {
        float[] joints = jointSequence[movementNum];
        Start_joints(joints);
      } else {
        inJointSequence = false;
      }
    }
  } 
  catch (Exception e) {
    println("Bad MATLAB in getNextPosition.m");
    println(e.getMessage());
  }

  //rect(matrixDisplay.jointAngles[0],70,10,100);
  robotDisplay.drawRobot();
  //println("finished draw");
  /*} catch(Exception e) {
   println(e);
   }*/
  //println("end draw");
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

  text("JV", Constants.MATRIX_X_LABEL+2*Constants.MATRIX_ELEMENT_WIDTH, Constants.MATRIX_Y_LABEL+155);
  text("JOmega", Constants.MATRIX_X_LABEL+2*Constants.MATRIX_ELEMENT_WIDTH, Constants.MATRIX_Y_LABEL+225);

  textSize(25);

  if (invalidLinearTrajectory) {
    text("Can't implement Linear trajectory from here.", Constants.TRAJECTORY_MSG_X, Constants.TRAJECTORY_MSG_Y);
    text("Please choose another end point,", Constants.TRAJECTORY_MSG_X, Constants.TRAJECTORY_MSG_Y + 50);
    text("or try p2p", Constants.TRAJECTORY_MSG_X, Constants.TRAJECTORY_MSG_Y + 100);
  }
  if (invalidp2pTrajectory) {
    text("Can't find point to point trajectory.", Constants.TRAJECTORY_MSG_X, Constants.TRAJECTORY_MSG_Y);
    text("Find another point to go to", Constants.TRAJECTORY_MSG_X, Constants.TRAJECTORY_MSG_Y + 50);
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

void addLogging() {
  logData = new Toggle(cp5, Constants.LOGBUTTON_NAME);
  logData.setPosition(Constants.TOGGLE_XPOS, Constants.LOG_YPOS);
  logData.setSize(Constants.TOGGLE_XSIZE, Constants.TOGGLE_YSIZE);
}

void addAttach() {
  attach = new Toggle(cp5, Constants.ATTACHBUTTON_NAME);
  attach.setPosition(Constants.TOGGLE_XPOS, Constants.ATTACH_YPOS);
  attach.setSize(Constants.TOGGLE_XSIZE, Constants.TOGGLE_YSIZE);
  attach.setState(true);
}

void addDisplay() {
  for (int servoID = 0; servoID < Constants.NUM_SERVOS-1; servoID++) {
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
    //if (servoID != 1){
    servos.add(new ServoController(arduino, cp5, servoID, matrixDisplay));
    //}
  }
}

void detachServos() {
  for (int servoID = 0; servoID < Constants.NUM_SERVOS; servoID++) {    
    servos.remove(0);
  }
  for (int servoID = 0; servoID < Constants.NUM_SERVOS; servoID++) {  
    arduino.pinMode(Constants.PWM_PINS[servoID], Arduino.OUTPUT);
    print("Detached servo: ");
    println(Constants.PWM_PINS[servoID]);
  }
}

void addUserInput() {
  for (int i = 0; i < Constants.NUM_POSE_INPUTS; i++) {
    cp5.addTextfield(Constants.POSE_INPUT_NAMES[i], Constants.POSE_INPUT_X, Constants.POSE_INPUT_Y + 
      i*(Constants.POSE_INPUT_Y_SEP + Constants.POSE_INPUT_HEIGHT), Constants.POSE_INPUT_WIDTH, Constants.POSE_INPUT_HEIGHT)
      .setText(Constants.DEFAULT_USER_INPUT[i]);
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
    
    comm.proxy.setVariable("max_angle", Constants.MAX_ANGLE);    //put joint limits into matlab for checking
    comm.proxy.setVariable("min_angle", Constants.MIN_ANGLE);
    
    for (int i=0;i<6;i++){
      comm.proxy.setVariable("q_final"+i, 0);
    }
  } 
  catch (Exception e) {
    println("Exception caught!");
  }
}

public void Start_sequence() {
  //closeGripper();
    inSequence = true;
      float[] pose = poses[movementNum];
      for (int i=0; i< 6;i++) {
        Textfield t = (Textfield) cp5.getController(Constants.POSE_INPUT_NAMES[i]);
        println(pose[i]);
        t.setText(pose[i]+"");
      }
      Start_p2p();
}

public void Start_joint_sequence() {
  inJointSequence = true;
  float[] joints = jointSequence[movementNum];
  Start_joints(joints);
}



public void Start_linear() {

  try {
    // Send desired position to MATLAB workspace
    for (int i = 0; i < Constants.NUM_POSE_INPUTS; i++) {
      Textfield t = (Textfield) cp5.getController(Constants.POSE_INPUT_NAMES[i]);
      comm.proxy.setVariable(t.getName(), float(t.getText()));

      if (t.getName().equals("Time")) {
        // Make sure to convert to milliseconds
        finalTime = float(t.getText()) * 1000;
      }
    }

    // Then send the current joint angles to MATLAB workspace
    //for (TextAreaGUI d : display) {
    for (ServoController s : servos) {
      comm.proxy.setVariable("q" + s.name, s.getValue());
    }

    // Then get MATLAB to generate the desired path 
    // based on the initial and final points
    println("--------------------- generating linear trajectory... ---------------------");
    comm.proxy.eval("generate_trajectory_linear");
    trajectory_iteration = 1;

    //Test to see if successful trajectory is implementable.
    comm.proxy.eval("qbounds = get_qbounds(outside)");
    double[][] boundsArray = converter.getNumericArray("qbounds").getRealArray2D();
    println("boundsArray is "+boundsArray[0][0]);
    if (boundsArray[0][0]==1) {
      invalidLinearTrajectory = true;
      move=true;
    } else {
      // Enables motion
      invalidLinearTrajectory = false;
      move = true;
    }
  }
  catch(Exception e) {
    println("Bad MATLAB in TrajectoryGeneration.m");
  }
}

public void Start_joints(float[] final_joints) {
  try{
    for (int i=0; i<6; i++){
      String varName = "q_final"+i;
      println(varName+" = "+final_joints[i]);
      comm.proxy.setVariable(varName, final_joints[i]);
    }
    for (ServoController s : servos) {
      comm.proxy.setVariable("q" + s.name, s.getValue());
    }
    println("------------------------Starting joint trajectory --------------------------------------------");
    comm.proxy.eval("generate_trajectory_joints");
    move = true;
    trajectory_iteration = 1;
  }
  catch (Exception e){
    println("exception in start_joints");
  }
}

// Event handler for "Start" button
public void Start_p2p() {

  try {
    // Send desired position to MATLAB workspace
    for (int i = 0; i < Constants.NUM_POSE_INPUTS; i++) {
      Textfield t = (Textfield) cp5.getController(Constants.POSE_INPUT_NAMES[i]);
      comm.proxy.setVariable(t.getName(), float(t.getText()));

      if (t.getName().equals("Time")) {
        // Make sure to convert to milliseconds
        finalTime = float(t.getText()) * 1000;
      }
    }

    // Then send the current joint angles to MATLAB workspace
    //for (TextAreaGUI d : display) {
    for (ServoController s : servos) {
      comm.proxy.setVariable("q" + s.name, s.getValue());
    }

    // Then get MATLAB to generate the desired path 
    // based on the initial and final points
    println("--------------------- generating point to point trajectory... ---------------------");
    comm.proxy.eval("generate_trajectory_p2p");
    trajectory_iteration = 1;

    //Test to see if successful trajectory is implementable.
    comm.proxy.eval("qbounds = get_qbounds(outside)");
    double[][] boundsArray = converter.getNumericArray("qbounds").getRealArray2D();
    println("boundsArray is "+boundsArray[0][0]);
    if (boundsArray[0][0]==1) {
      invalidp2pTrajectory = true;
      move=true;
    } else {
      // Enables motion
      invalidp2pTrajectory = false;
      move = true;
    }
  }
  catch(Exception e) {
    println("Bad MATLAB in TrajectoryGeneration.m");
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

public void ToggleServos() {
  boolean mode = attach.getState();

  for (ServoController s : servos) {
    s.setPinMode(mode);
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



public void openGripper() {
  println("opening gripper");
  if (arduino!=null) {
    servos.get(6).knob.setValue(Constants.OPEN_ANGLE);
    println("servowriting");
    //delay(100);
  }
  println("after opening gripper");
}

public void closeGripper() {
  int feedback = 0;
  int holding = 0;        // trigger counter for gripper not moving       
  int feedback_angle = 0;
  int i;
  boolean moveGripper = true;
  int startTime = millis();
  println("closing gripper at time "+startTime);
  servos.get(6).knob.setValue(Constants.CLOSE_ANGLE);
//  while (moveGripper) {
//    while (millis ()-startTime<200) {
//      println(millis()-startTime);
//    }
//    if (arduino!=null) {
//      println("servowriting to "+Constants.CLOSE_ANGLE);
//      servos.get(6).knob.setValue(Constants.CLOSE_ANGLE);
//      while (millis ()-startTime<200) {
//        println(millis()-startTime);
//      }
//      for (i = 0; i < Constants.ITERATIONS; i++) {
//        feedback += arduino.analogRead(Constants.GRIPPER_A_PIN);
//        print("feedback in loop: "+feedback);
//        //delay(10);
//      }
//      feedback/=i;
//      println("averaged: "+feedback);
//      feedback_angle = (int) map(feedback, Constants.MIN_FEEDBACK[6], Constants.MAX_FEEDBACK[6], Constants.OPEN_ANGLE, Constants.CLOSE_ANGLE); 
//      println("feedbackangle: "+feedback_angle);
//      if (Constants.CLOSE_ANGLE - feedback_angle > 5) {
//        println("increasing holding");
//        holding++;
//        //} else {
//          //println("holding = 0");
//        //  holding = 0;
//      }
//      if (holding > 5) {
//        println("holding>5, servowriting now to "+(feedback_angle-Constants.GRIP_STRENGTH));
//        servos.get(6).knob.setValue(feedback_angle-Constants.GRIP_STRENGTH);
//        moveGripper = false;
//        println("gripping object");
//      }
//    } else {
//      moveGripper = false;
//    }
//  }
//  println("exited while loop");
}

