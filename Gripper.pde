public class Gripper {
    
  static private int feedback = 0;
  static private int i;
  static private int holding = 0;        // trigger counter for gripper not moving       
  static private int feedback_angle = 0;
  static private int moveGripper = 1;
  
  public static void openGripper() {
    arduino.servoWrite(Constants.GRIPPER_PIN, Constants.OPEN_ANGLE);
    delay(100);
  }
  
  public static void closeGripper() {
    while(moveGripper) {
      arduino.servoWrite(Constants.GRIPPER_PIN, Constants.CLOSE_ANGLE);;
      for(i = 0; i < Constants.ITERATIONS; i++) {
        feedback += analogRead(Constants.GRIPPER_A_PIN);
        delay(10);
      }
      feedback/=iterations;
      feedback_angle = map(feedback, Constants.MIN_FEEDBACK[6], Constants.MAXFEEDBACK[6], Constants.OPEN_ANGLE, Constants.CLOSE_ANGLE); 
      if(abs(Constants.CLOSE_ANGLE - feedback_angle) > 5) {
        holding++;
      } else {
        holding = 0;
      }
      if(holding > 5){
        arduino.servoWrite(Constants.GRIPPER_PIN, feedback_angle-Constants.GRIP_STRENGTH);
        moveGripper = 0;
      }
    }
  }
  
}
