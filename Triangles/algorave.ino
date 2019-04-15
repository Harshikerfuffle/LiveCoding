//FOR ARDUINO CONSOLE 
//code has been referenced from multiple locations
// tutorial on arduino and processing communication: https://maker.pro/arduino/tutorial/how-to-make-arduino-and-processing-ide-communicate
// harshikajain  x  sisiyu

int ledPin = 7;
int potPin = A0; //initialise potentiometer
int photoPin = A1; //initialise photosensor
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
  
//  only one mappedOutput should be used at a time otherwise the processing console gets confused since it 
//   receives different values from 2 sensors at the same time
  
//   int mappedOutput = map(potOutput, 0, 1023, 0, 255); //map the potentiometer output
  int mappedOutputB = map(photoReading, 0, 1023, 0, 255); //map photosensor output

//  Serial.println(mappedOutput);
  Serial.println(mappedOutputB);
  
  
//  Serial.write(mappedOutput); //for sending signals to processing to pick 

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
