
//Flavia Carrara - Esame Interaction Design - 16/01/2017
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

//WAVE
int num1 = 20;                //variabile per il numero delle linne
int opacity = 200;            //costante opacità
float distanza;               //distanza fra le linee dell'onda
float arcClosed;              //chiusura dell'onda
float velocitaOnda;           //velocità del movimento Onda
float movLinee;               //movimento linee tutte insieme
float dim;                    //dimensione archi onda


//SUN
int num = 500;                //numero linee che compongono il sole            
float raggio = 120;           //raggio linee
float dist = 100;             //distanza linee dal punto di origine
float angle1;
float angle2;
int fCount;                   //contatore di frame 


void setup()
{
  
  size(1200, 500);            //definisco un canvas
  
  
  //WAVE
  strokeWeight(50);           //spessore linee onda
  distanza = 25;              //distanza delle linee dell'onda
  background(17, 49, 100);    //definisco un colore 
  
  fCount = 3;                 //il frame parte da 3
}


void draw()
{ 
  noStroke();                         //creo un rettangolo 
  fill(17, 49, 100);
  rect(0, 0, width/2, height); 
  translate(300, 350);                //posizionamento onda
  
  //WAVE 1
  
  for (int i = 0; i<num1; i++)        //ciclo for per creare il movimento dell'onda
  {
    stroke(153, 170, 197);            //linea che compone l'onda
    noFill();                         //nessun riempimento
    smooth();                         //anti-alias
    dim = i*distanza;                 //grandezza dell'arco
    float movLinee = PI/num1*i;       //muove le linee diversamente
    float arcClosed = map(sin(velocitaOnda+movLinee), -1, 1, PI, TWO_PI);    //definisco che l'arco non si chiuda completamente, ma solo a 180
    arc(0, 0, dim, dim, PI, arcClosed);  //posiziono l'onda
    
  }
  
  //WAVE 2
  
  for (int i = 0; i<num1; i++)
  {
    stroke(89, 138, 167, opacity);
    noFill();
    smooth();
    dim = i*distanza;
    float movLinee = PI/num1*i;
    float arcClosed = map(sin(velocitaOnda+movLinee), -2, 2, PI, TWO_PI);
    arc(0, 0, dim, dim, PI, arcClosed);
    
  }
  
  //WAVE 3
  
  for (int i = 0; i<num1; i++)
  {
    stroke(94, 138, 207, opacity);
    noFill();
    smooth();
    dim = i*distanza;
    float movLinee = PI/num1*i;
    float arcClosed = map(sin(velocitaOnda+movLinee), -3, 10, PI, TWO_PI);
    arc(0, 0, dim, dim, PI, arcClosed);
    
  }
  velocitaOnda += 0.0250;          //velocità del movimento
  

  //SUN 
  if(fCount >= 3)
  {
    fCount = 0;
  
  translate(580, -100);                     //posiziono il sole
  
  int i = 0;                                //iniziliazzo una variabile 
  
  stroke(random(200, 255), 180, 0);         //definisco una colore random tra i gialli
  strokeWeight(random(1, 4));               //definisco uno spessore random
  
  smooth();                                 //anti-alias
 
  float angle1  = random(0, TWO_PI);        //assegno una posizione random alle linee che si generano
  float x1 = sin(angle1) * raggio;
  float y1 = cos(angle1) * raggio;
  float angle2 = random(0, TWO_PI);
  float x2 = sin(angle2) * raggio;
  float y2 = cos(angle2) * raggio;
  
  

  bezier(x1, y1, x1+random(-dist, dist), y1+random(-dist, dist), x2+random(-dist, dist), y2+random(-dist, dist), x2, y2);      //genero curve
  }
  
  fCount++;
}
