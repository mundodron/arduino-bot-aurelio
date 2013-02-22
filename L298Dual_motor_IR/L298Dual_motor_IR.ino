/*
 * IRremote: IRrecvDemo - demonstrates receiving IR codes with IRrecv
 * An IR detector/demodulator must be connected to the input RECV_PIN.
 * Version 0.1 July, 2009
 * Copyright 2009 Ken Shirriff
 * http://arcfn.com
 */

#include <IRremote.h>

// L298 motor control variables
int M1_A = 2;
int M1_B = 3;
int M2_A = 4;
int M2_B = 7;
int M1_PWM = 5;
int M2_PWM = 6;

int RECV_PIN = 11;
// LED pin attached to Arduino D13
int LED = 13;
int speed_val = 155;

IRrecv irrecv(RECV_PIN);
decode_results results;

void setup()
{
  Serial.begin(9600);
  irrecv.enableIRIn(); // Start the receiver
  pinMode(M1_A, OUTPUT);
  pinMode(M1_PWM, OUTPUT);
  pinMode(M1_B, OUTPUT);
  pinMode(M2_A, OUTPUT);
  pinMode(M2_PWM, OUTPUT);
  pinMode(M2_B, OUTPUT);
  
  pinMode(LED, OUTPUT);
}

void loop() {
  if (irrecv.decode(&results)) {
    Serial.println(results.value);
    if (results.value == 3041526525){
         digitalWrite(LED, HIGH);
         MOTOR_forward(speed_val);
         delay (25);
    }
     else if (results.value == 3041575485){
         digitalWrite(LED, LOW);
         MOTOR_turnright(speed_val);
         delay (25);
     }
     else if (results.value == 3041542845){
         digitalWrite(LED, LOW);
         MOTOR_turnleft(speed_val);
         delay (25);
     }
     else if (results.value == 3041559165){
         digitalWrite(LED, LOW);
         MOTOR_reverse(speed_val);
         delay (25);
     }
     else if (results.value == 3041546415){
         digitalWrite(LED, LOW);
	 speed_val = speed_val + 5;
         Serial.println(speed_val);
	 test_speed();
         delay (25);
     }
     else if (results.value == 3041579055){
         digitalWrite(LED, LOW);
	 speed_val = speed_val - 5;
         Serial.println(speed_val);
	 test_speed();
         delay (25);
     }
     else {
        MOTOR_stop();
        digitalWrite(LED, LOW);
          }
    irrecv.resume(); // Receive the next value
  }
}

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
