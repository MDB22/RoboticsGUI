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
  float[] feedbackArray = new float[Constants.NUM_TO_AVERAGE];

  float feedback;
  float sum = 0;
  float jointAngle;
  int count = 0;
  
  String label;

  public TextAreaGUI(Arduino arduino, ControlP5 cp5, int ID) {
    super(cp5, Constants.CONTROLLER_NAMES[ID] + "Display");

    if (arduino != null) {
      this.arduino = arduino;
      this.feedback_pin = Constants.ANALOG_PINS[ID];
      arduino.pinMode(feedback_pin, Arduino.INPUT);
    }

    this.ID = ID;
    if (ID!=6){
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
      
        if (count == Constants.NUM_TO_AVERAGE){
          count=0;
        }

        feedbackArray[count] = arduino.analogRead(feedback_pin);
//        println("feedback" +feedbackArray[count] + " count "+ count);
        for(int i = 0; i<Constants.NUM_TO_AVERAGE; i++) {
          sum+= feedbackArray[i];
        }
        count ++;
        sum/=Constants.NUM_TO_AVERAGE;

      
          

      float predictedServoValue = map(sum, minFeedback, maxFeedback, 0, 170) - 8; 
      float scalingFactor = Constants.SERVO_SCALE[ID];
      int offset = Constants.SERVO_OFFSET[ID];
      if (ID == 1){
        //
        if (predictedServoValue>offset+5){
          predictedServoValue = predictedServoValue-5;
          scalingFactor = Constants.SERVO_SCALE[7];
        }
      }
      jointAngle = (predictedServoValue-offset)/scalingFactor;
      
//      if(ID == 0) {
//        println(sum + "\t" + jointAngle + "\t\t" + predictedServoValue);
//      }
      if (millis() - time > Constants.DISP_UPDATE) {
        //println("Time is: " + time);
        //this.setText(String.format("%3.2f", jointAngle));
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
    float g = 0;
    float sum = 0;
    // Perform mean filtering on the analog input to smooth data
    for (int i=0; i<n; i++) {
      f = arduino.analogRead(feedback_pin);
      print(f + ", ");
      sum+=f;
    }
    g = arduino.analogRead(feedback_pin);
    println();
    println(g + ", ");
    
    return f/n;
  }
  
  private float readPinMedian(int n) {
    float[] f = new float[n];
    println("before:");
    for (int i=0; i<n; i++) {
      f[i] = arduino.analogRead(feedback_pin);
      print(f[i] + ", ");
    }

    int j;
    boolean flag = true;   // set flag to true to begin first pass
    float temp;   //holding variable

     while (flag)     {
            flag= false;    //set flag to false awaiting a possible swap
            for(j=0; j<n-1; j++){
                   if (f[j] < f[j+1]) {   // change to > for ascending sort
                           temp = f[j];                //swap elements
                           f[j] = f[j+1];
                           f[j+1] = temp;
                           flag = true;              //shows a swap occurred  
                  } 
            } 
      } 
      for(int i = 0; i < n; i++) {
          print(f[i] + ", "); 
      }
      println();
      return f[n/2];
  }
    
    
    
}

