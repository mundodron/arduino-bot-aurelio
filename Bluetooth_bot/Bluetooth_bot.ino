// Bluetooth-bot v1
// Arduino Robotics unofficial chapter 14
// use Bluetooth Mate serial adapter to receive commands from PC
// Arduino decodes commands into motor movements
// Creates high-speed wireless serial link for robot control using keyboard
// Uses keys "i" = forward, "j" = left, "k" = reverse, and "l" = right and "a" = Auto
// speed control is also implemented using "," = speed down, "." = speed up, and "/" = max speed.

#include <Servo.h> 
Servo myservo;  // create servo object to control a servo 
int potpin = 0;  // analog pin used to connect the potentiometer
int val;    // variable to read the value from the analog pin 

//Constants
// L298 motor control variables
int M1_A = 3;
int M1_PWM = 7;
int M1_B = 4;

int M2_A = 5;
int M2_PWM = 6;
int M2_B = 2;

//Ping
int pingPin = 9;
int inPin = 8;

// LED pin attached to Arduino D13
int LED = 13;

// Botao
int botao = 11;

//Servo
int servo = 10;

//Speaker
int speaker = 12;

// variable to store serial data
int incomingByte = 0;

// variable to store speed value
int speed_val = 105;


//////////////////////////////


void setup(){
 
myservo.attach(servo);  // attaches the servo on pin 9 to the servo object   
TCCR2B = TCCR2B & 0b11111000 | 0x01; // change PWM frequency for pins 3 and 11 to 32kHz so there will be no motor whining

// Start serial monitor
Serial.begin(9600);

// declare outputs
pinMode(LED, OUTPUT);

pinMode(M1_A, OUTPUT);
pinMode(M1_PWM, OUTPUT);
pinMode(M1_B, OUTPUT);

pinMode(M2_A, OUTPUT);
pinMode(M2_PWM, OUTPUT);
pinMode(M2_B, OUTPUT);

pinMode(servo, OUTPUT); // declare servo pin as OUTPUT
// turn motors Off by default
M1_stop();
M2_stop();

// declare imputs
pinMode(botao, INPUT); // declare pushbutton como input

 // Tada
 // tone(speaker, frequency, duration)
  tone(speaker, 300, 300);
  delay(100);
  tone(speaker, 500, 400);
  delay(80);
  tone(speaker, 300, 300);

}

////////////////////////////////////

void loop(){
  
  val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023) 
  val = map(val, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  myservo.write(val);                  // sets the servo position according to the scaled value 
  
  // Ping
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration, inches, cm;
  int state;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(inPin, INPUT);
  duration = pulseIn(inPin, HIGH);

  // convert the time into a distance
  cm = microsecondsToCentimeters(duration);
  //Serial.println(cm);
   
  //delay(100);
  //END Ping

// check for serial data
if (Serial.available() > 0) {
// read the incoming byte:
incomingByte = Serial.read();
// if available, blink LED and print serial data received.
digitalWrite(LED, HIGH);
// say what you got:
Serial.print("I received: ");
Serial.println(incomingByte);
// delay 10 milliseconds to allow serial update time
delay(10);

// check incoming byte for direction
// if byte is equal to "46" or "," - raise speed
if (incomingByte == 46){
     speed_val = speed_val + 5;
     test_speed();
     Serial.println(speed_val);
}
// if byte is equal to "44" or "." - lower speed
else if (incomingByte == 44){
   speed_val = speed_val - 5;
   test_speed();
   Serial.println(speed_val);
}
// if byte is equal to "47" or "/" - max speed
else if (incomingByte == 47){
   speed_val = 255;
   test_speed();
}

// if byte is equal to "105" or "i", go forward
else if (incomingByte == 105){
   M1_forward(speed_val);
   M2_forward(speed_val);
   delay(25);
}
// if byte is equal to "106" or "j", go left
else if (incomingByte == 106){
   M2_reverse(speed_val);
   M1_forward(speed_val);
   delay(25);
}
// if byte is equal to "108" or "l", go right
else if (incomingByte == 108){
   M2_forward(speed_val);
   M1_reverse(speed_val);
   delay(25);
}
// if byte is equal to "107" or "k", go reverse
else if (incomingByte == 107){
   M1_reverse(speed_val);
   M2_reverse(speed_val);
   delay(25);
}
else {
   M1_stop();
   M2_stop();
   digitalWrite(LED, LOW);
}
} //End if

delay(25);

// Le o estado do botao
//if (digitalRead(botao) == HIGH) {
  
// if byte is equal to "97" or "a"
  if (incomingByte == 97){
    state = 1;
    digitalWrite(LED, HIGH);
    tone(speaker, 100, 300);}
  else if (incomingByte == 98){
    state = 0;
    digitalWrite(LED, LOW);
	tone(speaker, 500, 300);
  }
delay(25);
// Ultra Som
if (state == 1) {
	if (cm < 20 and cm > 10){
    tone(speaker, (cm*50), 2);
	M2_forward(speed_val);
	M1_forward(speed_val);
	Serial.println(" Avante ");
	delay(25);
	}
	
	else if (cm <= 10 and cm > 7){
	tone(speaker, (cm*10), 2);
	M2_forward(speed_val);
	M1_reverse(speed_val);
    Serial.println(" Vira Direita ");
	delay(25);
	}
	
    else if (cm <= 7 and cm > 5){
	tone(speaker, (cm*10), 2);
	M1_forward(speed_val);
	M2_reverse(speed_val);
    Serial.println(" Vira Esquerda ");
	delay(25);
	}
	
	else if (cm < 5){
	tone(speaker, (cm*10), 2);
	M2_reverse(speed_val);
	M1_reverse(speed_val);
	Serial.println(" Volta ");
	delay(25);
	}
	// otherwise, stop both motors
	else {
    tone(speaker, (cm*50), 2);
	M1_stop();
	M2_stop();
	Serial.println(" Para ");
	} //End if cm
Serial.println(incomingByte);

} //End if rum
else{
    M1_stop();
	M2_stop();
	Serial.println(" Para Tudo ");
  }
} //End Loop

void test_speed(){
// constrain speed value to between 0-255
if (speed_val > 250){
    speed_val = 255;
    tone(speaker, 800, 100);
    Serial.println(" MAX ");
}
if (speed_val < 0){
    speed_val = 0;
    tone(speaker, 800, 100);
    Serial.println(" MIN ");
}

} //End test_speed

/////////// motor functions ////////////////

void M1_reverse(int x){
digitalWrite(M1_B, LOW);
digitalWrite(M1_A, HIGH);
analogWrite(M1_PWM, x);
}

void M1_forward(int x){
digitalWrite(M1_A, LOW);
digitalWrite(M1_B, HIGH);
analogWrite(M1_PWM, x);
}

void M1_stop(){
digitalWrite(M1_B, LOW);
digitalWrite(M1_A, LOW);
digitalWrite(M1_PWM, LOW);
}

void M2_forward(int y){
digitalWrite(M2_B, LOW);
digitalWrite(M2_A, HIGH);
analogWrite(M2_PWM, y);
}

void M2_reverse(int y){
digitalWrite(M2_A, LOW);
digitalWrite(M2_B, HIGH);
analogWrite(M2_PWM, y);
}

void M2_stop(){
digitalWrite(M2_B, LOW);
digitalWrite(M2_A, LOW);
digitalWrite(M2_PWM, LOW);
}
///////////////////// END MOTOR /////////////////

// Ping function
long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
