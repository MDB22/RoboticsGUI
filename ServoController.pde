import controlP5.*;
import cc.arduino.*;

public class ServoController {

  TextBoxGUI textbox;
  KnobGUI knob;
  int servoID;
  int pwmPin;

  String name;

  ServoController(Arduino arduino, ControlP5 cp5, int servoID, MatrixGUI matrixGUI) {
    println("creating servocontroller "+servoID);
    this.name = Constants.CONTROLLER_NAMES[servoID];
    this.servoID = servoID;  //this will be a number between 0 and 5 (6 including gripper)
    this.pwmPin = Constants.PWM_PINS[servoID];
    if (arduino != null) {
      arduino.pinMode(this.pwmPin, Arduino.SERVO);
    }
    println("creating knob");
    knob = new KnobGUI(arduino, this.pwmPin, cp5, servoID); 
    println("created knob");
    //if (servoID!=6){
    textbox = new TextBoxGUI(arduino, this.pwmPin, cp5, servoID);
    textbox.setKnobGUI(knob);
    knob.setTextBoxGUI(textbox);
    knob.setMatrixGUI(matrixGUI);
    //}
    println("servocontroller "+servoID+" created.");
  }

  public int getID() {
    return servoID;
  }

  public float getValue() {
    return knob.getValue();
  }

  public void setJointAngle(float jointAngle) {
    println("setJointAngle: "+jointAngle);
    textbox.setValue(Float.toString(jointAngle));
    println("starting knob.setvalue");
    knob.setValue(jointAngle);
    println("starting knob.setservovalue");
    knob.setServoAngle((int) jointAngle);
    println("finished setjointangle");
  }

  public void setPinMode(boolean attach) {
    if (arduino != null) {
      if (attach) {
        arduino.pinMode(this.pwmPin, Arduino.SERVO);
      } else {
        arduino.pinMode(this.pwmPin, Arduino.INPUT);
      }
    }
  }
}

