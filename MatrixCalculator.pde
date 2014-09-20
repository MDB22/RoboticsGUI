/* 
 This class performs the mathematics of calculating the transformation matrix.
*/
public class MatrixCalculator {
  
  Matrix dhParams;      //stores the Denavit Hartenberg parameters
  
  Matrix T1;  //stores the current values for the T Matrices.
  Matrix T2;  //get transformation from one frame to the next.
  Matrix T3;  //Ti denotes transformation from frame i-1 to frame i
  Matrix T4;
  Matrix T5;
  Matrix T6;
  
  Matrix JOmega;
  
  //Calculates the transformation matrix from the end effector frame to the inertial frame,
  //given the joint angles of the robot.
  public Matrix calcTMatrix()
  {
    //updateTMatrices(jointAngles);
    
    //T = T1*T2*T3*T4*T5*T6;
    Matrix T1_6 = Matrix.multiplyMatrix(T1, T2);
    T1_6 = Matrix.multiplyMatrix(T1_6, T3);
    T1_6 = Matrix.multiplyMatrix(T1_6, T4);
    T1_6 = Matrix.multiplyMatrix(T1_6, T5);
    T1_6 = Matrix.multiplyMatrix(T1_6, T6);
    
    return T1_6;
  }
  
  //Computes transformation matrix from one frame to the next given D-H parameters
  private Matrix T_matrix_one(float[] dhParametersRow){
    float alpha_rad = radians(dhParametersRow[0]);
    float a = dhParametersRow[1];
    float d = dhParametersRow[2];
    float theta_rad = radians(dhParametersRow[3]);
    
    float[][] Rx_alpha = { {1, 0, 0, 0}, 
                           {0, cos(alpha_rad), -sin(alpha_rad),0},
                           {0, sin(alpha_rad), cos(alpha_rad),0},
                           {0, 0, 0, 1} };
    
    float[][] Dx_a = { {1, 0, 0, a},
                       {0, 1, 0, 0},
                       {0, 0, 1, 0},
                       { 0, 0, 0, 1} };
    
    float[][] Rz_theta = { {cos(theta_rad), -sin(theta_rad), 0, 0},
                           {sin(theta_rad), cos(theta_rad), 0, 0},
                           {0, 0, 1, 0},
                           {0, 0, 0, 1} };
    
    float[][] Dz_d = { {1, 0, 0, 0}, 
                       {0, 1, 0, 0},
                       {0, 0, 1, d},
                       {0, 0, 0, 1} };
                       
    Matrix Rx = new Matrix(Rx_alpha);
    Matrix Dx = new Matrix(Dx_a);
    Matrix Rz = new Matrix(Rz_theta);
    Matrix Dz = new Matrix(Dz_d);

    //T = Rx_alpha * Dx_a * Rz_theta * Dz_d;
    Matrix T = Matrix.multiplyMatrix(Rx,Dx);
    T = Matrix.multiplyMatrix(T,Rz);
    T = Matrix.multiplyMatrix(T,Dz);

    return T;
  }
  
  //ensures q[i] is the angle of joint i.
  public float[] correctIndex(float[] jointAngles){
      float[] q = {0, jointAngles[0], jointAngles[1], jointAngles[2], jointAngles[3], jointAngles[4], jointAngles[5]};
      return q;
  }
      
  //matrix multiplication for a 4x4 matrix
  /*public float[][] multiply4x4Matrix(float[][] a, float[][] b){
    float c[][] = new float[4][4];
    
    for (int row=0;row<4;row++){
      for (int col=0;col<4;col++){
        for (int k=0;k<4;k++){
          c[row][col]+=a[row][k]*b[k][col];
        }
      }
    }
    return c;
  }*/
  public Matrix calcJOmega(){
    
    Matrix T1_2 = Matrix.multiplyMatrix(T1, T2);
    Matrix T1_3 = Matrix.multiplyMatrix(T1_2, T3);
    Matrix T1_4 = Matrix.multiplyMatrix(T1_3, T4);
    Matrix T1_5 = Matrix.multiplyMatrix(T1_4, T5);
    Matrix T1_6 = Matrix.multiplyMatrix(T1_5, T6);
    
    /*
    float[] z1 = {T1.getElement(0,2),T1.getElement(1,2),T1.getElement(2,2)};
    float[] z2 = {T1_2.getElement(0,2),T1_2.getElement(1,2),T1_2.getElement(2,2)};
    float[] z3 = {T1_3.getElement(0,2),T1_3.getElement(1,2),T1_3.getElement(2,2)};
    float[] z4 = {T1_4.getElement(0,2),T1_4.getElement(1,2),T1_4.getElement(2,2)};
    float[] z5 = {T1_5.getElement(0,2),T1_5.getElement(1,2),T1_5.getElement(2,2)};
    float[] z6 = {T1_6.getElement(0,2),T1_6.getElement(1,2),T1_6.getElement(2,2)};*/
    
    float[][] JOmega = {{T1.getElement(0,2),T1_2.getElement(0,2),T1_3.getElement(0,2),T1_4.getElement(0,2),T1_5.getElement(0,2),T1_6.getElement(0,2)},
                        {T1.getElement(1,2),T1_2.getElement(1,2),T1_3.getElement(1,2),T1_4.getElement(1,2),T1_5.getElement(1,2),T1_6.getElement(1,2)},
                        {T1.getElement(2,2),T1_2.getElement(2,2),T1_3.getElement(2,2),T1_4.getElement(2,2),T1_5.getElement(2,2),T1_6.getElement(2,2)}};
                        
    Matrix JOmegaMatrix = new Matrix(JOmega);
                        
    return JOmegaMatrix;
  }
  
  public Matrix calcJV(){
    //get combined transformation matrices
    Matrix T1_2 = Matrix.multiplyMatrix(T1, T2);      //these transform from the inertial frame to the joint frame, for calculating z_i.
    Matrix T1_3 = Matrix.multiplyMatrix(T1_2, T3);
    Matrix T1_4 = Matrix.multiplyMatrix(T1_3, T4);
    Matrix T1_5 = Matrix.multiplyMatrix(T1_4, T5);
    Matrix T1_6 = Matrix.multiplyMatrix(T1_5, T6);   
    
    Matrix T5_6 = Matrix.multiplyMatrix(T5, T6);    //these transform from the joint frame to the end effector frame, for calculating p_i.
    Matrix T4_6 = Matrix.multiplyMatrix(T4, T5_6);
    Matrix T3_6 = Matrix.multiplyMatrix(T3, T4_6);
    Matrix T2_6 = Matrix.multiplyMatrix(T2, T3_6);
    
    //obtain unit z vectors (axes of joint rotation) in the inertial frame.
    float[][] z1_hat = {{T1.getElement(0,2)},{T1.getElement(1,2)},{T1.getElement(2,2)}};
    float[][] z2_hat = {{T1_2.getElement(0,2)},{T1_2.getElement(1,2)},{T1_2.getElement(2,2)}};
    float[][] z3_hat = {{T1_3.getElement(0,2)},{T1_3.getElement(1,2)},{T1_3.getElement(2,2)}};
    float[][] z4_hat = {{T1_4.getElement(0,2)},{T1_4.getElement(1,2)},{T1_4.getElement(2,2)}};
    float[][] z5_hat = {{T1_5.getElement(0,2)},{T1_5.getElement(1,2)},{T1_5.getElement(2,2)}};
    float[][] z6_hat = {{T1_6.getElement(0,2)},{T1_6.getElement(1,2)},{T1_6.getElement(2,2)}};
    
    Matrix z1 = new Matrix(z1_hat);
    Matrix z2 = new Matrix(z2_hat);
    Matrix z3 = new Matrix(z3_hat);
    Matrix z4 = new Matrix(z4_hat);
    Matrix z5 = new Matrix(z5_hat);
    Matrix z6 = new Matrix(z6_hat);
    
    // Get vector from joint i to end effector in frame i, pad with a 0 to get only the rotation
    float[][] p1e = {{T2_6.getElement(0,3)}, {T2_6.getElement(1,3)}, {T2_6.getElement(2,3)},{0}};
    float[][] p2e = {{T3_6.getElement(0,3)}, {T3_6.getElement(1,3)}, {T3_6.getElement(2,3)},{0}};
    float[][] p3e = {{T4_6.getElement(0,3)}, {T4_6.getElement(1,3)}, {T4_6.getElement(2,3)},{0}};
    float[][] p4e = {{T5_6.getElement(0,3)}, {T5_6.getElement(1,3)}, {T5_6.getElement(2,3)},{0}};
    float[][] p5e = {{T6.getElement(0,3)}, {T6.getElement(1,3)}, {T6.getElement(2,3)},{0}};
    float[][] p6e = {{0},{0},{0},{0}};

    Matrix p1_e = new Matrix(p1e);
    Matrix p2_e = new Matrix(p2e);
    Matrix p3_e = new Matrix(p3e);
    Matrix p4_e = new Matrix(p4e);
    Matrix p5_e = new Matrix(p5e);
    Matrix p6_e = new Matrix(p6e);
    
    //want to get these in the inertial frame. Multiply with the appropriate T matrix.
    p1_e = Matrix.multiplyMatrix(T1,p1_e);
    p2_e = Matrix.multiplyMatrix(T1_2,p2_e);
    p3_e = Matrix.multiplyMatrix(T1_3,p3_e);
    p4_e = Matrix.multiplyMatrix(T1_4,p4_e);
    p5_e = Matrix.multiplyMatrix(T1_5,p5_e);
    p6_e = Matrix.multiplyMatrix(T1_6,p6_e);

    Matrix jv1 = Matrix.calcCrossProduct(z1,p1_e);    //the fact that p0_e has the padding doesn't matter- the cross product calculator ignores the last element.
    Matrix jv2 = Matrix.calcCrossProduct(z2,p2_e);
    Matrix jv3 = Matrix.calcCrossProduct(z3,p3_e);
    Matrix jv4 = Matrix.calcCrossProduct(z4,p4_e);
    Matrix jv5 = Matrix.calcCrossProduct(z5,p5_e);
    Matrix jv6 = Matrix.calcCrossProduct(z6,p6_e);

    Matrix[] JV = {jv1, jv2, jv3, jv4, jv5, jv6};
    Matrix JVMatrix = Matrix.combineVectors(JV);

    return JVMatrix;
  }
  

    
  
  public float[][] getDHParameters(float[] jointAngles){
    float[] q = correctIndex(jointAngles);  //makes q[i] equal to the angle of joint i

    //Denavit-Hartenberg matrix values:
    
    //From inertial to top of rotated base
    float alpha0 = 0; float a0 = 0; float d1 = 78; float theta1 = q[1]-180;
  
    //From base to bottom of arm1
    float alpha1 = 90; float a1 = 11; float d2 = 0; float theta2 = q[2]+90;
  
    //From bottom of arm 1 to arm1/2 joint (elbow)
    float alpha2 = 0; float a2 = 130; float d3 = 18.5; float theta3 = q[3]+90;
  
    //From elbow to rotated end of arm3
    float alpha3 = 90; float a3 = 0; float d4 = 127; float theta4 = q[4];
  
    //From end of arm3 to bottom of arm4
    float alpha4 = -90; float a4 = 0; float d5 = 3; float theta5 = q[5];
  
    //from arm4 to rotated end effector
    float alpha5 = 90; float a5 = 4; float d6 = 98; float theta6 = q[6];      //to end currently is 98, we previously had 64 for d6
    
    float[][] dhParameters = {{alpha0 , a0 , d1 , theta1},
                              {alpha1 , a1 , d2 , theta2},
                              {alpha2 , a2 , d3 , theta3},
                              {alpha3 , a3 , d4 , theta4},
                              {alpha4 , a4 , d5 , theta5},
                              {alpha5 , a5 , d6 , theta6}};
                              
    //dhParams = new Matrix(dhParameters);
    
    return dhParameters;
  }
  
  //sets the six T matrices generated from the Denavit Hartenberg parameters as the calculator's attribute.
  public void updateTMatrices(float[] jointAngles)
  {
    float[][] dhParameters = getDHParameters(jointAngles);
    //get transformation from one frame to the next.
    //Ti denotes transformation from frame i-1 to frame i
    T1 = T_matrix_one(dhParameters[0]);
    T2 = T_matrix_one(dhParameters[1]);
    T3 = T_matrix_one(dhParameters[2]);
    T4 = T_matrix_one(dhParameters[3]);
    T5 = T_matrix_one(dhParameters[4]);
    T6 = T_matrix_one(dhParameters[5]);
    
    
  }
  
  //helper function useful for debugging.
  public void printMatrix(String name, float[][] matrix){
    println(name);
    for (int row=0;row<4;row++){
      print("\n");
      for (int col=0;col<4;col++){
        print(" ",String.format("%3.1f", matrix[row][col]));
      }
    }
    println("");
  }   
}
