/* This class should allow for the input of the gripper's position and orientation
 * then send that to the trajectory generator. 
*/

public class GripperPoseGUI {
  
  ArrayList<Textfield> poseTextArray = new ArrayList<Textfield>();
  
  color fg = color(1, 108, 158);
  color bg = color(2, 52, 77);
  
  public GripperPoseGUI(){
    for (int row = 0; row<2; row++){
      int ypos = Constants.POSE_INPUT_Y + Constants.POSE_INPUT_Y_SEP*row;
      
      for (int col = 0; col<1; col++){
        Textfield tf = new Textfield(cp5, Constants.POSE_INPUT_NAMES[row][col]);
        int xpos = Constants.POSE_INPUT_X + Constants.POSE_INPUT_X_SEP*col;
        tf.setPosition(xpos,ypos);
        tf.setSize(Constants.POSE_INPUT_WIDTH, Constants.POSE_INPUT_HEIGHT);
        tf.setColorForeground(fg);
        tf.setColorBackground(bg);
        String initString = String.format("%3.2f", 0);
        tf.setText(initString);
        tf.setLabel("");
        poseTextArray.add(tf);
      }
    }
