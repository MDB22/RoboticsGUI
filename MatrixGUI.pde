import matrixMath.*;

public class MatrixGUI{

  public ArrayList<Textarea> textArray = new ArrayList<Textarea>();
  public float[] jointValues = {1,1,1,1,1,1};
  public MatrixCalculator mcalc = new MatrixCalculator();
  
        color fg = color(1, 108, 158);
        color bg = color(2, 52, 77);
        
  public MatrixGUI(int x, int y, int x_separation, int y_separation, int matrix_element_width, int matrix_element_height){
    for (int i=0;i<4;i++){    //i is the row
      for (int j=0;j<4;j++){   //j is the column
        Textarea t1 = new Textarea(cp5, Constants.MATRIX_ELEMENT_NAMES[i][j]);
        t1.clear();
        int xpos = x+x_separation*j;
        if (j==3){ xpos+=Constants.MATRIX_X_GAP;}
        int ypos = y+y_separation*i;
        if (i==3){ ypos+=Constants.MATRIX_Y_GAP;}
        t1.setPosition(xpos,ypos);
        t1.setSize(matrix_element_width, matrix_element_height);

        t1.setColorForeground(fg);
        t1.setColorBackground(bg);
        t1.setText(String.format("%3.2f", 25.4));
        t1.setLabel(Constants.MATRIX_ELEMENT_NAMES[i][j]);
        //t1.setLineHeight(1);
        textArray.add(t1);
      }
    }
  }
  
  public void setJointValue(int servoID, float val){
    jointValues[servoID] = val;
    float[][] tMatrix = mcalc.calcTMatrix(jointValues[0],jointValues[1],jointValues[2],jointValues[3],jointValues[4],jointValues[5]);

    //float[][] tMatrix = mcalc.calcTMatrix(0,0,0,0,0,val);
    for (int row=0;row<4;row++){
      for (int col=0;col<4;col++){
        
        //textArray.get(4*i+j).setText(String.format("%3.2f", jointValues[i]));
        textArray.get(4*row+col).setText(String.format("%3.2f", tMatrix[row][col]));
      }
    }
  }
}
