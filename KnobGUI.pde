import controlP5.*;

public class KnobGUI extends Knob {

  final Arduino arduino;
  int pin;

  public TextBoxGUI textbox;

  private float min, max;

  //private boolean 

  public KnobGUI(Arduino arduino, int pin, ControlP5 cp5, String name, 
  int x, int y, int radius, float min, float max, float start) {
    super(cp5, name + "Knob");

    this.arduino = arduino;
    this.pin = pin;

    this.min = min;
    this.max = max;

    this.setPosition(x, y);
    this.setRadius(radius);
    this.setRange(min, max);
    this.setValue(start);
    this.setLabel(name);
    this.setNumberOfTickMarks(Constants.NUM_TICKS);
    this.setShowAngleRange(false);

    this.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        float val = e.getValue();
        textbox.setText(String.format("%.2f", val));
        setServoValue((int) val);
      }
    }
    );
  }

  public void setServoValue(int value) {
    if (arduino != null) {
      arduino.servoWrite(pin, value);
    }
  }

  public void setTextBoxGUI(TextBoxGUI textbox) {
    this.textbox = textbox;
  }

  public void updateValue(float value) {
    if (value >= min && value <= max) {
      this.setValue(value);
    }
  }
}

