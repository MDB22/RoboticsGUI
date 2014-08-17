/* 
 This class performs the mathematics of calculating the transformation matrix.
*/
public class MatrixCalculator{
  
  public MatrixCalculator(){
  }
  
  //Calculates the transformation matrix from the end effector frame to the inertial frame,
  //given the joint angles of the robot.
  public float[][] calcTMatrix(float[] jointAngles)
  {
    float[] q = correctIndex(jointAngles);  //makes q[i] equal to the angle of joint i

    //Denavit-Hartenberg matrix values:
    
    //From inertial to top of rotated base
    float alpha0 = 0; float a0 = 0; float d1 = 78; float theta1 = q[1];
  
    //From base to bottom of arm1
    float alpha1 = 90; float a1 = 11; float d2 = 0; float theta2 = q[2]+90;
  
    //From bottom of arm 1 to arm1/2 joint (elbow)
    float alpha2 = 0; float a2 = 130; float d3 = 18.5; float theta3 = q[3]+90;
  
    //From elbow to rotated end of arm3
    float alpha3 = 90; float a3 = 0; float d4 = 127; float theta4 = q[4];
  
    //From end of arm3 to bottom of arm4
    float alpha4 = -90; float a4 = 0; float d5 = 3; float theta5 = q[5];
  
    //from arm4 to rotated end effector
    float alpha5 = 90; float a5 = 4; float d6 = 64; float theta6 = q[6];
  
  //get transformation from one frame to the next.
  //Ti denotes transformation from frame i-1 to frame i
    float[][] T1 = T_matrix_one(alpha0, a0 ,d1, theta1);
    float[][] T2 = T_matrix_one(alpha1, a1 ,d2, theta2);
    float[][] T3 = T_matrix_one(alpha2, a2 ,d3, theta3);
    float[][] T4 = T_matrix_one(alpha3, a3 ,d4, theta4);
    float[][] T5 = T_matrix_one(alpha4, a4 ,d5, theta5);
    float[][] T6 = T_matrix_one(alpha5, a5 ,d6, theta6);
   
    //T = T1*T2*T3*T4*T5*T6;
    float[][] T = multiply4x4Matrix(T1, T2);
    T = multiply4x4Matrix(T, T3);
    T = multiply4x4Matrix(T, T4);
    T = multiply4x4Matrix(T, T5);
    T = multiply4x4Matrix(T, T6);
    
    return T;
  }
  //Computes transformation matrix from one frame to the next given D-H parameters
  public float[][] T_matrix_one(float alpha, float a, float d, float theta){
    float alpha_rad = radians(alpha);
    float theta_rad = radians(theta);
    
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

    //T = Rx_alpha * Dx_a * Rz_theta * Dz_d;
    float[][] T = multiply4x4Matrix(Rx_alpha,Dx_a);
    T = multiply4x4Matrix(T,Rz_theta);
    T = multiply4x4Matrix(T,Dz_d);

    return T;
  }
  
  //ensures q[i] is the angle of joint i.
  public float[] correctIndex(float[] jointAngles){
      float[] q = {0, jointAngles[0], jointAngles[1], jointAngles[2], jointAngles[3], jointAngles[4], jointAngles[5]};
      return q;
  }
      
  //matrix multiplication for a 4x4 matrix
  public float[][] multiply4x4Matrix(float[][] a, float[][] b){
    float c[][] = new float[4][4];
    
    for (int row=0;row<4;row++){
      for (int col=0;col<4;col++){
        for (int k=0;k<4;k++){
          c[row][col]+=a[row][k]*b[k][col];
        }
      }
    }
    return c;
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
