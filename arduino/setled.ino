// set led according to serial input

// Pins. Must be PWM pins.
#define REDLED  9
#define GREENLED  10
#define BLUELED  11

// Can't be higher than 255
#define MAXBRIGHT  200

void setup(){
   // Initialization wiring check
  // You should see RED, BLUE, then GREEN.
  // If you don't, then you ballsed something up.
  analogWrite(REDLED, MAXBRIGHT);
  delay(1000);
  analogWrite(REDLED, 0);
  analogWrite(BLUELED, MAXBRIGHT);
  delay(1000);
  analogWrite(BLUELED, 0);
  analogWrite(GREENLED, MAXBRIGHT);
  delay(1000);
  analogWrite(GREENLED, 0);
  
  Serial.begin(9600);
  Serial.println("Started...");
  
}

void loop(){
 
  if (Serial.available()){
   
    char ch = Serial.read();
    Serial.print("Read ");
    switch(ch){
    case 'r':
      color(255, 0, 0);  
      Serial.println(ch);
      break;
    case 'g':
      color(0,255, 0);    
      Serial.println(ch);
      break; 
    case 'o':
      color(237,120,6);  
      Serial.println(ch);
      break;   
    }
  }  
}

void color (unsigned char red, unsigned char green, unsigned char blue){
  analogWrite(REDLED, red);
  analogWrite(BLUELED, blue);
  analogWrite(GREENLED, green);
}
