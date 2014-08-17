import matrixMath.*;

public class MatrixCalculator{
  
  public MatrixCalculator(){
    //float[][] a,b;
    //a = T_matrix_one(20,30,15,20);
    //b = calcTMatrix(0,90,0,0,0,0);
    //printMatrix("T",b);
  }
  
  public float[][] calcTMatrix(float q1, float q2, float q3, float q4, float q5, float q6)
  {
    //From inertial to top of rotated base
    float alpha0 = 0; float a0 = 0; float d1 = 78; float theta1 = q1;
  
    //From base to bottom of arm1
    float alpha1 = 90; float a1 = 11; float d2 = 0; float theta2 = q2+90;
  
    //From bottom of arm 1 to arm1/2 joint (elbow)
    float alpha2 = 0; float a2 = 130; float d3 = 18.5; float theta3 = q3+90;
  
    //From elbow to rotated end of arm3
    float alpha3 = 90; float a3 = 0; float d4 = 127; float theta4 = q4;
  
    //From end of arm3 to bottom of arm4
    float alpha4 = -90; float a4 = 0; float d5 = 3; float theta5 = q5;
  
    //from arm4 to rotated end effector
    float alpha5 = 90; float a5 = 4; float d6 = 64; float theta6 = q6;
  
  //get transformation from one frame to the next.
  //Ti denotes transformation from frame i-1 to frame i
    float[][] T1 = T_matrix_one(alpha0, a0 ,d1, theta1);
    //printMatrix("T1", T1);
    float[][] T2 = T_matrix_one(alpha1, a1 ,d2, theta2);
    //printMatrix("T2", T2);
    float[][] T3 = T_matrix_one(alpha2, a2 ,d3, theta3);
    //printMatrix("T3", T3);
    float[][] T4 = T_matrix_one(alpha3, a3 ,d4, theta4);
    //printMatrix("T4", T4);
    float[][] T5 = T_matrix_one(alpha4, a4 ,d5, theta5);
    //printMatrix("T5", T5);
    float[][] T6 = T_matrix_one(alpha5, a5 ,d6, theta6);
    //printMatrix("T6", T6);
   
    //T = T1*T2*T3*T4*T5*T6;
    float[][] T = multiply4x4Matrix(T1, T2);
    T = multiply4x4Matrix(T, T3);
    T = multiply4x4Matrix(T, T4);
    T = multiply4x4Matrix(T, T5);
    T = multiply4x4Matrix(T, T6);
    return T;
}
  public float[][] T_matrix_one(float alpha, float a, float d, float theta){
    float alpha_rad = radians(alpha);
    float theta_rad = radians(theta);
    float[][] Rx_alpha = { {1, 0, 0, 0}, 
                          {0, cos(alpha_rad), -sin(alpha_rad),0},
                          {0, sin(alpha_rad), cos(alpha_rad),0},
                          {0, 0, 0, 1}   };
    
    float[][] Dx_a = { {1, 0, 0, a},
                       {0, 1, 0, 0},
                       {0, 0, 1, 0},
                       { 0, 0, 0, 1}    };
    
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
  public float[][] multiply4x4Matrix(float[][] a, float[][] b){
    float c11 = a[0][0]*b[0][0] + a[0][1]*b[1][0] + a[0][2]*b[2][0] + a[0][3]*b[3][0];
    float c12 = a[0][0]*b[0][1] + a[0][1]*b[1][1] + a[0][2]*b[2][1] + a[0][3]*b[3][1];
    float c13 = a[0][0]*b[0][2] + a[0][1]*b[1][2] + a[0][2]*b[2][2] + a[0][3]*b[3][2];
    float c14 = a[0][0]*b[0][3] + a[0][1]*b[1][3] + a[0][2]*b[2][3] + a[0][3]*b[3][3];
    
    float c21 = a[1][0]*b[0][0] + a[1][1]*b[1][0] + a[1][2]*b[2][0] + a[1][3]*b[3][0];
    float c22 = a[1][0]*b[0][1] + a[1][1]*b[1][1] + a[1][2]*b[2][1] + a[1][3]*b[3][1];
    float c23 = a[1][0]*b[0][2] + a[1][1]*b[1][2] + a[1][2]*b[2][2] + a[1][3]*b[3][2];
    float c24 = a[1][0]*b[0][3] + a[1][1]*b[1][3] + a[1][2]*b[2][3] + a[1][3]*b[3][3];
    
    float c31 = a[2][0]*b[0][0] + a[2][1]*b[1][0] + a[2][2]*b[2][0] + a[2][3]*b[3][0];
    float c32 = a[2][0]*b[0][1] + a[2][1]*b[1][1] + a[2][2]*b[2][1] + a[2][3]*b[3][1];
    float c33 = a[2][0]*b[0][2] + a[2][1]*b[1][2] + a[2][2]*b[2][2] + a[2][3]*b[3][2];
    float c34 = a[2][0]*b[0][3] + a[2][1]*b[1][3] + a[2][2]*b[2][3] + a[2][3]*b[3][3];
    
    float c41 = a[3][0]*b[0][0] + a[3][1]*b[1][0] + a[3][2]*b[2][0] + a[3][3]*b[3][0];
    float c42 = a[3][0]*b[0][1] + a[3][1]*b[1][1] + a[3][2]*b[2][1] + a[3][3]*b[3][1];
    float c43 = a[3][0]*b[0][2] + a[3][1]*b[1][2] + a[3][2]*b[2][2] + a[3][3]*b[3][2];
    float c44 = a[3][0]*b[0][3] + a[3][1]*b[1][3] + a[3][2]*b[2][3] + a[3][3]*b[3][3];
    
    float[][] matrixC = {{c11,c12,c13,c14},{c21,c22,c23,c24},{c31,c32,c33,c34},{c41,c42,c43,c44}};
    return matrixC;
  }

  public void printMatrix(String name, float[][] matrix){
    println(name);
    for (int i=0;i<4;i++){
      print("\n");
      for (int j=0;j<4;j++){
        print(" ",String.format("%3.1f", matrix[i][j]));
      }
    }
    println("");
  }   
}
