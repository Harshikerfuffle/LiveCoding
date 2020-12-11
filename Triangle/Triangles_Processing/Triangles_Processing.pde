// FOR PROCESSING CONSOLE 
// code has been referenced from different locations
// triangles code: https://www.openprocessing.org/sketch/584467
// tutorial on arduino and processing communication: https://maker.pro/arduino/tutorial/how-to-make-arduino-and-processing-ide-communicate

// harshikajain  x  sisiyu

//----------------------------------------------------------------------------

import processing.serial.*; //import library to communicate with arduino
Serial myPort; //initialise variable myPort for serial communication
float background_colour; //variable for changing background colour

import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioPlayer song;

ArrayList poop;
boolean flag=true;
int distance=100;

import processing.sound.*;

//----------------------------------------------------------------------------
void setup() {
  size (600, 600); //size of the serial window
  myPort = new Serial(this, "/dev/cu.usbmodem14301", 9600);
  myPort.bufferUntil ('\n'); // Receiving the data from the Arduino IDE

  smooth();
  poop = new ArrayList();
  for (int i=0; i<200; i++) {
    Particle P = new Particle();
    poop.add(P);
  }
  
  minim = new Minim (this);
  song = minim.loadFile ("bensound-clearday.mp3");
  song.play();
} 

//----------------------------------------------------------------------------
void serialEvent (Serial myPort){
  background_colour  =  float (myPort.readStringUntil ('\n')) ;  
  // Changing the background color according to received data
} 

//----------------------------------------------------------------------------
void draw ( ) {
  background (150, 50, background_colour);// Initial background color, when we will open the serial window 
  
  //float amplitude = song.mix.level();
  
  for (int i=0; i<poop.size(); i++){
    Particle Pn1 = (Particle) poop.get(i);
    Pn1.display();
    Pn1.update();
    
    for (int j = i + 1; j < poop.size(); j++) {
      Particle Pn2 = (Particle) poop.get(j);
      Pn2.update();
      
      if (dist(Pn1.x, Pn1.y, Pn2.x, Pn2.y)< distance){
        for (int k = j + 1; k < poop.size(); k++) {
          Particle Pn3 = (Particle) poop.get(k);
          
          if (dist(Pn3.x, Pn3.y, Pn2.x, Pn2.y)< distance) {
            if (flag) {
              stroke(255, 5);
              fill(Pn3.c, 20); // method to access the class property
            } 
            else {
              noFill();
              strokeWeight(1);
              stroke(50, 5);
            }
            beginShape(TRIANGLES);
            vertex(Pn1.x, Pn1.y);
            vertex(Pn2.x, Pn2.y);
            vertex(Pn3.x, Pn3.y);
            endShape();
          }
          Pn3.update();
        }
      }
    }
  }

  if ( mousePressed && ( mouseButton == LEFT )) { // if the left mouse button is pressed
    myPort.write ('1');// send a '1' to the Arduino IDE
  } 

  if (mousePressed && (mouseButton == RIGHT)) {  // if the right mouse button is pressed
    myPort.write ('0') ; // Send a '0' to the Arduino IDE
  }
} 

//----------------------------------------------------------------------------
void keyPressed()
{
  flag=!flag;
}
class Particle {
  float x, y, r;
  color c;
  int i=1, j=1;
  Particle( ){
    x = random(0, width);
    y = random(0, height);
    r = random(1, 5);
    int j = (int)random(0, 4);
    
    if (j==0){
      c = color(#ff66ff);
    }
    if (j==1){
      c = color(#ffff4d);
    }
    if (j==2){
      c = color(#a6ff4d);
    }
    if (j==3){
      c = color(#80dfff);
    }
  }

//----------------------------------------------------------------------------
  void display(){
    pushStyle();
    noStroke();
    fill(c);
    ellipse(x, y, r, r);
    popStyle();
  }

//----------------------------------------------------------------------------
  void update(){
    x = x + j*0.01;
    y = y + i*0.01;
    if (y > height-r) i=-1;
    if (y < 0+r) i=1;
    if (x > width-r) j=-1;
    if (x < 0+r) j=1;
  }
}

//----------------------------------------------------------------------------
void stop() { //called whenever a sketch is closed
  song.close();
  minim.stop();
  super.stop();
}
