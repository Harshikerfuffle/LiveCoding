//----------------------------------------------------------------------------
import vsync.*;
import peasy.*;
import processing.serial.*;
import processing.sound.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioIn in2; 
AudioInput in;
BeatDetect beat;
AudioPlayer song;

PeasyCam cam;

//initialize for Albers
static final int NUM_LINES = 40;
float t; 
color line1 = color(45,55,47); 
//color line2 = color(148,0,211);
color line2 = color(34,58,116);


PImage img;  

//----------------------------------------------------------------------------
void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this, 500);

  minim = new Minim(this);
  //in = minim.getLineIn(Minim, STEREO, 1024);
  beat = new BeatDetect();
  beat.setSensitivity(400);

  //Connect to Arduino
  //myPort = new Serial(this, "/dev/cu.usbmodem14301", 9600);
  //myPort.bufferUntil ( '\n' ); // Receiving the data from the Arduino IDE
  
  //Audio from synth
  //in2 = new AudioIn(this,0);
  //in2.start(); 
  //in2.play(); 
  //in = minim.getLineIn(); 
  
  img = loadImage("palm.jpg"); 

  song = minim.loadFile("/Users/sisi/Desktop/LiveCoding/Debut/Lefleur.mp3");
  song.play();
  song.loop(4);
  
}

void draw() {
   background(0,123,62);
   beat.detect(song.mix); //change to in.mix
   
    cam.beginHUD();
   for (int i = 0; i < width; i++) {
    stroke(255, song.mix.get(i)*500);
    line(i, height/2 + song.mix.get(i)*400, i, height/2 - song.mix.get(i)*400);
   }
   cam.endHUD();

   
    if (beat.isOnset()) {
    background(254,219,0);
    //Albers(); 
    //palm
    image(img,-height/4,-width/4, 300,300); 
   
    
  }
}

void Albers(){
  beat.detect(song.mix);
  strokeWeight(1);
  stroke(255);
  translate(width/2, height/2);
  for (int i=0; i<300; i++){
   stroke(line1);
   line(x1(t+i)*2, y1(t+i)*2, x2(t+i)*2, y2(t+i)*2);
   stroke(line2);
   line(x3(t+i)*2, y3(t+i)*2, x4(t+i)*2, y4(t+i)*2);
  }
  //point(x1(t), y1(t));
  //point(x2(t), y2(t));
  t += 0.5;
}

float x1(float t) {
   return -sin(t/10)*100 + sin(t/ 5)*20;
}

float y1(float t) {
   return -cos(t/10)*100;  
}

float x2(float t) {
   return sin(t/10)*200 + sin(t)*2;
}

float y2(float t) {
   return cos(t/20)*200 + cos(t/12)*20;  
}

float x3(float t) {
   return sin(t/10)*100 + sin(t/ 5)*20;
}

float y3(float t) {
   return cos(t/10)*100;  
}

float x4(float t) {
   return sin(t/10)*200 + sin(t)*2;
}

float y4(float t) {
   return cos(t/20)*200 + cos(t/12)*20;  
}
