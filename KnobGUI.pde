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
  private int currentJointAngle;
  
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
    this.currentJointAngle = (int) home[servoID];
    setServoValue(this.currentJointAngle, servoID);
    
    this.ID = servoID;
    
    this.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        float val = e.getValue();
        textbox.setText(String.format("%.2f", val));
        matrixGUI.updateJointValue(ID, val);
        setServoValue((int) val, ID);
      }
    }
    );
  }

  public void setServoValue(int jointAngle, int servoID) {

    int targetServoValue = Constants.SERVO_DIR[servoID]*jointAngle + Constants.SERVO_OFFSET[servoID];
    int currentServoValue = Constants.SERVO_DIR[servoID]*currentJointAngle + Constants.SERVO_OFFSET[servoID];
    println("Setting servo "+servoID+" to joint angle "+jointAngle+" = servoValue "+targetServoValue);
    println("currently at servoValue "+currentServoValue);
    
    if (currentServoValue < targetServoValue) {
      while(currentServoValue < targetServoValue) {
        if (millis()-time >=100){
          currentServoValue++;
          if (arduino != null){
            arduino.servoWrite(pin, currentServoValue);
          }
          time = millis();
        }
      }      
    }
    else if (currentServoValue > targetServoValue) {
      while(currentServoValue > targetServoValue) {
        if (millis()-time >=100){
          currentServoValue--;
          if (arduino != null){
            arduino.servoWrite(pin, currentServoValue);
          }
          time = millis();
        }
      } 
    }
    this.currentJointAngle = jointAngle;
  }
      
      
      /*targetServoValue = map(jointAngle, Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
      curPosServoValue = map(arduino.analogRead(pin), min, max, 0, 170);
      
      
      if(cur_pos > targetServoValue) {
        while(abs(cur_pos - target) > 10) {
          arduino.servoWrite(pin, (int)cur_pos--);
        }
      } else if(cur_pos < target) {
        while(abs(cur_pos - target) > 10) {
          arduino.servoWrite(pin, (int)cur_pos++);
        }        
      }*/
      
      /*
      if ((servoID == 0)||(servoID == 1)||(servoID == 4)){
        jointAngle = -jointAngle;        //joint angle between MIN and MAX.           -146 to 24.         0 -> 0        
      }
      /*println("current angle is "+this.getValue());
      int currServoValue =  (int) map(this.getValue(), Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
      int targetServoValue = (int) map(jointAngle, Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
      int time = millis();
      if (currServoValue < targetServoValue) {
        while((currServoValue < targetServoValue)&&(millis()-time >=2000)) {
          arduino.servoWrite(pin, currServoValue++);
          time = millis();
          println(time);
          
        }
      }
      
      else{*/
        /*
        float servoValue = map(jointAngle, Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
        arduino.servoWrite(pin, (int) servoValue);*/
//  }
//}

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

