// FOR PROCESSING
// looping song code reference: 
// 1. http://www.andrew.cmu.edu/course/15-100mns/bn22.pdf
// 2. http://code.compartmental.net/minim/audioplayer_method_loop.html
// livecoding for visuals w/ processing tutorial by Kesson
// https://www.youtube.com/watch?v=fO1uW-xhwtA&t=303s
// MUSIC: NUCLEYA: download link: https://nucleya.bandcamp.com/album/bass-rani

// sisixiyu x harshikajain

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

//Serial myPort; //initialise variable myPort for serial communication
float changing_colour;

PeasyCam cam;

int loopcount;

//initialize for Albers
static final int NUM_LINES = 40;
float t; 
color line1 = color(45,55,47); 
//color line2 = color(148,0,211);
color line2 = color(34,58,116);

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

  song = minim.loadFile("/Users/sisi/Desktop/LiveCoding/Debut/Nina.mp3");
  song.play();
  song.loop(4);
}

//----------------------------------------------------------------------------
//void serialEvent  (Serial myPort) {
//  // Changing the background color according to received data
//  changing_colour  =  float (myPort.readStringUntil ( '\n' ) ) ;  
//} 

//----------------------------------------------------------------------------
void draw() {
  //comment the background in and out 
  //background(changing_colour, 150, 50); // Initial background color, when we will open the serial window
  background(50, 50, 200); // Initial background color, when we will open the serial window

  beat.detect(song.mix);
  
  //cam.beginHUD();
  //for (int i=0; i<width; i++){
  // stroke(255); 
  // line(i, height/2+song.mix.get(i)*300, i, height/2-song.mix.get(i)*300); 
  //}
  //cam.endHUD();

//Calling pattern
//----------------------------------------------------------------------------------------
  //stroke(255);
  //Albers(); 
  
  //--------------------------------------------------------------------------------------
  blendMode(NORMAL);
  perspective(PI/3.0, width/ height, 10.0, 1000000.0);

  cam.rotateY(0.04); 
  cam.rotateX(0.04);
  cam.setDistance (500 + abs(sin(frameCount*0.01))*500);

  cam.beginHUD();
  for (int i = 0; i < width; i++) {
    stroke(255, song.mix.get(i)*500);
    line(i, height/2 + song.mix.get(i)*400, i, height/2 - song.mix.get(i)*400);
  }
  cam.endHUD();

  hint(DISABLE_DEPTH_TEST);

  int total = 100;
  PVector[][]pp = new PVector[total][total];

  for (int i = 0; i < total; i++) {
    float lat = map(i, 0, total-1, -HALF_PI, HALF_PI);

    for (int j = 0; j < total; j++) {
      float lon = map (j, 0, total-1, -PI, PI);

      int imnd = i + j * total;
      float r = 200 + song.mix.get(imnd%1024)*200;

      float x = r* cos(lat) * cos(lon);
      float y = r* sin(lat) * cos(lon);
      float z = r * sin(lon);
      pp [i][j] = new PVector(x, y, z);
    }
  }

    //Blends the pixels in the display window according to a defined mode.
    //ADD - additive blending with white clip: C = min(A*factor + B, 255)
    blendMode (ADD);

  for (int i = 0; i< total-1; i++) {

    beginShape(TRIANGLE_STRIP);
    stroke(150, 50, changing_colour, song.mix.get(i)*500);
    noFill();
    //fill(song.mix.get(i)*500);

    for (int j = 0; j<total; j++) {
      vertex (pp[i][j].x, pp[i][j].y, pp[i][j].z);
      vertex (pp[i+1][j].x, pp[i+1][j].y, pp[i+1][j].z);
    }
    endShape();
  }

//---------------------------------------------------------------------------------------
  if (beat.isOnset()) {
    background(255);
    //Albers(); 
  }
//---------------------------------------------------------------------------------------
  //if (mousePressed && (mouseButton == LEFT)) {
  //  myPort.write('1');
  //}
  //if (mousePressed && (mouseButton == RIGHT)) {
  //  myPort.write('0');
  //}
}

//----------------------------------------------------------------------------

void Albers(){
  strokeWeight(3);
  translate(width/2, height/2);
  for (int i=0; i<NUM_LINES; i++){
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
