import controlP5.*;

public class TextBoxGUI extends Textfield {

  Arduino arduino;
  int pin;

  public KnobGUI knob;

  public TextBoxGUI(Arduino arduino, int pin, ControlP5 cp5, String name, 
  int xBox, int yBox, int width, int height) {
    super(cp5, name);

    this.arduino = arduino;
    this.pin = pin;

    this.setPosition(xBox, yBox);
    this.setWidth(width);
    this.setHeight(height);
    this.setText("0");
    this.setAutoClear(false);

    this.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        try {
          float val = Float.parseFloat(e.getStringValue());
          if (val >= knob.getMin() && val <= knob.getMax()) {
            knob.setValue(val);
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

