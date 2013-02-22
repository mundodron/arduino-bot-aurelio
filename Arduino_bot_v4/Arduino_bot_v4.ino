#include <Servo.h>   

// Motor
int motor_pin1 = 2; //Motor L -
int motor_pin2 = 3; //Motor L +
int motor_pin3 = 4; //Motor R -
int motor_pin4 = 5; //Motor R +
int M1_PWM = 6;     //Velocidade motor Direito
int M2_PWM = 7;     //Velocidade motor Esquerdo

//Ping  HC-SR04 ultrasonic distance sensor
int trigPin = 9;
int echoPin = 8;
long duration, distance;

// Botao
int botao = 11;

//Servo
int servopin = 10;
Servo myservo;                        

//Speaker
int speaker = 12;

// LED pin attached to Arduino D13
int LED = 13;

// Variaveis 
int incomingByte;
int leftdist;
int rightdist;
int obstaculo;
int state = 1;

void setup ()
{
  // L298 motor control
  pinMode(motor_pin1,OUTPUT);
  pinMode(motor_pin2,OUTPUT);
  pinMode(motor_pin3,OUTPUT);
  pinMode(motor_pin4,OUTPUT);
  pinMode(M1_PWM, OUTPUT);
  pinMode(M2_PWM, OUTPUT);
 
  //Servo
  myservo.attach(servopin);
  myservo.write(90);
  delay(300);
  
  //Ping HC-SR04
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  // declare imputs botao
  pinMode(botao, INPUT); 

 // Tada
 // tone(speaker, frequency, duration)
  tone(speaker, 200, 300);
  delay(100);
  tone(speaker, 300, 400);
  delay(80);
  tone(speaker, 100, 300);
    
  digitalWrite(LED, LOW);
  Serial.begin (9600);
  
  //Velocidade dos motores
  analogWrite(M1_PWM, 140); //Velocidade motor Direito
  analogWrite(M2_PWM, 150); //Velocidade motor Esquerdo
}

void loop()
{
// Comunica��o Serial
if (Serial.available() > 0) {
incomingByte = Serial.read();
digitalWrite(LED, HIGH);
Serial.print("I received: ");
Serial.println(incomingByte);
delay(10);
if (incomingByte == 46){
state = 0;
Serial.println(state);
}
} // End Serial

//Explorar se nao hover obstaculo em menos de 8cm toca o barco
 obstaculo = ping();
  if(obstaculo > 8 ) {                  
   tone(speaker, (obstaculo*50), 2);
   forward(); 
  }
  //Se encontrar um obstaculo entre 0cm e 10cm procura outra rota...
  if(obstaculo <= 8) {
    tone(speaker, (obstaculo*100), 30);
   findroute();
  }
} // End Loop
 
void forward() { 
  digitalWrite(LED, HIGH);         
  Serial.print("I forward ");
  Serial.println(distance);
  digitalWrite(motor_pin1,LOW);   //Motor L -
  digitalWrite(motor_pin2,HIGH);  //Motor L +
  digitalWrite(motor_pin3,LOW);   //Motor R -
  digitalWrite(motor_pin4,HIGH);  //Motor R +
  digitalWrite(LED, LOW);
   return;
 }
//fazendo a Rota 
void findroute() {
  halt();                      // para!
  backward();                  // Anda para tras
  lookleft();                  // Olha para esquerda e retorna distancia do objeto
  lookright();                 // Olha para direita e retorna distancia do objeto
                                      
 if ( leftdist > rightdist )  // decide para que lado virar 
  {
    tone(speaker, (3000), 30);
    turnleft();
     Serial.print("I turnleft ");
     Serial.print(leftdist);
     Serial.print(" - ");
     Serial.println(rightdist);    
  }
 else
 {
    tone(speaker, (1000), 30);
     turnright();  
     Serial.print("I turnright ");
     Serial.print(leftdist);
     Serial.print(" - ");
     Serial.println(rightdist);    
 }
}

// Rotinha de marcha R�, inverte os dois motores 
void backward() {
   Serial.print("I backward ");
   Serial.println(distance);
   digitalWrite(motor_pin1,HIGH);  //Motor L -
   digitalWrite(motor_pin2,LOW);   //Motor L +
   digitalWrite(motor_pin3,HIGH);  //Motor R -
   digitalWrite(motor_pin4,LOW);   //Motor R +
   delay(500);
   halt();
  return;
}

// Parado
void halt () {
  digitalWrite(motor_pin1,LOW);
  digitalWrite(motor_pin2,LOW); 
  digitalWrite(motor_pin3,LOW);
  digitalWrite(motor_pin4,LOW);
  delay(500);               
  return;
}
 
 //Olha para Esquerda e retorna a distancia
void lookleft() {
  myservo.write(30);
  delay(700); 
  leftdist = ping();
  Serial.print("Qual vai ser? ");  
  Serial.println(leftdist);  
  myservo.write(90);
  delay(500);                      
  return;
}
//Olha para Direita e retorna a disntancia 
void lookright () {
  myservo.write(150);
  delay(700);     
  rightdist = ping();
  Serial.print("Qual vai ser? ");  
  Serial.println(rightdist);  
  myservo.write(90);                                  
  delay(500);                    
  return;
}

void turnleft () { //inverte motor esquerdo
  //Serial.print("I turnleft ");
  //Serial.println(leftdist);
  digitalWrite(motor_pin1,HIGH);  //Motor L -              
  digitalWrite(motor_pin2,LOW);   //Motor L +
  digitalWrite(motor_pin3,LOW);   //Motor R -
  digitalWrite(motor_pin4,HIGH);  //Motor R +
  delay(500);              
  halt();
  return;
}

void turnright () { //inverte o motor direito
  //Serial.print("I turnright ");
  //Serial.println(rightdist);
  digitalWrite(motor_pin1,LOW);   //Motor L +
  digitalWrite(motor_pin2,HIGH);  //Motor L -
  digitalWrite(motor_pin3,HIGH);  //Motor R +
  digitalWrite(motor_pin4,LOW);   //Motor R -
  delay(500); 
  halt();
  return;
}

int ping() {
  // HC-SR04 ultrasonic distance sensor (Especifico)
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = (duration/2) / 29.1;
//  if (distance >= 200 || distance <= 0){
//    Serial.print("Out of range -> ");
//    Serial.print(distance);
//    Serial.println(" cm");
//  }
//  else {
//    Serial.print(distance);
//    Serial.println(" cm");
//  }
  delay(100);
  return distance;
}
