//For ARDUINO

int ledPin = 7;
int potPin = A0;
int photoPin = A1;
int potOutput;
int photoReading;

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  potOutput = analogRead(potPin);
  photoReading = analogRead (photoPin);
//  Serial.println(photoReading);
  
  int mappedOutput = map(potOutput, 0, 1023, 0, 255); //map the output
//  int mappedOutputB = map(photoReading, 0, 1023, 0, 255);

  Serial.println(mappedOutput);
//  Serial.println(mappedOutputB);
  
//  Serial.write(mappedOutput);

  if (Serial.available ( ) > 0) { // Checking if the Processing IDE has send a value or not
    char state = Serial.read ( ); // Reading the data received and saving in the state variable
    
    if (state == '1') { // If received data is '1', then turn on LED
      digitalWrite (ledPin, HIGH);
    }

    if (state == '0') { // If received data is '0', then turn off led
      digitalWrite (ledPin, LOW);
    }
  }

  delay(50);
}
