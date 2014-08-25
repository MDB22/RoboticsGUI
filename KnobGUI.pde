import controlP5.*;

public class KnobGUI extends Knob {

  final Arduino arduino;
  int pin;
  float target;
  float cur_pos;
  public TextBoxGUI textbox;
  public MatrixGUI matrixGUI;
  String name;

  private float minAngle, maxAngle;

  //private boolean 

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
    final int servoNum = servoID;

    this.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        float val = e.getValue();
        textbox.setText(String.format("%.2f", val));
        matrixGUI.updateJointValue(servoNum, val);
        setServoValue((int) val, servoNum);
      }
    }
    );
  }

  public void setServoValue(int jointAngle, int servoID) {
    if (arduino != null) {
      
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
      float servoValue = map(jointAngle, Constants.MIN_ANGLE[servoID], Constants.MAX_ANGLE[servoID], Constants.SERVOVAL_MIN, Constants.SERVOVAL_MAX);
      arduino.servoWrite(pin, (int) servoValue);
    }
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

