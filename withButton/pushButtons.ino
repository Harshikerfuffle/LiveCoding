// FOR ARDUINO
// sisixiyu x harshikajain

int button1 = 6;
int button2 = 5;
int button3 = 4;
int button4 = 3;
int ledPin = 2;
int potPin = A1;
// int potOutput;

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(button1, INPUT_PULLUP);
  pinMode(button2, INPUT_PULLUP);
  pinMode(button3, INPUT_PULLUP);
  pinMode(button4, INPUT_PULLUP);
  
  Serial.begin(9600);
}

void loop() {
  int bReading1 = digitalRead(button1);
  int bReading2 = digitalRead(button2);
  int bReading3 = digitalRead(button3);
  int bReading4 = digitalRead(button4);
//   potOutput = analogRead(potPin);
  
//  int mappedOutput = map(potOutput, 0, 1023, 0, 255); //map the output
  
  // the purpose here is to send discrete values out to processing to pick 
  // it up and then execute accordingly

  if (bReading1 == LOW){
    Serial.write (1);
  }

   if (bReading2 == LOW){
    Serial.write (2);
  }

   if (bReading3 == LOW){
    Serial.write (3);
  }

   if (bReading4 == LOW){
    Serial.write (4);
  }
  

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
