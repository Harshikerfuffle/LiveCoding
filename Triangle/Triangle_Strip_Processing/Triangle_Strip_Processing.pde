// FOR PROCESSING
// looping song code reference: 
// 1. http://www.andrew.cmu.edu/course/15-100mns/bn22.pdf
// 2. http://code.compartmental.net/minim/audioplayer_method_loop.html
// livecoding for visuals w/ processing tutorial by Kesson
// https://www.youtube.com/watch?v=fO1uW-xhwtA&t=303s
// MUSIC: NUCLEYA: download link: https://nucleya.bandcamp.com/album/bass-rani

// harshikajain x sisixiyu 

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
AudioInput in;
BeatDetect beat;
AudioPlayer song;

Serial myPort; //initialise variable myPort for serial communication
float changing_colour;

PeasyCam cam;

int loopcount;

//----------------------------------------------------------------------------
void setup() {
  size(600, 400, P3D);
  cam = new PeasyCam(this, 500);

  minim = new Minim(this);
  //in = minim.getLineIn(Minim, STEREO, 1024);
  beat = new BeatDetect();
  beat.setSensitivity(400);

  myPort = new Serial(this, "/dev/cu.usbmodem14301", 9600);
  myPort.bufferUntil ( '\n' ); // Receiving the data from the Arduino IDE

  song = minim.loadFile("Nucleya - Bass Rani - 02 Bass Rani.mp3");
  song.play();
  song.loop(4);
}

//----------------------------------------------------------------------------
void serialEvent  (Serial myPort) {
  // Changing the background color according to received data
  changing_colour  =  float (myPort.readStringUntil ( '\n' ) ) ;  
} 

//----------------------------------------------------------------------------
void draw() {
  //comment the background in and out 
  //background(changing_colour, 150, 50); // Initial background color, when we will open the serial window
  background(50, 50, changing_colour); // Initial background color, when we will open the serial window

  beat.detect(song.mix);
  
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

  if (beat.isOnset()) {
    background(255);
  }

  if (mousePressed && (mouseButton == LEFT)) {
    myPort.write('1');
  }
  if (mousePressed && (mouseButton == RIGHT)) {
    myPort.write('0');
  }
}

//----------------------------------------------------------------------------
//void keyPressed (){
//  String keystr = String.valueOf(key);
//  int num = int(keystr);
//  if (num>0 && num < 10){
//    song.loop(num);
//    loopcount = num;
//  }
//}
  
//----------------------------------------------------------------------------
//void stop() {
//  song.close();
//  minim.stop();
//  super.stop();
//}

//----------------------------------------------------------------------------
// explanation of different components of code: 
// 1. blendMode(): https://processing.org/reference/blendMode_.html
