import controlP5.*;

public class TextBoxGUI extends Textfield {

  Arduino arduino;
  int pin;

  public KnobGUI knob;

  public TextBoxGUI(Arduino arduino, int pin, ControlP5 cp5, int servoID) {
    super(cp5, Constants.CONTROLLER_NAMES[servoID]);

    this.arduino = arduino;
    this.pin = Constants.PWM_PINS[servoID];
    this.setPosition(Constants.XBOX, Constants.YBOX + servoID*Constants.TEXTBOX_SEPARATION);
    this.setWidth(Constants.TEXTBOX_WIDTH);
    this.setHeight(Constants.TEXTBOX_HEIGHT);
    this.setText("0");
    this.setAutoClear(false);

    this.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        try {
          float jointAngle = Float.parseFloat(e.getStringValue());
          if (jointAngle >= knob.getMin() && jointAngle <= knob.getMax()) {
            knob.setValue(jointAngle);
          }
        } 
        catch(NumberFormatException nfe) {
        }
      }
    }
    );
  }

  public void setKnobGUI(KnobGUI knob) {
    this.knob = knob;
    this.setText(String.format("%3.2f", knob.getValue()));
  }

  public void mousePressed() {
    this.setText(""); 
    this.setFocus(true);
  }
}

