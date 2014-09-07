import controlP5.*;

color border = color(0, 0, 0);
color fg = color(1, 108, 158);
color bg = color(2, 52, 77);

public class TextAreaGUI extends Textarea {

  Arduino arduino;
  int feedback_pin;

  int minFeedback, maxFeedback;
  int time = 0;
  int ID;

  float feedback;
  float jointAngle;
  
  String label;

  public TextAreaGUI(Arduino arduino, ControlP5 cp5, int ID) {
    super(cp5, Constants.CONTROLLER_NAMES[ID] + "Display");

    if (arduino != null) {
      this.arduino = arduino;
      this.feedback_pin = Constants.ANALOG_PINS[ID];
      arduino.pinMode(feedback_pin, Arduino.INPUT);
    }

    this.ID = ID;
    this.minFeedback = Constants.MIN_FEEDBACK[ID];
    this.maxFeedback = Constants.MAX_FEEDBACK[ID];
    this.label = Constants.CONTROLLER_NAMES[ID];

    this.setPosition(Constants.DISPLAY_X, Constants.DISPLAY_Y+ID*Constants.TEXTBOX_SEPARATION);
    this.setWidth(Constants.TEXTBOX_WIDTH);
    this.setHeight(Constants.TEXTBOX_HEIGHT);
    this.setText(String.format("%3.2f", home[ID]));
    this.setBorderColor(border);
    this.setColorForeground(fg);
    this.setColorBackground(bg);
  }

  public int getID() {
    return ID;
  }
  
  public String getLabel() {
    return label;
  }

  public void updateValue() {
    // Perform analog read of pin and display servo position
    if (arduino != null) {
      feedback = readPin(10);

      int predictedServoValue = (int) map(feedback, minFeedback, maxFeedback, 0, 170); 
      jointAngle = (predictedServoValue-Constants.SERVO_OFFSET[ID])*Constants.SERVO_DIR[ID];
      if (millis() - time > Constants.DISP_UPDATE) {
        //println("Time is: " + time);
        this.setText(String.format("%3.2f", jointAngle));
        time = millis();
        //println("feedback value is "+feedback +" for feedback pin "+feedback_pin);
        //println("servoValue angle is "+predictedServoValue);
        //println("jointAngle is "+jointAngle);
      }
    }
  }

  private float readPin(int n) {
    float f = 0;
    // Perform mean filtering on the analog input to smooth data
    for (int i=0; i<n; i++) {
      f += arduino.analogRead(feedback_pin);
    }
    return f/n;
  }
}

