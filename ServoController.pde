import controlP5.*;
import cc.arduino.*;

public class ServoController {

  TextBoxGUI textbox;
  KnobGUI knob;

  String name;

  /* ServoController
   Inputs:
   Arduino arduino - arduino object used to control servo
   int pin - pin number for input signal to servo
   int aPin - pin number for feedback signal from servo
   ControlP5 cp5 - root controller object
   String name - name of the controller to display
   int xBox, yBox - x and y posititions of the text box area
   int width, height - width and height of the text box area
   int xKnob, yKnob - x and y positions of the knob controller
   int radius - radius of the knob controller
   float min, max, initial - min, max and initial values for controller
   */
  //ServoController(ControlP5 cp5, ControlDescriptor descriptor) {
  ServoController(Arduino arduino, int pin, ControlP5 cp5, 
  String name, int xBox, int yBox, int width, int height, int xKnob, int yKnob, 
  int radius, float min, float max, float initial, int xDisplay, int yDisplay) {

    if (arduino != null) {
      arduino.pinMode(pin, Arduino.SERVO);
    }

    textbox = new TextBoxGUI(arduino, pin, cp5, name, xBox, yBox, width, height);
    knob = new KnobGUI(arduino, pin, cp5, name, xKnob, yKnob, radius, min, max, initial); 

    textbox.setKnobGUI(knob);
    knob.setTextBoxGUI(textbox);

    this.name = name;
  }

  public float getValue() {
    return knob.getValue();
  }

  public void setValue(float value) {
    textbox.setValue(Float.toString(value));
    knob.setValue(value);
  }
}

