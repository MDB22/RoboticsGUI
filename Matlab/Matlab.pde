MatlabComm comm;
MatlabTypeConverter converter;
MatlabNumericArray array;

public void setup() {
  size(900, 500);

  try {
    // Set up new MATLAB proxy session
    comm = new MatlabComm();
    comm.proxy.eval("clc");
    comm.proxy.eval("clear all");
    
    // Converts MATLAB data types to Java types and vice versa
    converter = new MatlabTypeConverter(comm.proxy);
    
    // Create starting array and visualise data
    double[][] array = new double[][] { { 10, 2, 0}, {4, 5, 6}, {7, 8, 9} };
    
    println("Original: ");
    for (int i = 0; i < array.length; i++) {
       println(java.util.Arrays.toString(array[i])); 
    }
    
    // Send array to MATLAB, then tranpose
    converter.setNumericArray("array", new MatlabNumericArray(array, null));
    comm.proxy.eval("trans = transpose(array)");
    
    // Retrieve (transposed) array from MATLAB and visualise data
    double[][] transposedArray = converter.getNumericArray("trans").getRealArray2D();
    
    println("Transposed: ");
    for (int i = 0; i < transposedArray.length; i++) {
       println(java.util.Arrays.toString(transposedArray[i])); 
    }
    
    // Now take the inverse of the array using MATLAB
    comm.proxy.eval("inverse = inv(array)");
    
    // Retrieve and visualise
    double[][] inverseArray = converter.getNumericArray("inverse").getRealArray2D();
    
    println("Inverse: ");
    for (int i = 0; i < inverseArray.length; i++) {
       println(java.util.Arrays.toString(inverseArray[i])); 
    }
    
    // Try and execute a user written script contained in another directory (need to use addpath first) 
    //comm.proxy.eval("test");
  } 
  catch (Exception e) {
    println("Exception caught!");
  }
}

void draw() {
  try {
    comm.proxy.eval("array = randn(4,3);");
    //double result = ((double[]) comm.proxy.getVariable("a"))[0];
    comm.proxy.eval("disp(['Entry: ' num2str(array(1,1))])");
    array = converter.getNumericArray("array");
    print("Entry in Matlab array: " + array.getRealValue(0,0));
    print(" ");
    
    double[][] data = array.getRealArray2D();
    print("Entry in Java array: " + data[0][0]);
    print(" ");
  } 
  catch (MatlabInvocationException e) {
    println("Not connected to Matlab session, press 'r' to reconnect.");
  }
  println("Frame rate: " + frameRate);
}

void keyPressed() {
  switch(key) {
    case ('q') :
    comm.proxy.disconnect();
    exit();
    break;
    case('d') :
    comm.proxy.disconnect();
    break;
    case('r') :
    try {
      comm.reconnect();
    } 
    catch (MatlabConnectionException e) {
      println("Error, could not connect to Matlab session.");
    }
    break;
  }
}

