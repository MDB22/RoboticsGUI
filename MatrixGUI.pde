/* 
 This class updated when joint values are updated and updates the table in the GUI.
 */
import controlP5.*;

public class MatrixGUI {

  ArrayList<Textfield> textArray = new ArrayList<Textfield>();
  ArrayList<Textfield> textArray2 = new ArrayList<Textfield>();
  ArrayList<Textfield> jVTextArray = new ArrayList<Textfield>();

  float[] jointAngles = Constants.INITIAL_JOINT_ANGLES;
  Matrix tMatrix;
  Matrix jOmega;
  Matrix jV;
  MatrixCalculator mcalc = new MatrixCalculator();
  color fg = color(1, 108, 158);
  color bg = color(2, 52, 77);

  //initialises the 16 text fields that represent the transformation matrix elements      
  public MatrixGUI(ControlP5 cp5, int x, int y, int x_separation, int y_separation, int matrix_element_width, int matrix_element_height) {
    mcalc.updateTMatrices(jointAngles);
    tMatrix = mcalc.calcTMatrix();
    jOmega = mcalc.calcJOmega();
    jV = mcalc.calcJV();
    for (int row=0; row<4; row++) {
      for (int col=0; col<4; col++) {
        Textfield tf = new Textfield(cp5, Constants.MATRIX_ELEMENT_NAMES[row][col]);  //textarea displays strangely on GUI so used textfield
        int xpos = x+x_separation*col;
        if (col==3) { 
          xpos+=Constants.MATRIX_X_GAP;
        }    //create a visual separation 
        int ypos = y+y_separation*row;                 //between rotation and translation components
        if (row==3) { 
          ypos+=Constants.MATRIX_Y_GAP;
        }
        tf.setPosition(xpos, ypos);
        tf.setSize(matrix_element_width, matrix_element_height);

        tf.setColorForeground(fg);
        tf.setColorBackground(bg);
        String string = String.format("%3.2f", tMatrix.getElement(row, col));
        tf.setText(string);
        tf.setLabel("");
        textArray.add(tf);
      }
    }

    for (int row=0; row<3; row++) {
      for (int col=0; col<6; col++) {
        Textfield tf = new Textfield(cp5, String.format("%d", 6*row+col)+"jo");  //textarea displays strangely on GUI so used textfield
        int xpos = x+x_separation*col;
        int ypos = y+140+y_separation*row;                 //between rotation and translation components
        tf.setPosition(xpos, ypos);
        tf.setSize(matrix_element_width, matrix_element_height);

        tf.setColorForeground(fg);
        tf.setColorBackground(bg);
        String string = String.format("%3.2f", jOmega.getElement(row, col));
        tf.setText(string);
        tf.setLabel("");
        textArray2.add(tf);
      }
    }

    for (int row=0; row<3; row++) {
      for (int col=0; col<6; col++) {
        Textfield tf = new Textfield(cp5, String.format("%d", 6*row+col)+"jv");  //textarea displays strangely on GUI so used textfield
        int xpos = x+x_separation*col;
        int ypos = y+220+y_separation*row;                 //between rotation and translation components
        tf.setPosition(xpos, ypos);
        tf.setSize(matrix_element_width, matrix_element_height);

        tf.setColorForeground(fg);
        tf.setColorBackground(bg);
        String string = String.format("%3.2f", jV.getElement(row, col));
        tf.setText(string);
        tf.setLabel("");
        jVTextArray.add(tf);
      }
    }
  }

  //The feedback from TextAreaGUI will update the joint value,
  // and the transformation matrix will be recalculated.
  public void updateJointValue(int servoID, float val) {              /* NEED TO CHANGE SO TEXTAREA UPDATES IT*/
    jointAngles[servoID] = val;
    mcalc.updateTMatrices(jointAngles);
    tMatrix = mcalc.calcTMatrix();
    jOmega = mcalc.calcJOmega();
    jV = mcalc.calcJV();

    for (int row=0; row<4; row++) {
      for (int col=0; col<4; col++) {
        textArray.get(4*row+col).setText(String.format("%3.2f", tMatrix.getElement(row, col)));
      }
    }
    for (int row=0; row<3; row++) {
      for (int col=0; col<6; col++) {
        textArray2.get(6*row+col).setText(String.format("%3.2f", jOmega.getElement(row, col)));
      }
    }
    for (int row=0; row<3; row++) {
      for (int col=0; col<6; col++) {
        jVTextArray.get(6*row+col).setText(String.format("%3.2f", jV.getElement(row, col)));
      }
    }
  }
}

