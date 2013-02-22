#include <Servo.h>                                  //includes the servo library

int motor_pin1 = 4;
int motor_pin2 = 5;
int motor_pin3 = 6;
int motor_pin4 = 7;
int servopin = 8;
int sensorpin = 0;
int dist = 0;
int leftdist = 0;
int rightdist = 0;
int object = 500;             //distance at which the robot should look for another route                           

Servo myservo;

void setup ()
{
  pinMode(motor_pin1,OUTPUT);
  pinMode(motor_pin2,OUTPUT);
  pinMode(motor_pin3,OUTPUT);
  pinMode(motor_pin4,OUTPUT);
  myservo.attach(servopin);
  myservo.write(90);
  delay(700);
}
void loop()
{
  dist = analogRead(sensorpin);               //reads the sensor
 
  if(dist < object) {                         //if distance is less than 550
   forward();                                  //then move forward
  }
  if(dist >= object) {               //if distance is greater than or equal to 550
    findroute();
  }
}
 
void forward() {                            // use combination which works for you
   digitalWrite(motor_pin1,HIGH);
   digitalWrite(motor_pin2,LOW);
   digitalWrite(motor_pin3,HIGH);
   digitalWrite(motor_pin4,LOW);
   return;
 }
 
void findroute() {
  halt();                                             // stop
  backward();                                       //go backwards
  lookleft();                                      //go to subroutine lookleft
  lookright();                                   //go to subroutine lookright
                                      
  if ( leftdist < rightdist )
  {
    turnleft();
  }
 else
 {
   turnright ();
 }
}

void backward() {
  digitalWrite(motor_pin1,LOW);
  digitalWrite(motor_pin2,HIGH);
  digitalWrite(motor_pin3,LOW);
  digitalWrite(motor_pin4,HIGH);
  delay(500);
  halt();
  return;
}

void halt () {
  digitalWrite(motor_pin1,LOW);
  digitalWrite(motor_pin2,LOW);
  digitalWrite(motor_pin3,LOW);
  digitalWrite(motor_pin4,LOW);
  delay(500);                          //wait after stopping
  return;
}
 
void lookleft() {
  myservo.write(150);
  delay(700);                                //wait for the servo to get there
  leftdist = analogRead(sensorpin);
  myservo.write(90);
  delay(700);                                 //wait for the servo to get there
  return;
}

void lookright () {
  myservo.write(30);
  delay(700);                           //wait for the servo to get there
  rightdist = analogRead(sensorpin);
  myservo.write(90);                                  
  delay(700);                        //wait for the servo to get there
  return;
}

void turnleft () {
  digitalWrite(motor_pin1,HIGH);       //use the combination which works for you
  digitalWrite(motor_pin2,LOW);      //right motor rotates forward and left motor backward
  digitalWrite(motor_pin3,LOW);
  digitalWrite(motor_pin4,HIGH);
  delay(1000);                     // wait for the robot to make the turn
  halt();
  return;
}

void turnright () {
  digitalWrite(motor_pin1,LOW);       //use the combination which works for you
  digitalWrite(motor_pin2,HIGH);    //left motor rotates forward and right motor backward
  digitalWrite(motor_pin3,HIGH);
  digitalWrite(motor_pin4,LOW);
  delay(1000);                              // wait for the robot to make the turn
  halt();
  return;
}

