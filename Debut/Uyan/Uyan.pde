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


// 
PGraphics pg;

// Flowfield object
FlowField flowfield;
// An ArrayList of brushes
ArrayList<PaintBrush> brushes;

int maxparticles = 40000;


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
  
}

void draw() {
   background(0);
   beat.detect(song.mix); //change to in.mix
   
   cam.beginHUD();
   
   //calm flow
    for (int i = 0; i < brushes.size (); i++) {
    PaintBrush v = brushes.get(i);
    v.follow(flowfield);
    v.run();
    if (v.isDead()) {
      brushes.remove(i);
    }
  }
  addBrushes();
 

  for (int i=0; i<width; i++){
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
  
  cam.endHUD();
}

//Testing starts here 
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
