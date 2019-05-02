class Estrellita { // def clase
  PVector pos;
  color   scolor;
  float   diametro;
PVector   vel;

  Estrellita() { // constructor
    pos      = new PVector(random(width), random(height));
    diametro = random(0, 400);
    scolor   = color(map(diametro, 2, 20, 0, 128), 255, 255);
    vel    = new PVector( diametro/100, 0);   //ew PVector( -diametro/2, 0);pa cambiar direccion.
  }

  void update() {
    pos.add(vel);
    pos.x+=width;
    pos.x%=width;
  }
  void draw() {
    stroke(255, 255, 0, 70);
    strokeWeight (5);
    fill(scolor);
    line(pos.x, diametro, diametro, diametro);
   
  }
}
