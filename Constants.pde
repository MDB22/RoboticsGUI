public static class Constants {

  // Generic constants
  public static final int NUM_SERVOS = 6;
  public static final int NUM_TICKS = 10;

  public static final String CONTROLLER_NAMES[] = {
    "Base", "Shoulder", "Elbow", "WristRoll", "WristPitch", "WristYaw"
  };

  public static final int PWM_PINS[] = {
    2, 3, 4, 5, 6, 7
  };

  public static final int ANALOG_PINS[] = {
    0, 0, 0, 0, 0, 0
  };

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
  public static final int NUM_BUTTONS = 6;

  public static final String BUTTON_NAMES[] = {
    "Start", "Stop", "Zero", "Home", "Record", "Exit"
  };

  public static final int BUTTON_X = 80;
  public static final int BUTTON_Y = 100;

  public static final int BUTTON_WIDTH = 100;
  public static final int BUTTON_HEIGHT = 19;

  public static final int BUTTON_SEPARATION = 20;

  // Constants for Textarea objects
  public static final int DISPLAY_X = 300;
  public static final int DISPLAY_Y = YBOX;
}

