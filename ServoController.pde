import controlP5.*;
import cc.arduino.*;

public class ServoController {

  TextBoxGUI textbox;
  KnobGUI knob;
  int servoID;
  int pwmPin;

  String name;

  /* ServoController
   Inputs:
   Arduino arduino - arduino object used to control servo
   int pin - pin number for input signal to servo
   int aPin - pin number for feedback signal from servo
   ControlP5 cp5 - root controller object
   String name - name of the controller to display
   int xBox, yBox - x and y posititions of the text box area
   int width, height - width and height of the text box area
   int xKnob, yKnob - x and y positions of the knob controller
   int radius - radius of the knob controller
   float min, max, initial - min, max and initial values for controller
   */
  //ServoController(ControlP5 cp5, ControlDescriptor descriptor) {
  ServoController(Arduino arduino, ControlP5 cp5, int servoID, MatrixGUI matrixGUI) {
    this.name = Constants.CONTROLLER_NAMES[servoID];
    this.servoID = servoID;  //this will be a number between 0 and 5 (6 including gripper)
    this.pwmPin = Constants.PWM_PINS[servoID];
    if (arduino != null) {
      arduino.pinMode(this.pwmPin, Arduino.SERVO);
    }
    textbox = new TextBoxGUI(arduino, this.pwmPin, cp5, servoID);
    knob = new KnobGUI(arduino, this.pwmPin, cp5, servoID); 
    textbox.setKnobGUI(knob);
    knob.setTextBoxGUI(textbox);
    knob.setMatrixGUI(matrixGUI);
  }

  public float getValue() {
    return knob.getValue();
  }

  public void setJointAngle(float jointAngle) {
    textbox.setValue(Float.toString(jointAngle));
    knob.setValue(jointAngle);
  }
}

