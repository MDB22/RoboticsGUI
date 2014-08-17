/* 
 This class updated when joint values are updated and updates the table in the GUI.
*/
public class MatrixGUI{

  public ArrayList<Textfield> textArray = new ArrayList<Textfield>();
  public float[] jointAngles = Constants.INITIAL_JOINT_ANGLES;
  public float[][] tMatrix;
  public MatrixCalculator mcalc = new MatrixCalculator();
  color fg = color(1, 108, 158);
  color bg = color(2, 52, 77);

  //initialises the 16 text fields that represent the transformation matrix elements      
  public MatrixGUI(int x, int y, int x_separation, int y_separation, int matrix_element_width, int matrix_element_height){
    tMatrix = mcalc.calcTMatrix(jointAngles);
    for (int row=0;row<4;row++){
      for (int col=0;col<4;col++){
        Textfield tf = new Textfield(cp5, Constants.MATRIX_ELEMENT_NAMES[row][col]);  //textarea displays strangely on GUI so used textfield
        int xpos = x+x_separation*col;
        if (col==3){ xpos+=Constants.MATRIX_X_GAP;}    //create a visual separation 
        int ypos = y+y_separation*row;                 //between rotation and translation components
        if (row==3){ ypos+=Constants.MATRIX_Y_GAP;}
        tf.setPosition(xpos,ypos);
        tf.setSize(matrix_element_width, matrix_element_height);

        tf.setColorForeground(fg);
        tf.setColorBackground(bg);
        String string = String.format("%3.2f", tMatrix[row][col]);
        tf.setText(string);
        tf.setLabel("");
        textArray.add(tf);
      }
    }
  }
  
  //The feedback from TextAreaGUI will update the joint value,
  // and the transformation matrix will be recalculated.
  public void updateJointValue(int servoID, float val){              /* NEED TO CHANGE SO TEXTAREA UPDATES IT*/
    jointAngles[servoID] = val;
    tMatrix = mcalc.calcTMatrix(jointAngles);

    for (int row=0;row<4;row++){
      for (int col=0;col<4;col++){
        textArray.get(4*row+col).setText(String.format("%3.2f", tMatrix[row][col]));
      }
    }
  }
}
