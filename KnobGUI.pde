import controlP5.*;

public class KnobGUI extends Knob {

  private final Arduino arduino;

  private int pin;
  private float target;
  private float cur_pos;

  private TextBoxGUI textbox;
  private MatrixGUI matrixGUI;

  private String name;

  private float minAngle, maxAngle;
  private int qCurrent;

  private final int ID;

  public KnobGUI(Arduino arduino, int pin, ControlP5 cp5, int servoID) {
    super(cp5, Constants.CONTROLLER_NAMES[servoID] + "Knob");
    this.name = Constants.CONTROLLER_NAMES[servoID];

    this.arduino = arduino;
    this.pin = pin;

    this.minAngle = Constants.MIN_ANGLE[servoID];
    this.maxAngle = Constants.MAX_ANGLE[servoID];

    this.setPosition(Constants.XKNOB[servoID/3], Constants.YKNOB[servoID%3]);
    this.setRadius(Constants.KNOB_RADII[servoID]);
    this.setRange(minAngle, maxAngle);
    this.setValue(home[servoID]);
    this.setLabel(this.name);
    this.setNumberOfTickMarks(Constants.NUM_TICKS);
    this.setShowAngleRange(false);
    this.qCurrent = (int) home[servoID];

    this.ID = servoID;

    this.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        float val = e.getValue();
        textbox.setText(String.format("%.2f", val));
        matrixGUI.updateJointValue(ID, val);
        setServoAngle((int) val);
      }
    }
    );
  }

  // Retrieves feedback from the servo potentiometers
  public float getFeedback() {
    if (arduino != null) {
      return arduino.analogRead(pin);
    } else {
      return 0;
    }
  }

  // When position commands are sent via the GUI (Knob or TextBox),
  // this method will smoothly move the joint to the desired angle
  public void setServoAngle(int qDesired) {
    int targetValue = Constants.SERVO_DIR[ID]*qDesired + Constants.SERVO_OFFSET[ID];
    int currentValue = Constants.SERVO_DIR[ID]*qCurrent + Constants.SERVO_OFFSET[ID];

    println("Setting servo "+ID+" to joint angle "+qDesired+". ");
    println("corresponds to servoValue "+targetValue);
    println("currently at servoValue "+currentValue);

    if (currentValue < targetValue) {
      while (currentValue < targetValue) {
        if (millis()-time >=100) {
          currentValue++;
          if (arduino != null) {
            arduino.servoWrite(pin, currentValue);
          }
          time = millis();
          println("current servo value in while loop: "+currentValue);
          println("current servo value: "+currentValue+", target: "+targetValue);
        }
      }
      println("left while loop");
    } else if (currentValue > targetValue) {
      while (currentValue > targetValue) {
        if (millis()-time >=100) {
          currentValue--;
          if (arduino != null) {
            arduino.servoWrite(pin, currentValue);
          }
          time = millis();
          println("current servo value in while loop: "+currentValue);
          println("current servo value: "+currentValue+", target: "+targetValue);
        }
      }
      println("left while loop");
    }
    this.qCurrent = qDesired;
    println("servo value now at: "+currentValue);

    /*targetValue = map(jointAngle, Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
     curPosServoValue = map(arduino.analogRead(pin), min, max, 0, 170);
     
     
     if(cur_pos > targetValue) {
     while(abs(cur_pos - target) > 10) {
     arduino.servoWrite(pin, (int)cur_pos--);
     }
     } else if(cur_pos < target) {
     while(abs(cur_pos - target) > 10) {
     arduino.servoWrite(pin, (int)cur_pos++);
     }        
     }
     
     
     if ((servoID == 0)||(servoID == 1)||(servoID == 4)){
     jointAngle = -jointAngle;        //joint angle between MIN and MAX.           -146 to 24.         0 -> 0        
     }
     println("current angle is "+this.getValue());
     int currServoValue =  (int) map(this.getValue(), Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
     int targetValue = (int) map(jointAngle, Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
     int time = millis();
     if (currServoValue < targetValue) {
     while((currServoValue < targetValue)&&(millis()-time >=2000)) {
     arduino.servoWrite(pin, currServoValue++);
     time = millis();
     println(time);
     
     }
     }
     
     else{    
     float servoValue = map(jointAngle, Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
     arduino.servoWrite(pin, (int) servoValue);
     //  }
     //}
     */
  }

  public void setTextBoxGUI(TextBoxGUI textbox) {
    this.textbox = textbox;
  }

  public void setMatrixGUI(MatrixGUI matrixGUI) {
    this.matrixGUI = matrixGUI;
  }

  /*public void updateValue(float value) {
   if (value >= minAngle && value <= maxAngle) {
   this.setValue(value);
   }
   }*/
}

