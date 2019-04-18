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
AudioInput in;
BeatDetect beat;
AudioPlayer song;

Serial myPort; //initialise variable myPort for serial communication
PeasyCam cam;

float changing_colour; //variable for changing background colour
int inByte;

//initialize for Albers
static final int NUM_LINES = 50;
float t; 
color line1 = color(255, 255, 255); 
//color line2 = color(148,0,211);
color line2 = color(34,58,116);

//initialize for pinkFloyd
float maxX;
float maxY;
float x;
float y;
int r =  200 ; // right, moving right to the center

//----------------------------------------------------------------------------
void setup() {
  size(600, 400, P3D);
  cam = new PeasyCam(this, 500);

  //in = minim.getLineIn(Minim, STEREO, 1024);
  beat = new BeatDetect();
  beat.setSensitivity(400);

  myPort = new Serial(this, "/dev/cu.usbmodem14301", 9600);
  // don't generate a serialEvent() unless you get a newline character:
  //myPort.bufferUntil('\n'); // Receiving the data from the Arduino IDE

  minim = new Minim(this);
  song = minim.loadFile("Nucleya - Bass Rani - 02 Bass Rani.mp3");
  song.play();
  song.loop(3);
}

//----------------------------------------------------------------------------
void serialEvent  (Serial myPort) {
  // Changing the background color according to received data
  //changing_colour  =  float (myPort.readStringUntil('\n')) ;
  inByte = myPort.read();
  println(inByte);
} 

//----------------------------------------------------------------------------
void draw() {
  //if (millis() < 4000){}
  //else{
  //  println("Serial Message Received: " + inByte); // print it:
  
    //if (inByte > 4){ // check if this can read potentiometer values
    //background (150, 50, changing_colour);
    //}
    
    if (inByte == 1){
    crazyCircle();
    }
    
    if (inByte == 2){
    Albers();
    }
    
    if (inByte == 3){
    //circleBoom();
    pinkFloyd();
    }
    
    if (inByte == 4){
      background (0);
      cam.beginHUD();
      for (int i = 0; i < width; i++) {
        stroke(255, 50, 100, song.mix.get(i)*500);
        //line(i, height/2 + song.mix.get(i)*400, i, height/2 - song.mix.get(i)*400);
        //star(i, i, height/2 + song.mix.get(i)*400, height/2 - song.mix.get(i)*400, 8);
        star(width/2, height/2, height/4 + song.mix.get(i)*400, height/4 - song.mix.get(i)*400, 8);
      }
      cam.endHUD();
    }
  
  if (mousePressed && (mouseButton == LEFT)) {
    myPort.write('1');
  }
  if (mousePressed && (mouseButton == RIGHT)) {
    myPort.write('0');
  }
}
//----------------------------------------------------------------------------
void crazyCircle() {
  //comment the background in and out 
  //background(changing_colour, 150, 50); // Initial background color, when we will open the serial window
  background(0); // Initial background color, when we will open the serial window

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
    stroke(150, 50, 50, song.mix.get(i)*500);
    noFill();
    fill(song.mix.get(i)*500);

    for (int j = 0; j<total; j++) {
      vertex (pp[i][j].x, pp[i][j].y, pp[i][j].z);
      vertex (pp[i+1][j].x, pp[i+1][j].y, pp[i+1][j].z);
    }
    endShape();
  }

  if (beat.isOnset()) {
    background(255);
  }
}
 
//----------------------------------------------------------------------------
void Albers(){
  background(0);
  strokeWeight(3);
  translate(width/2, height/2);
  
  cam.beginHUD();
  for (int i=0; i<width; i++){
   stroke(255);
   line(x1(t+i)*2, y1(t+i)*2, x2(t+i)*2, y2(t+i)*2);
   stroke(line2);
   line(x3(t+i)*2, y3(t+i)*2, x4(t+i)*2, y4(t+i)*2);
  }
  cam.endHUD();
  blendMode (ADD);
  //point(x1(t), y1(t));
  //point(x2(t), y2(t));
  t += song.mix.level();
}

float x1(float t) {
   return -sin(t/10)*100 + sin(t/ 5)*20;}

float y1(float t) {
   return -cos(t/10)*100;}

float x2(float t) {
   return sin(t/10)*200 + sin(t)*2;}

float y2(float t) {
   return cos(t/20)*200 + cos(t/12)*20;}

float x3(float t) {
   return sin(t/10)*100 + sin(t/ 5)*20;}

float y3(float t) {
   return cos(t/10)*100;}

float x4(float t) {
   return sin(t/10)*200 + sin(t)*2;}

float y4(float t) {
   return cos(t/20)*200 + cos(t/12)*20;}

//----------------------------------------------------------------------------
void circleBoom (){
  background(0);
  noFill();
  float amplitude = song.mix.level();
  float size = amplitude * 1000;
  
  cam.beginHUD();
  stroke(255);
  ellipseMode(CENTER);
  ellipse(width/2, height/2, size, size);
  cam.endHUD();
}

//----------------------------------------------------------------------------
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
 
}
//----------------------------------------------------------------------------
void pinkFloyd(){
  // BACKGROUND, + FIXED FIGURES
  background ( 0 );
  stroke ( 255 );
  noFill ();
  smooth();
  triangle ( 450 , 100 , 50 , 800 , 850 , 800 );
  fill ( 255 , 255 , 255 , 220 );
  stroke ( 255 );
  PShape w;
     w = createShape ();
     w . beginShape ();
     w . vertex ( 0 , 500 );
     w . vertex ( 0 , 510 );
     w . vertex ( 251 , 420 );
     w . vertex ( 257 , 410 );
     w . vertex ( 0 , 500 );
     w . vertex ( 257 , 410 );
     w . vertex ( 410 , 390 );
     w . vertex ( 390 , 460 );
     w . vertex ( 251 , 420 );
     
     shape (w, 10 , 10 );
     w . endShape ();
     
    noFill ();
  
  // SQUARES CIRCLE MOVE
  for (int i = 0; i < width; i++) {
    maxX = ( float ) 180 / width * song.mix.get(i)*800 ;
    maxY = ( float ) 180 / height * song.mix.get(i)*800 ;
  }

  translate ( width / 2 , height / 2 );
  for ( int i =  0 ; i <  360 ; i += 2 ){
     x =  sin ( radians (i)) * maxX;
     y =  cos ( radians (i)) * maxY;
    
    // 1st RED FIGURE
    stroke ( 255 , 3 , 3 );
    pushMatrix ();
    translate (x + r, y - 120 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    pushMatrix ();
    translate ( - x + r, - y - 120 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    // 2nd ORANGE FIGURE
    stroke ( 255 , 142 , 3 );
    pushMatrix ();
    translate (x + r, y - 40 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    pushMatrix ();
    translate ( - x + r, - y - 40 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    
    // 3rd YELLOW FIGURE
    stroke ( 255 , 247 , 3 );
    pushMatrix ();
    translate (x + r, y + 40 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    pushMatrix ();
    translate ( - x + r, - y + 40 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    
    // 4th GREEN FIGURE
    stroke ( 3 , 255 , 46 );
    pushMatrix ();
    translate (x + r, y + 120 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    pushMatrix ();
    translate ( - x + r, - y + 120 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();

    // 5th LIGHT BLU FIGURE
    stroke ( 3 , 232 , 255 );
    pushMatrix ();
    translate (x + r, y + 200 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    pushMatrix ();
    translate ( - x + r, - y + 200 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    // 6th PURPLE FIGURE
    stroke ( 221 , 3 , 255 );
    pushMatrix ();
    translate (x + r, y + 280 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
    
    pushMatrix ();
    translate ( - x + r, - y + 280 );
    rotate ( radians (i - frameCount ));
    rect ( 0 , 0 , 35 , 35 );
    popMatrix ();
  }
}

//----------------------------------------------------------------------------
void stop() {
  song.close();
  minim.stop();
  super.stop();
}

//----------------------------------------------------------------------------
// explanation of different components of code: 
// 1. blendMode(): https://processing.org/reference/blendMode_.html
// 2. star(): https://www.processing.org/examples/star.html
// 3. void pinkFloyd(): https://github.com/robertofazio/IED_GenerativeDesign_1_StudentsFinalExame/blob/master/Michele%20Martelli/sketch_TheDarkSideOfTheMoon/sketch_TheDarkSideOfTheMoon.pde
