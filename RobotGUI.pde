public class RobotGUI{
  MatrixGUI matrixGUI;
  
  public RobotGUI(MatrixGUI matrixGUI){
    this.matrixGUI = matrixGUI;
  }
  
  public void rotate(char axis, float angle){
    float angle_rad = -radians(angle);
    switch (axis) {
      case 'x':
        rotateX(angle_rad);
        break;
      case 'y':
        rotateY(angle_rad);
        break;
      case 'z':
        rotateZ(angle_rad);
        break;
    }
  }
    
  public void drawArm(char axis, float x, float y, float z){
    switch (axis) {
      case 'x':
        translate(x/2,0,0);
        box(abs(x),abs(y),abs(z));
        translate(x/2,0,0);
        break;
      case 'y':
        translate(0,-y/2,0);
        box(abs(x),abs(y),abs(z));
        translate(0,-y/2,0);
        break;
      case 'z':
        translate(0,0,z/2);
        box(abs(x),abs(y),abs(z));
        translate(0,0,z/2);
        break;
    }
  }
    
  
  public void drawRobot(){
    //rect(matrixGUI.jointAngles[0],70,10,100);
    lights();

    pushMatrix();              //setting up inertial frame
     
      translate(1050,500,50);
       scale(0.7,0.7,0.7);
      rotateX(radians(90));
      
      pushMatrix();
                        fill(255,0,0);
                  drawArm('x',80,3,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,255,0);
                  drawArm('y',3,80,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,0,255);
                  drawArm('z',3,3,80);
                  fill(255,255,255);
      popMatrix();
      drawArm('z',50,50,50);                    //Non-rotating part of the base
      pushMatrix();
        rotate('z',matrixGUI.jointAngles[0]);    //joint 1- Rotating Base

        drawArm('z',50,50,28);
        pushMatrix();
          translate(11,0,0);    //a1
          rotate('x',90);  //alpha1
          rotate('z',matrixGUI.jointAngles[1]+90);  //theta2  //joint 2- shoulder
                        pushMatrix();
                        fill(255,0,0);
                  drawArm('x',80,3,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,255,0);
                  drawArm('y',3,80,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,0,255);
                  drawArm('z',3,3,80);
                  fill(255,255,255);
      popMatrix();
          drawArm('x',130,20,20); //a2            

          pushMatrix();    //alpha2 = 0;
            rotate('z',matrixGUI.jointAngles[2]+90);  //theta3  //joint 3- elbow
                          pushMatrix();
                        fill(255,0,0);
                  drawArm('x',80,3,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,255,0);
                  drawArm('y',3,80,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,0,255);
                  drawArm('z',3,3,80);
                  fill(255,255,255);
      popMatrix();
            drawArm('y',10,-95,10);  //d3        
            
            pushMatrix();
              rotate('x',90);    //alpha3
              rotate('z',matrixGUI.jointAngles[3]);  //theta4    //joint 4- wrist roll
                            pushMatrix();
                        fill(255,0,0);
                  drawArm('x',80,3,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,255,0);
                  drawArm('y',3,80,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,0,255);
                  drawArm('z',3,3,80);
                  fill(255,255,255);
      popMatrix();
              drawArm('z',10,5,32);  //d4        //
              
              pushMatrix();
                rotate('x',-90);    //alpha4
                rotate('z',matrixGUI.jointAngles[4]);      //joint 5- wrist pitch
                              pushMatrix();
                        fill(255,0,0);
                  drawArm('x',80,3,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,255,0);
                  drawArm('y',3,80,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,0,255);
                  drawArm('z',3,3,80);
                  fill(255,255,255);
      popMatrix();
                drawArm('y',5,-64,10);
                
                pushMatrix();
                  rotate('x',90);
                  rotate('z',matrixGUI.jointAngles[5]);  //joint 6- wrist yaw
                  drawArm('z',15,15,15);
                  
                  pushMatrix();
                  fill(255,0,0);
                  drawArm('x',40,3,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,255,0);
                  drawArm('y',3,40,3);
                  popMatrix();
                  pushMatrix();
                  fill(0,0,255);
                  drawArm('z',3,3,40);
                  fill(255,255,255);
                  popMatrix();
                popMatrix();
              popMatrix();
            popMatrix();
          popMatrix();
        popMatrix();
      popMatrix();
    popMatrix();
    /*pushMatrix();
    translate(70, matrixGUI.jointAngles[0]);
    translate(matrixGUI.jointAngles[1],0);
    pushMatrix();
    rotateX(matrixGUI.jointAngles[2]*PI/180);
    box(5, 20, 50);
    popMatrix();
    popMatrix();
    popMatrix();*/
  }
}
