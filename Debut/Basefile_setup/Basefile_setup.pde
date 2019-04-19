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

//----------------------------------------------------------------------------
//imported classes
Rain r1;


Minim minim;
AudioIn in2; 
AudioInput in;
BeatDetect beat;
AudioPlayer song;

PeasyCam cam;


// 
PGraphics pg;

// Flowfield object
FlowField flowfield;
// An ArrayList of brushes
ArrayList<PaintBrush> brushes;

int maxparticles = 40000;

//rain
//rain setup
int numDrops = 100;
Rain[] drops = new Rain[numDrops]; // Declare and create the array


//Albers
int spacing = 30; // space between lines in pixels
int border = spacing*2; // top, left, right, bottom border
int amplification = 3; // frequency amplification factor
float ySteps; // number of lines in y direction

static final int NUM_LINES = 50;
float t; 
String letters = "";
int back = 102; 

float x = 33;
float y = 60;

color line1 = color(243,229,182); 
//color line2 = color(148,0,211);
color line2 = color(255,241,94);


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
  

  song = minim.loadFile("/Users/sisi/Desktop/LiveCoding/Debut/Uyan.mp3");
  song.play();
  song.loop(4);
  
  flowfield = new FlowField(50);
  brushes = new ArrayList<PaintBrush>();
  
  //----------------------------------------------------------------------------
  //Loop through array to create each object
  for (int i = 0; i < drops.length; i++) {

    drops[i] = new Rain(); // Create each object
    r1 = new Rain();
  }
  //----------------------------------------------------------------------------
  
}

void draw() {
   background(0);
   beat.detect(song.mix); //change to in.mix
   
   cam.beginHUD();
 
  //----------------------------------------------------------------------------
    //Loop through array to use objects. RAIN
  //  for (int i = 0; i < drops.length; i++) {
  //  drops[i].fall();
  //}
    //----------------------------------------------------------------------------
    for (int i=0; i<width; i++){
    
   //spikes level 
   // blendMode(ADD);
   // stroke(0,30,230); 
   //strokeWeight(1); 
   //line(i, height/2+song.mix.get(i)*300, i, height/2-song.mix.get(i)*300); 
   
   //circle
   //stroke(0,0,255); 
   //strokeWeight(1); 
   //ellipse(300,300, height/4+song.mix.get(i)*300, height/4+song.mix.get(i)*300);
   
  // stroke(255);
  // strokeWeight(1); 
  // if((i%10)==0){
  //   line(200, song.mix.get(i)*300+200, 400, song.mix.get(i)*300+200);
  //} else {
  //   line(250, song.mix.get(i)*300+200, 400, song.mix.get(i)*300+200);
  // }
   }
  //----------------------------------------------------------------------------------
     
   //calm flow
  //  for (int i = 0; i < brushes.size (); i++) {
  //  PaintBrush v = brushes.get(i);
  //  v.follow(flowfield);
  //  v.run();
  //  if (v.isDead()) {
  //    brushes.remove(i);
  //  }
  //}
  //addBrushes();
  
  //----------------------------------------------------------------------------------
  //Parametric Curves 
   float freqMix = song.mix.get(int(x));
   float freqLeft = song.left.get(int(x));
   float freqRight = song.right.get(int(x));
   float amplitude = song.mix.level();
   float size = freqMix * spacing * amplification;
   float red = map(freqLeft, -1, 1, 0, 200);
   float green = map(freqRight, -1, 1, 0, 50);
   float blue = map(freqMix, -1, 1, 0, 55);
   float opacity = map(amplitude, 0, 0.4, 20, 100);
   
  translate(width/2, height/2);
  for (int i=0; i<NUM_LINES; i++){
   stroke(line1);
   strokeWeight(amplitude*10);
   line(x1(t+i), y1(t+i), x2(t+i), y2(t+i));
   stroke(line2);
   strokeWeight(amplitude*10);
   line(x3(freqLeft+i), y3(freqLeft+i), x4(freqRight+i), y4(freqRight+i));
  }
  //point(x1(t), y1(t));
  //point(x2(t), y2(t));
  t += 0.5; 
  noStroke();
  fill(red, green,blue, opacity);
  rect(x+border, y*ySteps+border, size, size);
 
  cam.endHUD();
  
   //type
  float cursorPosition = textWidth(letters);
  line(cursorPosition, 0, cursorPosition, 100);
  text(letters, 0, 0);
  fill(255,255, 255);
  if ((mouseX >= x) && (mouseX <= x+55) &&
    (mouseY >= y-24) && (mouseY <= y)) {
    x += random(-2, 2);
    y += random(-2, 2);
  }
  text(letters, x, y);
}


//Testing starts here 

//----------------------------------------------------------------------------------------------
float x1(float t) {
   //return +sin(t/10)*100 + sin(t/ 5)*20;
   return sin(t/10)*100 + sin(t/ 5)*20;
}

float y1(float t) {
   //return -cos(t/10)*100; 
   return cos(t/20)*100;
}

float x2(float t) {
   //return sin(t/10)*200 + sin(t)*2;
   return sin(-t/10)*200 + sin(t)*5;
}

float y2(float t) {
   //return cos(t/20)*200 + cos(t/12)*20;  
   return cos(-t/20)*200 + cos(t/12)*10;  
}

float x3(float t) {
   return sin(t/10)*100 + sin(t/ 5)*20;
}

float y3(float t) {
   return cos(t/10)*100;  
}

float x4(float t) {
   return sin(t)*200;
}

float y4(float t) {
   return cos(t)*200;  
}
//----------------------------------------------------------------------------------------
void addBrushes() {
  if (brushes.size() < maxparticles) {
    for (int k = 0; k < 50; k++) {
      brushes.add(new PaintBrush(new PVector(random(-200, width+200), random(-200, height+200)), random(2, 5), random(0.1, 0.5)));
    }
  }
}
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
//----------------------------------------------------------------------------
//class rain
class Rain {
  float r = random(width);
  float y = random(-height);

  void fall() {
    y = y + 7;
    // yellow
    //fill(255,255,0);
     //red
    fill(255,0,0);
    
    //shape of ellipse
    ellipse(r, y, 2, 10);

   if(y>height){
   r = random(width);
   y = random(-200);
   }

  }
}
