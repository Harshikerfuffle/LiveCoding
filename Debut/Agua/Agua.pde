Rain r1;

import processing.sound.*;
import processing.serial.*;
import peasy.*;
import vsync.*;
import ddf.minim.*;
Minim minim;

AudioMetaData meta; //meta data

AudioPlayer song;
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

//rain setup
int numDrops = 100;
Rain[] drops = new Rain[numDrops]; // Declare and create the array


void setup(){
  size(800,800);
  
  //text
  stroke(255,0,0);
  fill(255);
  textSize(24);
  noFill(); 
  minim = new Minim(this);
  song = minim.loadFile("/Users/sisi/Desktop/LiveCoding/Debut/Agua.mp3");
  song.play();
 
  //Loop through array to create each object
  for (int i = 0; i < drops.length; i++) {

    drops[i] = new Rain(); // Create each object
    r1 = new Rain();
  }
  
}

void draw() {
  background(0);
  fill(255);
  //stroke(255);
  
  
  //Loop through array to use objects. RAIN
  for (int i = 0; i < drops.length; i++) {
    drops[i].fall();
  }
  
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
}

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

void keyPressed() {
  if (key == BACKSPACE) {
    if (letters.length() > 0) {
      letters = letters.substring(0, letters.length()-1);
    }
  } else if (textWidth(letters+key) < width) {
    letters = letters + key;
  }
}

//class rain
class Rain {
  float r = random(width);
  float y = random(-height);

  void fall() {
    y = y + 7;
    // yellow
    fill(255,255,0);
     //red
    //fill(255,0,0);
    
    //shape of ellipse
    ellipse(r, y, 2, 10);

   if(y>height){
   r = random(width);
   y = random(-200);
   }

  }
}
