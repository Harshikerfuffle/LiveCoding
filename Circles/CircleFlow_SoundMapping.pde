// made with love using Processing
// Description: music mapped over time in the form of circles, mapped on the amplitude of music
// code credits and reference: http://responsivedesign.de/wp-content/uploads/2016/05/tutorial-06_processing-soundmapping2.pdf
// tutorial by Mark Kretzer, Digital Crafting

// song = minim.loadFile("bensound-clearday.mp3", 2048);feel free to change the music file, dragging 
// and dropping into the processing environment creates a data file in the folder where the code is 
// saved and that is where it is referenced from. 
// song credits: https://www.bensound.com/royalty-free-music/track/clear-day
//----------------------------------------------------------------------------

import ddf.minim.*;
Minim minim;
AudioPlayer song;

int spacing  = 10; // space between lines in pixels 
int border = spacing * 2; //top' left, right, bottom, border
int amplification = 3; //frequency amplification factor 

int y = spacing;
float ySteps; //number of lines in y direction
//----------------------------------------------------------------------------

void setup() {
  size(400, 400);
  background (255);
  noStroke();

  minim = new Minim (this);
  song = minim.loadFile ("bensound-clearday.mp3");
  //song.play(); //plays the song once and stops
}
//----------------------------------------------------------------------------

void mousePressed() {
  song.rewind(); //regardless of whether song has been played previosuly or not
  song.play(); // tells the song to start from beginning. 
  background (255);
}
//----------------------------------------------------------------------------

void draw() {
  int screenSize = int((width-2*border)*(height-1.5*border)/spacing);
  int x = int(map(song.position(), 0, song.length(), 0, screenSize));
  ySteps = x/(width-2*border);         // calculate amount of lines
  x -= (width-2*border)*ySteps;        // set new x position for each line

  //float frequency = song.mix.get(int(x))*spacing*amplification; 

  float freqMix = song.mix.get(int(x));
  float freqLeft = song.left.get(int(x));
  float freqRight = song.right.get(int(x));

  float amplitude = song.mix.level();
  float size = freqMix * spacing * amplification;

  float red = map(freqLeft, -1, 1, 0, 200); // map(value, low1, high1, low2, high2)
  float green = map(freqRight, -1, 1, 0, 215);
  float blue =  map(freqMix, -1, 1, 0, 55);
  float opacity = map(amplitude, 0, 0.4, 20, 100);

  noStroke();
  fill(red, green, blue, opacity);
  ellipse(x+border, y*ySteps+border, size, size);
  //saveFrame();
}
//----------------------------------------------------------------------------

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
//----------------------------------------------------------------------------

// I am still a NOOB
// special thanks: Aditya Agarwal, Carnegie Mellon University
// made for class: Prototyping for Interaction Design taught by Andrew Twigg at Carnegie Mellon University
