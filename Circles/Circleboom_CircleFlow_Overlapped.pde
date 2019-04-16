// made with love using Processing
// Description: circle oscillating and changing size
// mapped on the amplitude of music, point in time and over time overlapped on each other
// code credits and reference: http://responsivedesign.de/wp-content/uploads/2016/05/tutorial-06_processing-soundmapping2.pdf
// tutorial by Mark Kretzer, Digital Crafting

// song = minim.loadFile("bensound-clearday.mp3", 2048);feel free to change the music file, dragging 
// and dropping into the processing environment creates a data file in the folder where the code is 
// saved and that is where it is referenced from. 
// song credits: https://www.bensound.com/royalty-free-music/track/clear-day
// harshikajain
//----------------------------------------------------------------------------

import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioPlayer song;

int spacing  = 10; // space between lines in pixels 
int border = spacing * 2; //top' left, right, bottom, border
int amplification = 3; //frequency amplification factor 
int y = spacing;

float ySteps; //number of lines in y direction
float eRadius;

//----------------------------------------------------------------------------
void setup() {
  size(400, 400, P3D);
  minim = new Minim(this);
  song = minim.loadFile("bensound-clearday.mp3", 2048);
  background (255);

  ellipseMode(RADIUS);
  eRadius = 20;
}

//----------------------------------------------------------------------------
void mousePressed() {
  song.rewind(); //regardless of whether song has been played previosuly or not
  song.play(); // tells the song to start from beginning.
  redraw();
}

//----------------------------------------------------------------------------
void draw() {
  int screenSize = int((width-2*border)*(height-1.5*border)/spacing);
  int x = int(map(song.position(), 0, song.length(), 0, screenSize));

  ySteps = x/(width-2*border);         // calculate amount of lines
  x -= (width-2*border)*ySteps;        // set new x position for each line

  float freqMix = song.mix.get(int(x));
  float freqLeft = song.left.get(int(x));
  float freqRight = song.right.get(int(x));
  float amplitude = song.mix.level();

  float red = map(freqLeft, -1, 1, 0, 150); // map(value, low1, high1, low2, high2)
  float green = map(freqRight, -1, 1, 0, 255);
  float blue =  map(freqMix, -1, 1, 0, 50);
  float opacity = map(amplitude, 0, 0.4, 20, 100);

  noStroke();
  fill(red, green, blue, opacity);

  circleboom();
  
  float size2 = freqMix * spacing * amplification;
  ellipse(x+border, y*ySteps+border, size2, size2);

  println(song.position());
  println(song.length());
}

//----------------------------------------------------------------------------
void circleboom() {  
  float amplitude = song.mix.level();
  float size1 = amplitude * 300;
  ellipse(width/2, height/2, size1, size1);
}

//----------------------------------------------------------------------------
void stop() {
  song.close();
  minim.stop();
  super.stop();
}

//----------------------------------------------------------------------------
// special thanks: Aditya Agarwal, Carnegie Mellon University
// made for class: Prototyping for Interaction Design taught by Andrew Twigg at Carnegie Mellon University
