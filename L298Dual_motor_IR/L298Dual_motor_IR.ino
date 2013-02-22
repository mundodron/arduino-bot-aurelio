// L298 motor control
// Arduino Robotics

#include <IRremote.h>
#include <Servo.h>


// L298 motor control variables
int M1_A = 2;
int M1_B = 3;
int M2_A = 4;
int M2_B = 7;
int M1_PWM = 5;
int M2_PWM = 6;

// LED pin attached to Arduino D13
int LED = 13;

// variable to store speed value
int speed_val = 155;
int incomingByte;

Servo myservo;  // create servo object to control a servo 
int potpin = 0;  // analog pin used to connect the potentiometer
int val;    // variable to read the value from the analog pin 

int RECV_PIN = 11;
IRrecv irrecv(RECV_PIN);
decode_results results;
 

void setup(){

// Start serial monitor at 115,200 bps
Serial.begin(9600);
myservo.attach(10);  // attaches the servo on pin 9 to the servo object 
irrecv.enableIRIn(); // Start the receiver

// declare outputs
pinMode(LED, OUTPUT);

pinMode(M1_A, OUTPUT);
pinMode(M1_PWM, OUTPUT);
pinMode(M1_B, OUTPUT);
pinMode(M2_A, OUTPUT);
pinMode(M2_PWM, OUTPUT);
pinMode(M2_B, OUTPUT);

// turn motors Off by default
MOTOR_stop();
delay(500);
}

void loop(){
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
			MOTOR_forward(speed_val);
			delay(25);
		}
		// if byte is equal to "106" or "j", go left
		else if (incomingByte == 106){
			MOTOR_turnleft(speed_val);
			delay(25);
		}
		// if byte is equal to "108" or "l", go right
		else if (incomingByte == 108){
			MOTOR_turnright(speed_val);
			delay(25);
		}
		// if byte is equal to "107" or "k", go reverse
		else if (incomingByte == 107){
			MOTOR_reverse(speed_val);
			delay(25);
		}
		else {
			MOTOR_stop();
			digitalWrite(LED, LOW);
		}
	} //end IF Serial.available() > 0)

 //infrared
   if (irrecv.decode(&results)) {
    Serial.println(results.value, HEX);
    if (results.value == B54A02FD){
    MOTOR_forward(speed_val);
    }
    else if (results.value == B54A42BD){
     MOTOR_turnleft(speed_val);
    }
    else if (results.value == B54AC23D){
     MOTOR_turnright(speed_val);
    }
    else if (results.value == B54A827D){
     MOTOR_reverse(speed_val);
    }
    else {
      MOTOR_stop();
      digitalWrite(LED, LOW);
    }
    delay(25);
    irrecv.resume(); // Receive the next value

  } // end infrared

  val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023) 
  val = map(val, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  myservo.write(val);                  // sets the servo position according to the scaled value 
  delay(15);       

} //end Loop

  //Speed Control	
	void test_speed(){
		// constrain speed value to between 0-255
		if (speed_val > 250){
			speed_val = 255;
			Serial.println(" MAX ");
		}
		if (speed_val < 0){
			speed_val = 0;
			Serial.println(" MIN ");
		} 
	 } //end test_speed

void MOTOR_forward(int x){
	digitalWrite(M1_B, HIGH);
	digitalWrite(M1_A, LOW);
	analogWrite(M1_PWM, x);
	digitalWrite(M2_B, HIGH);
	digitalWrite(M2_A, LOW);
	analogWrite(M2_PWM, x);
}

void MOTOR_turnright(int x){
  	digitalWrite(M1_B, HIGH);
	digitalWrite(M1_A, LOW);
	analogWrite(M1_PWM, x);
	digitalWrite(M2_B, LOW);
	digitalWrite(M2_A, HIGH);
	analogWrite(M2_PWM, x);
}

void MOTOR_turnleft(int x){
    	digitalWrite(M1_B, LOW);
	digitalWrite(M1_A, HIGH);
	analogWrite(M1_PWM, x);
	digitalWrite(M2_B, HIGH);
	digitalWrite(M2_A, LOW);
	analogWrite(M2_PWM, x);
}

void MOTOR_reverse(int x){
	digitalWrite(M1_B, LOW);
	digitalWrite(M1_A, HIGH);
	analogWrite(M1_PWM, x);
	digitalWrite(M2_B, LOW);
	digitalWrite(M2_A, HIGH);
	analogWrite(M2_PWM, x);
}

void MOTOR_stop(){
	digitalWrite(M1_B, LOW);
	digitalWrite(M1_A, LOW);
	digitalWrite(M1_PWM, LOW);
	digitalWrite(M2_B, LOW);
	digitalWrite(M2_A, LOW);
	digitalWrite(M2_PWM, LOW);
}
