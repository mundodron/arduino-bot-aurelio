/*
 * IRremote: IRrecvDemo - demonstrates receiving IR codes with IRrecv
 * An IR detector/demodulator must be connected to the input RECV_PIN.
 * Version 0.1 July, 2009
 * Copyright 2009 Ken Shirriff
 * http://arcfn.com
 */

#include <IRremote.h>

int motor[] = {2, 3, 4, 7, 5, 6};
// indice: Motor L -, Motor L +, Motor R -, Motor R +, Velocidade motor Direito, Velocidade motor Esquerdo

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
  pinMode(motor[0], OUTPUT);
  pinMode(motor[4], OUTPUT);
  pinMode(motor[1], OUTPUT);
  pinMode(motor[2], OUTPUT);
  pinMode(motor[5], OUTPUT);
  pinMode(motor[3], OUTPUT);
  
  pinMode(LED, OUTPUT);
}

void loop() {
infrared();
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
	digitalWrite(motor[1], HIGH);
	digitalWrite(motor[0], LOW);
	analogWrite(motor[4], x);
	digitalWrite(motor[3], HIGH);
	digitalWrite(motor[2], LOW);
	analogWrite(motor[5], x);
}

void MOTOR_turnright(int x){
  	digitalWrite(motor[1], HIGH);
	digitalWrite(motor[0], LOW);
	analogWrite(motor[4], x);
	digitalWrite(motor[3], LOW);
	digitalWrite(motor[2], HIGH);
	analogWrite(motor[5], x);
}

void MOTOR_turnleft(int x){
    	digitalWrite(motor[1], LOW);
	digitalWrite(motor[0], HIGH);
	analogWrite(motor[4], x);
	digitalWrite(motor[3], HIGH);
	digitalWrite(motor[2], LOW);
	analogWrite(motor[5], x);
}

void MOTOR_reverse(int x){
	digitalWrite(motor[1], LOW);
	digitalWrite(motor[0], HIGH);
	analogWrite(motor[4], x);
	digitalWrite(motor[3], LOW);
	digitalWrite(motor[2], HIGH);
	analogWrite(motor[5], x);
}

void MOTOR_stop(){
	digitalWrite(motor[1], LOW);
	digitalWrite(motor[0], LOW);
	digitalWrite(motor[4], LOW);
	digitalWrite(motor[3], LOW);
	digitalWrite(motor[2], LOW);
	digitalWrite(motor[5], LOW);
}

void infrared()
{
  if (irrecv.decode(&results)) {
    Serial.println(results.value);
    if (results.value == 3041526525){ // Remote ^
         digitalWrite(LED, HIGH);
		 Serial.println("Para Frente");
         MOTOR_forward(speed_val);
         delay (25);
    }
     else if (results.value == 3041575485){ // Remote >
         digitalWrite(LED, LOW);
		 Serial.println("Virando para Direita");
         MOTOR_turnright(speed_val);
         delay (25);
     }
     else if (results.value == 3041542845){ // Remote <
         digitalWrite(LED, LOW);
		 Serial.println("Virando para Esquerda");
         MOTOR_turnleft(speed_val);
         delay (25);
     }
     else if (results.value == 3041559165){ // Remote v
         digitalWrite(LED, LOW);
		 Serial.println("Marcha Re");
         MOTOR_reverse(speed_val);
         delay (25);
     }
     else if (results.value == 3041546415){ // Remote +
         digitalWrite(LED, LOW);
	 speed_val = speed_val + 5;
         Serial.println(speed_val);
	 test_speed();
         delay (25);
     }
     else if (results.value == 3041579055){ // Remote -
         digitalWrite(LED, LOW);
	 speed_val = speed_val - 5;
         Serial.println(speed_val);
	 test_speed();
         delay (25);
     }
     else {
        MOTOR_stop();
        digitalWrite(LED, LOW);
		results.value == 0
          }
    irrecv.resume(); // Receive the next value
  }
}