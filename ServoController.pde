import controlP5.*;
import cc.arduino.*;

public class ServoController {

  TextBoxGUI textbox;
  KnobGUI knob;
  int servoID;
  int pwmPin;

  String name;
  
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

  public int getID() {
    return servoID;
  }

  public void setJointAngle(float jointAngle) {
    textbox.setValue(Float.toString(jointAngle));
    knob.setValue(jointAngle);
  }
}

