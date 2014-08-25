import controlP5.*;

color border = color(0, 0, 0);
color fg = color(1, 108, 158);
color bg = color(2, 52, 77);

public class TextAreaGUI extends Textarea {

  Arduino arduino;
  int pin;

  int minFeedback, maxFeedback;
  int i, feedback;

  float jointAngle;

  public TextAreaGUI(Arduino arduino, int pin, ControlP5 cp5, String name, 
  int xBox, int yBox, int width, int height, int minFeedback, int maxFeedback, float initialAngle) {
    super(cp5, name + "Display");

    if (arduino != null) {
      this.arduino = arduino;
      this.pin = pin;
      arduino.pinMode(pin, Arduino.INPUT);
    }

    this.minFeedback = minFeedback;
    this.maxFeedback = maxFeedback;

    this.setPosition(xBox, yBox);
    this.setWidth(width);
    this.setHeight(height);
    this.setText(String.format("%3.2f", initialAngle));
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
      
      jointAngle = map(feedback, minFeedback, maxFeedback, -85, 85); 
      
      if(millis() - time > Constants.DISP_UPDATE) {
        this.setText(String.format("%3.2f", jointAngle));
        time = millis();
      }
    }
  }
}

