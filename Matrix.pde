public class Matrix {
  int numRows;
  int numCols;
  float[][] theMatrix;
  
  public Matrix(int numRows, int numCols){
    theMatrix = new float[numRows][numCols];
    this.numRows = numRows;
    this.numCols = numCols;
  }

  
  
  public Matrix(float[][] newMatrix){
    theMatrix = newMatrix;
    this.numRows = newMatrix.length;
    this.numCols = newMatrix[0].length;
  }

  
  
  
  public void setMatrix(float[][] newMatrix){
    theMatrix = newMatrix;
    this.numRows = newMatrix.length;
    this.numCols = newMatrix[0].length;
  }
  
  public float getElement(int row, int col){
    float element = theMatrix[row][col];
    return element;
  }
  public void setElement(int row, int col, float val){
    this.theMatrix[row][col]=val;
  }
  
  public float[] getSize(){
    float[] dimensions = {numRows, numCols};
    return dimensions;
  }
  public Matrix multiplyMatrix(Matrix a, Matrix b){
    Matrix cMatrix = new Matrix(a.numRows,b.numCols);
    float[][] c = new float[a.numRows][b.numCols];
    if (a.numCols == b.numRows){
      for (int row=0;row<a.numRows;row++){
        for (int col=0;col<b.numCols;col++){
          for (int k=0;k<a.numCols;k++){
            c[row][col]+=a.getElement(row, k)*b.getElement(k, col);
          }
          
        }
      }
      cMatrix.setMatrix(c);
    }
    else{
      System.out.println("Error: matrix dimensions incompatible for multiplication.");
    }
    return cMatrix;
  }
  
  public Matrix addMatrix(Matrix a, Matrix b){
    Matrix cMatrix = new Matrix(a.numRows, a.numCols);
    float[][] c = new float[a.numRows][a.numCols];
    if ((a.numRows == b.numRows)&&(a.numCols == b.numCols)){
      for (int row=0;row<a.numRows;row++){
        for (int col=0;col<a.numCols;col++){
          cMatrix.setElement(row, col, a.getElement(row, col)+b.getElement(row,col));
        }
      }
    }
    return cMatrix;
  }
  public Matrix subtractMatrix(Matrix a, Matrix b){
    Matrix cMatrix = new Matrix(a.numRows, a.numCols);
    float[][] c = new float[a.numRows][a.numCols];
    if ((a.numRows == b.numRows)&&(a.numCols == b.numCols)){
      for (int row=0;row<a.numRows;row++){
        for (int col=0;col<a.numCols;col++){
          cMatrix.setElement(row, col, a.getElement(row, col)-b.getElement(row,col));
        }
      }
    }
    return cMatrix;
  }

  
  public Matrix transpose(){
    Matrix transposeMatrix = new Matrix(this.numCols,this.numRows);
    for (int row=0;row<this.numRows;row++){
      for (int col=0;col<this.numCols;col++){
        transposeMatrix.setElement(col,row,this.getElement(row,col));
      }
    }
    return transposeMatrix;
  }
  
  public Matrix inverse(){
    float[][] blank = {{0}};
    Matrix b = new Matrix(blank);
    if (this.numRows != this.numCols){
      System.out.println("Error: cannot invert non square matrix");
    }
    else if (this.numRows == 2){
      b = this.inverse2x2();
    }
    else if (this.numRows == 3){
      b = this.inverse3x3();
    }
    else if (this.numRows == 4){
      b = this.inverse4x4();
    }
      return b;    
  }
  
  private Matrix inverse2x2(){
    float a = this.getElement(0, 0);
    float b = this.getElement(0, 1);
    float c = this.getElement(1, 0);
    float d = this.getElement(1,1);
    
    float det = a*d-b*c;
    float[][] inv = {{d, -b},{-c, a}};
    Matrix inverse = new Matrix(inv);
    inverse = inverse.scalarMultiply(1/det);
    return inverse;
  }
  
  private Matrix inverse3x3(){
    float a = this.getElement(0, 0);
    float b = this.getElement(0, 1);
    float c = this.getElement(0, 2);
    float d = this.getElement(1, 0);
    float e = this.getElement(1, 1);
    float f = this.getElement(1, 2);
    float g = this.getElement(2, 0);
    float h = this.getElement(2, 1);
    float i = this.getElement(2, 2);
    
    float A = e*i-f*h;
    float B = -(d*i-f*g);
    float C = d*h-e*g;
    float D = -(b*i-c*h);
    float E = a*i-c*g;
    float F = -(a*h-b*g);
    float G = b*f-c*e;
    float H = -(a*f-c*d);
    float I = a*e-b*d;
    
    float det = a*A+b*B+c*C;
    if (det==0)
      System.out.println("matrix is singular.");
    float[][] inv = {{A, D, G}, {B, E, H}, {C, F, I}};
    Matrix inverse = new Matrix(inv);
    inverse = inverse.scalarMultiply(1/det);
    return inverse;
  }
  
  private Matrix inverse4x4(){
    float[][] Aarray = {{this.getElement(0, 0), this.getElement(0,1)},
            {this.getElement(1, 0), this.getElement(1,1)}};
    
    float[][] Barray = {{this.getElement(0, 2), this.getElement(0,3)},
            {this.getElement(1, 2), this.getElement(1,3)}};
    
    float[][] Carray = {{this.getElement(2, 0), this.getElement(2,1)},
            {this.getElement(3, 0), this.getElement(3,1)}};

    float[][] Darray = {{this.getElement(2, 2), this.getElement(2,3)},
            {this.getElement(3, 2), this.getElement(3,3)}};
    
    Matrix A = new Matrix(Aarray);
    Matrix B = new Matrix(Barray);
    Matrix C = new Matrix(Carray);
    Matrix D = new Matrix(Darray);
    
    Matrix Ai = A.inverse();
    Matrix CAi = multiplyMatrix(C, Ai);
    
    Matrix m11 = multiplyMatrix(Ai,B);          //Ai + Ai*B(D-C*Ai*B)i*C*Ai
    m11 = multiplyMatrix(m11,dcab(D,CAi,B));
    m11 = multiplyMatrix(m11,CAi);
    m11 = addMatrix(Ai, m11);
    
    Matrix m12 = multiplyMatrix(Ai,B);
    m12 = m12.scalarMultiply(-1);
    m12 = multiplyMatrix(m12,dcab(D,CAi,B));
    
    Matrix m21 = dcab(D,CAi,B).scalarMultiply(-1);  //-(D-CAiB)iCAi
    m21 = multiplyMatrix(m21,CAi);
    
    Matrix m22 = dcab(D,CAi,B);
    
    float[][] newmatrixarray = {{m11.getElement(0,0), m11.getElement(0,1), m12.getElement(0,0), m12.getElement(0,1)},
                                {m11.getElement(1,0), m11.getElement(1,1), m12.getElement(1,0), m12.getElement(1,1)},
                                {m21.getElement(0,0), m21.getElement(0,1), m22.getElement(0,0), m22.getElement(0,1)},
                                {m21.getElement(1,0), m21.getElement(1,1), m22.getElement(1,0), m22.getElement(1,1)}};
                                
    Matrix inverse = new Matrix(newmatrixarray);
    return inverse;
  }
  
  private Matrix dcab(Matrix D, Matrix CAi, Matrix B){  //calculates (D-C*Ai*B)i
    Matrix temp = multiplyMatrix(CAi, B);
    temp = subtractMatrix(D,temp);
    temp = temp.inverse();
    return temp;
  }
    
  public Matrix scalarMultiply(float scalar){
    Matrix scaledMatrix = new Matrix(this.numRows, this.numCols);
    for (int row=0;row<numRows;row++){
      for (int col=0;col<numCols;col++){
        float newVal = scalar*this.getElement(row,col);
        scaledMatrix.setElement(row,col,newVal);
      }
    }
    return scaledMatrix;
  }
  
  
  public float[][] getMatrix(){
    return theMatrix;
  }
  public void printMatrix(String name){
    println(name);
    for (int row=0;row<numRows;row++){
      for (int col=0;col<numCols;col++){
        print(String.format("%3.4f ", this.getElement(row,col)));
      }
      print("\n");
    }
    print("\n");
  }
}

