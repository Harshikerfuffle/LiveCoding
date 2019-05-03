// FOR PROCESSING
// looping song code reference: 
// 1. http://www.andrew.cmu.edu/course/15-100mns/bn22.pdf
// 2. http://code.compartmental.net/minim/audioplayer_method_loop.html
// livecoding for visuals w/ processing tutorial by Kesson
// https://www.youtube.com/watch?v=fO1uW-xhwtA&t=303s

//Base file setup for future shows
// sisixiyu x harshikajain
//----------------------------------------------------------------------------

//Imported libraries 
import vsync.*;
import peasy.*; //camera
import processing.sound.*; //for catching sound files 

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
//AudioInput song; 

PeasyCam cam;

PGraphics pg;
//Drag file in 
PImage img;    

//initialize for Albers
static final int NUM_LINES = 50;
float t; 
color line3 = color(255, 255, 255); 
color line4 = color(34, 58, 116);


// initialize for Flowfield object
FlowField flowfield;
// An ArrayList of brushes
ArrayList<PaintBrush> brushes;
int maxparticles = 40000;
float x = 33;
color line1 = color(243,229,182); 
//color line2 = color(148,0,211);
color line2 = color(255,241,94);

//----------------------------------------------------------------------------
void setup() {
  size(1024, 900, P3D);
  cam = new PeasyCam(this, 500);

  minim = new Minim(this);
  beat = new BeatDetect();
  beat.setSensitivity(400);

  //Audio from synth
  in2 = new AudioIn(this,0);
  //in2.start(); 
  //in2.play(); 
  in = minim.getLineIn(); 
  
  //For MP3 file in 
  //song = minim.loadFile("/Users/sisi/Desktop/LiveCoding/Debut/Uyan.mp3");
  //song.play();
  //song.loop(4);
  
  //initialize flowfield 
  flowfield = new FlowField(50);
  brushes = new ArrayList<PaintBrush>();
}

//----------------------------------------------------------------------------
void draw() {
  //set background color 
   background(0); //RBG values 
   beat.detect(in.mix); //Change to song for MP3 input  
   beat.detect(in.left); 
   beat.detect(in.right); 
   
   //Start CAM, Map to size
   cam.beginHUD();
   
   //crazyCircle();
   //Albers();
   //circleBoom();
   
   //starBoom();

   //Flow Field
  //  for (int i = 0; i < brushes.size (); i++) {
  //  PaintBrush v = brushes.get(i);
  //  v.follow(flowfield);
  //  v.run();
  //  if (v.isDead()) {
  //    brushes.remove(i);
  //  }
  //}
  //addBrushes();
 
  //play with things on your own 
  for (int i=0; i<width; i++){
    blendMode(ADD);
    stroke(0,30,230);
    strokeWeight(10);  //10
    line(i, height/2+in.mix.get(i)*300, i, height/2-in.mix.get(i)*300); 

   //circle
   
   //stroke(255,70,0); 
   //strokeWeight(1); 
   //ellipse(300,300, height/4+in.mix.get(i)*300, height/4+in.mix.get(i)*300);
   
  // stroke(255);
  // strokeWeight(1); 
  // if((i%10)==0){
  //   line(200, in.mix.get(i)*300+200, 400, in.mix.get(i)*300+200);
  //} else {
  //   line(250, in.mix.get(i)*300+200, 400, in.mix.get(i)*300+200);
  // }
 
  }
  
    //Flash to beat   
    if (beat.isOnset()) {
    background(254,219,0);
    //Image file 
    image(img,-height/4,-width/4, 300,300); 
    }
  
  cam.endHUD();
}

//------------------------------------------------------------------------------------------------------------------------------------------------
void crazyCircle() {
  background(0); // Initial background color, when we will open the serial window

  blendMode(NORMAL);
  perspective(PI/3.0, width/ height, 10.0, 1000000.0);

  cam.rotateY(0.04); 
  cam.rotateX(0.04);
  cam.setDistance (500 + abs(sin(frameCount*0.01))*500);

  cam.beginHUD();
  for (int i = 0; i < width; i++) {
    stroke(255, in.mix.get(i)*500);
    line(i, height/2 + in.mix.get(i)*400, i, height/2 - in.mix.get(i)*400);
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
      float r = 200 + in.mix.get(imnd%1024)*200;

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
    stroke(150, 50, 50, in.mix.get(i)*500);
    noFill();
    fill(in.mix.get(i)*500);

    for (int j = 0; j<total; j++) {
      vertex (pp[i][j].x, pp[i][j].y, pp[i][j].z);
      vertex (pp[i+1][j].x, pp[i+1][j].y, pp[i+1][j].z);
    }
    endShape();
  }

  if (beat.isOnset()) {
    cam.beginHUD();
    image(img, 0, 0, width/2, height/2);
    cam.endHUD();
  }
}

//----------------------------------------------------------------------------
void Albers() {
  background(0);
  strokeWeight(3);
  translate(width/2, height/2);

  cam.beginHUD();
  for (int i=0; i<width; i++) {
    stroke(line3);
    line(x1(t+i)*2, y1(t+i)*2, x2(t+i)*2, y2(t+i)*2);
    stroke(line4);
    line(x3(t+i)*2, y3(t+i)*2, x4(t+i)*2, y4(t+i)*2);
  }
  cam.endHUD();
  blendMode (ADD);
  //point(x1(t), y1(t));
  //point(x2(t), y2(t));
  t += in.mix.level();
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


//----------------------------------------------------------------------------
void circleBoom () {
  background(0);
  noFill();
  float amplitude = in.mix.level();
  float size = amplitude * 1000;

  cam.beginHUD();
  stroke(192, 255, 0);
  strokeWeight (10);
  ellipseMode(CENTER);
  ellipse(width/2, height/2, size, size);
  cam.endHUD();
}

//----------------------------------------------------------------------------
void starBoom() {

  cam.beginHUD();
  for (int i = 0; i < width; i++) {
    stroke(255, 50, 100, in.mix.get(i)*500); //hotpink 
    //stroke(200, 155, 0, song.mix.get(i)*500); //light green
    //line(i, height/2 + song.mix.get(i)*400, i, height/2 - song.mix.get(i)*400);
    //star(i, i, height/2 + song.mix.get(i)*400, height/2 - song.mix.get(i)*400, 8);
    star(width/2, height/2, height/4 + in.mix.get(i)*400, height/4 - in.mix.get(i)*400, 8);
  }
  cam.endHUD();
}

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

//--------------------------------------------------------------------------------------

//Testing starts here 
void addBrushes() {
  if (brushes.size() < maxparticles) {
    for (int k = 0; k < 50; k++) {
      brushes.add(new PaintBrush(new PVector(random(-200, width+200), random(-200, height+200)), random(2, 5), random(0.1, 0.5)));
    }
  }
}

//--------------------------------------------------------------------------------------
class PaintBrush {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  boolean dead;
  color col;

  PaintBrush(PVector l, float ms, float mf) {
    location = l.get();
    r = 5.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    float r = random(1);
    if (r < 0.2) {
      col = color(#0d1337);
    } else if (r >= 0.2 && r < 0.4) {
      col = color(#8cafd9);
    } else if (r >= 0.4 && r < 0.6) {
      col = color(#2e48b6);
    } else if (r >= 0.6 && r < 0.8) {
      col = color(#486dd5);
    } else {
      col = color(#c8e4f2);
    }
  }

  public void run() {
    update();
    borders();
    display();
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    stroke(col, 175);
    strokeWeight(5);
    point(location.x, location.y);
  }

  // Wraparound
  void borders() {
    if (location.x < 0-200 || location.x > width+200 || location.y < 0-200 || location.y > height+200) {
      dead = true;
    } else {
      dead = false;
    }
  }
  
  boolean isDead() {
    return dead;
  }
}

//--------------------------------------------------------------------------------------
class FlowField {
  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    init();
  }

  void init() {
    // Reseed noise so we get a new flow field every time
    noiseSeed((int)random(10000));
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        float theta = map(noise(xoff,yoff),0,1,0,TWO_PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = new PVector(cos(theta),sin(theta));
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution,0,cols-1));
    int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].get();
  }
}

// explanation of different components of code: 
// 1. blendMode(): https://processing.org/reference/blendMode_.html
// 2. star(): https://www.processing.org/examples/star.html
