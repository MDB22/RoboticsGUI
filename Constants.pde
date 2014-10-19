public static class Constants {

  // Generic constants
  public static final int NUM_SERVOS = 7;
  public static final int NUM_TICKS = 10;

  public static final String CONTROLLER_NAMES[] = {
    "Base", "Shoulder", "Elbow", "WristRoll", "WristPitch", "WristYaw", "Gripper"
  };

  public static final int PWM_PINS[] = {
    2, 3, 4, 8, 6, 7, 9
  };

  public static final int ANALOG_PINS[] = {
    5, 4, 3, 2, 1, 0, -1
  };

  public static final int MIN_FEEDBACK[] = {
    165, 176, 168, 189, 184, 185, 390
  };

  public static final int MAX_FEEDBACK[] = {
    684, 688, 684, 727, 726, 694, 600
  };

  public static final int MIN_ANGLE[] = {
    -110, -70, -140, -105, -95, -105, 50      //These are now just safety checks. Not used.
   //-360, -360, -360, -360, -360, -360, 0
  };

  public static final int MAX_ANGLE[] = {           
    150, 120, 25, 90, 90, 40, 110
    //360, 360, 360, 360, 360, 360, 180
  };
  

  public static final int SERVO_OFFSET[] = {    //when the sevrowrite gives these angles, corresponds to home position
    157, 95, 150, 50, 69, 43, 0
    //157, 135, 150, 50, 69, 43, 0
  };  

  public static final float SERVO_SCALE[] = {      //-1 means increasing servoValue decreases joint Angle.
    -1.02, -1.08, 1.06, -1.22, -1.22, -1.28, 1, -0.71
  };

  public static final int SERVOVAL_MIN = 0;        //Check these with Trent
  public static final int SERVOVAL_MAX = 180;

  public static final float INITIAL_JOINT_ANGLES[] = {
    25,27,-50,-6,-1,-31
  };

  public static final int NUM_TO_AVERAGE = 40;

  public static final int TEXTBOX_SEPARATION = 40;

  // Position constants for the ServoController objects
  // Textbox constants
  public static final int XBOX = 380;
  public static final int YBOX = 100;

  public static final int TEXTBOX_WIDTH = 50;
  public static final int TEXTBOX_HEIGHT = 20;

  // Knob constants
  public static final int XKNOB[] = {
    480, 640, 760
  };
  public static final int YKNOB[] = {
    100, 225, 350
  };
  public static final int KNOB_RADII[] = {
    50, 50, 50, 35, 35, 35, 35
  };

  // Constants for the Button objects
  public static final int NUM_BUTTONS = 7;

  public static final String BUTTON_NAMES[] = {
    "Start", "Stop", "Zero", "Home", "SetHome", "Record", "Exit"
  };

  public static final int BUTTON_X = 80;
  public static final int BUTTON_Y = 100;

  public static final int BUTTON_WIDTH = 100;
  public static final int BUTTON_HEIGHT = 19;

  public static final int BUTTON_SEPARATION = 20;

  // Constants for Textarea objects
  public static final int DISPLAY_X = 300;
  public static final int DISPLAY_Y = YBOX;

  public static final int DISP_UPDATE = 500;

  // Constants for the matrix display
  public static final String MATRIX_ELEMENT_NAMES[][] = {
    {
      "Rxx", "Rxy", "Rxz", "Px"
    }
    , 
    {
      "Ryx", "Ryy", "Ryz", "Py"
    }
    , 
    {
      "Rzx", "Rzy", "Rzz", "Pz"
    }
    , 
    {
      "pad1", "pad2", "pad3", "pad4"
    }
  };
  //matrix positioning constants
  public static final int MATRIX_X = 40;
  public static final int MATRIX_Y = 300;
  public static final int MATRIX_X_SEPARATION = 40;
  public static final int MATRIX_Y_SEPARATION = 20;
  public static final int MATRIX_ELEMENT_WIDTH = 40;
  public static final int MATRIX_ELEMENT_HEIGHT = 20;
  public static final int MATRIX_X_GAP = 10;
  public static final int MATRIX_Y_GAP = 10;
  public static final int MATRIX_X_LABEL = MATRIX_X+4*MATRIX_X_SEPARATION+MATRIX_X_GAP+2;
  public static final int MATRIX_Y_LABEL = MATRIX_Y+MATRIX_ELEMENT_HEIGHT/2;

  // Constants for the Toggle Buttons
  public static final String LOGBUTTON_NAME = "LogData";
  public static final String ATTACHBUTTON_NAME = "ToggleServos";

  public static final int TOGGLE_XPOS = 200;
  
  public static final int LOG_YPOS = 100;
  public static final int ATTACH_YPOS = 140;

  public static final int TOGGLE_XSIZE = 20;
  public static final int TOGGLE_YSIZE = 20;

  // User position control constants
  public static final int NUM_POSE_INPUTS = 7;

  public static final int POSE_INPUT_X = 400;
  public static final int POSE_INPUT_Y = 500;
  public static final int POSE_INPUT_Y_SEP = 20;
  public static final int POSE_INPUT_WIDTH = 40;
  public static final int POSE_INPUT_HEIGHT = 20;

  public static final String POSE_INPUT_NAMES[] = {
    "X", "Y", "Z", "Roll", "Pitch", "Yaw", "Time"
  };

  public static final String DEFAULT_USER_INPUT[] = {
    "-10", "25", "400", "0", "0", "0", "10"
  };
  
  public static final int TRAJECTORY_MSG_X = 500;
  public static final int TRAJECTORY_MSG_Y = 550;
  
  
  // Gripper constants
  public static final int GRIPPER_A_PIN A5
  public static final int CLOSE_ANGLE 110
  public static final int OPEN_ANGLE 50
  public static final int ITERATIONS 10  // number of itterations to average feedback
  public static final int GRIP_STRENGTH 15 // smaller value is tighter grip
  public static final int GRIPPER_PIN 9
}

