public static class Constants {

  // Generic constants
  public static final int NUM_SERVOS = 6;
  public static final int NUM_TICKS = 10;

  public static final String CONTROLLER_NAMES[] = {
    "Base", "Shoulder", "Elbow", "WristRoll", "WristPitch", "WristYaw"
  };

  public static final int PWM_PINS[] = {
    2, 3, 4, 8, 6, 7
  };

  public static final int ANALOG_PINS[] = {
    5, 4, 3, 2, 1, 0
  };

  public static final int MIN_FEEDBACK[] = {
    165, 176, 168, 189, 184, 185
  };

  public static final int MAX_FEEDBACK[] = {
    684, 688, 684, 727, 726, 694
  };

  public static final int MIN_ANGLE[] = {
    -120, -120, -180, -120, -120, -100, -120    //-88, -146, -147, -90, -60, -90      //These are now just safety checks. Not used.
  };

  public static final int MAX_ANGLE[] = {
    140, 140, 30, 140, 140, 140      //82, 24, 23, 80, 110, 80
  };

  public static final int SERVO_OFFSET[] = {    //when the sevrowrite gives these angles, corresponds to home position
    60, 134, 154, 50, 70, 40
  };

  public static final float SERVO_DIR[] = {      //-1 means increasing servoValue decreases joint Angle.
    -1, -1, 1, 1, -1, 1
  };

  public static final int SERVOVAL_MIN = 0;        //Check these with Trent
  public static final int SERVOVAL_MAX = 180;

  public static final float INITIAL_JOINT_ANGLES[] = {
    0, 0, 0, 0, 0, 0
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
    480, 640
  };
  public static final int YKNOB[] = {
    100, 225, 350
  };
  public static final int KNOB_RADII[] = {
    50, 50, 50, 35, 35, 35
  };

  // Constants for the Button objects
  public static final int NUM_BUTTONS = 9;

  public static final String BUTTON_NAMES[] = {
    "Start", "Stop", "Zero", "Home", "SetHome", "Record", "Exit", "Detach", "Attach"
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

  // Constants for the Log Button
  public static final String LOGBUTTON_NAME = "LogData";

  public static final int LOG_XPOS = 200;
  public static final int LOG_YPOS = 100;

  public static final int LOG_XSIZE = 20;
  public static final int LOG_YSIZE = 20;

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
}

