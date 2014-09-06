import controlP5.*;

color border = color(0, 0, 0);
color fg = color(1, 108, 158);
color bg = color(2, 52, 77);

public class TextAreaGUI extends Textarea {

  Arduino arduino;
  int feedback_pin;

  int minFeedback, maxFeedback;
  int i, feedback;
  int time;
  int servoID;

  float jointAngle;

  public TextAreaGUI(Arduino arduino, ControlP5 cp5, int servoID) {
    super(cp5, Constants.CONTROLLER_NAMES[servoID] + "Display");
    

    if (arduino != null) {
      this.arduino = arduino;
      this.feedback_pin = Constants.ANALOG_PINS[servoID];
      arduino.pinMode(feedback_pin, Arduino.INPUT);
    }
    this.servoID = servoID;
    this.minFeedback = Constants.MIN_FEEDBACK[i];
    this.maxFeedback = Constants.MAX_FEEDBACK[i];

    this.setPosition(Constants.DISPLAY_X, Constants.DISPLAY_Y+servoID*Constants.TEXTBOX_SEPARATION);
    this.setWidth(Constants.TEXTBOX_WIDTH);
    this.setHeight(Constants.TEXTBOX_HEIGHT);
    this.setText(String.format("%3.2f", home[i]));
    this.setLabel(Constants.CONTROLLER_NAMES[servoID] + "Display");
    this.setBorderColor(border);
    this.setColorForeground(fg);
    this.setColorBackground(bg);
    this.time = 0;
  }

  public void updateValue() {
    // Perform analog read of pin and display servo position
    if (arduino != null) {
      feedback=0;
      for(i=0; i<10; i++) {
        feedback += arduino.analogRead(feedback_pin);
      }
      feedback/=10;

      
      int predictedServoValue = (int) map(feedback, minFeedback, maxFeedback, 0, 170); 
      jointAngle = (predictedServoValue-Constants.SERVO_OFFSET[servoID])*Constants.SERVO_DIR[servoID];
    
      /*
      This part is probably going to fail when the Arduino is plugged in,
      where is the "time" variable initialised?
      */
      if(millis() - time > Constants.DISP_UPDATE) {
        //println("Time is: " + time);
        this.setText(String.format("%3.2f", jointAngle));
        time = millis();
        //println("feedback value is "+feedback +" for feedback pin "+feedback_pin);
        //println("servoValue angle is "+predictedServoValue);
        //println("jointAngle is "+jointAngle);

      }
    }
  }
}

