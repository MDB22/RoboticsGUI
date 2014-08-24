import controlP5.*;

color border = color(0, 0, 0);
color fg = color(1, 108, 158);
color bg = color(2, 52, 77);

public class TextAreaGUI extends Textarea {

  Arduino arduino;
  int pin;

  int min, max;
  int i, feedback;

  float val;

  public TextAreaGUI(Arduino arduino, int pin, ControlP5 cp5, String name, 
  int xBox, int yBox, int width, int height, int min, int max, float initial) {
    super(cp5, name + "Display");

    if (arduino != null) {
      this.arduino = arduino;
      this.pin = pin;
      arduino.pinMode(pin, Arduino.INPUT);
    }

    this.min = min;
    this.max = max;

    this.setPosition(xBox, yBox);
    this.setWidth(width);
    this.setHeight(height);
    this.setText(String.format("%3.2f", initial));
    this.setLabel(name);
    this.setBorderColor(border);
    this.setColorForeground(fg);
    this.setColorBackground(bg);
  }

  public void updateValue() {
    // Perform analog read of pin and display servo position
    if (arduino != null) {
      feedback=0;
      for(i=0; i<10; i++) {
        feedback += arduino.analogRead(pin);
      }
      feedback/=10;
      
      val = map(feedback, min, max, 0, 170); 
      
      if(millis() - time > Constants.DISP_UPDATE) {
        this.setText(String.format("%3.2f", val));
        time = millis();
      }
    }
  }
}

