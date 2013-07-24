/*
    Arduino_bot
    Aurelio Monteiro Avanzi
*/

#include <Servo.h>

// Controle do Motor
int motor[] = {2, 3, 4, 7, 5, 6};
// indice: Motor L -, Motor L +, Motor R -, Motor R +, Velocidade motor Direito, Velocidade motor Esquerdo

//Ping  HC-SR04 ultrasonic distance sensor
int trigPin = 9;
int echoPin = 8;
long duration, distance;

//Potenciometro
int potpin = 0;
int potval;

//Servo
int servopin = 10;
Servo myservo;

//Speaker ligado ao pino D12
int speaker = 12;

//LED ligado ao pino D13
int LED = 13;

// Variaveis
int speed_val, incomingByte, leftdist, rightdist, obstaculo;
int state = 1;
int onoff = 1;
int autoroute = 0;

void setup ()
{
  // L298 motor control
  pinMode(motor[0],OUTPUT);
  pinMode(motor[1],OUTPUT);
  pinMode(motor[2],OUTPUT);
  pinMode(motor[3],OUTPUT);
  pinMode(motor[4],OUTPUT);
  pinMode(motor[5],OUTPUT);

  //Servo
  myservo.attach(servopin);
  myservo.write(90);

  //Ping HC-SR04
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // declare imputs botao
  //pinMode(botao, INPUT);

  //Infrared
  //irrecv.enableIRIn(); // Start the receiver
  
  //Serial setup
  Serial.begin(9600);
  Serial.println("Iniciando Sistema");
  // Tada
  // tone(speaker, frequency, duration)
  //tone(speaker, 200, 300);
  delay(100);
  //tone(speaker, 300, 400);
  delay(80);
  //tone(speaker, 100, 300);

  digitalWrite(LED, LOW);
} //EOF Setup

void loop(){

 // Potenciometro le a posicao do potenciometro constantemente para determinar a velocidade.
 potval = analogRead(potpin);               // Le o valor do potenciometro (valor 0 a 1023)
 potval = map(potval, 0, 1023, 0, 255);     // Coloca o valor recebido do potenciometro na escala de 0 a 180 graus
 speed_val = potval;
 
 //Explorar se nao houver obstaculo em menos de 8cm toca o barco
  if (autoroute = 1) {
 obstaculo = ping();
  delay(100);
   if(obstaculo > 8 ) {
        Serial.print("nehum obstaculo em menos de 9cm tocando o barco ");
        Serial.print(obstaculo);
        Serial.println("cm");
        if(obstaculo > 20 ) { //quintuplica a velocidade se nao encontrar nada por perto
          Serial.print("Nenhum obstaculo em menos de 20cm triplica velocidade ");
          Serial.print(obstaculo);
          Serial.println(" cm");
          //tone(speaker, 5000, 20);
          speed_val = speed_val*2;}
    //tone(speaker, (obstaculo*50), 2);
    MOTOR(speed_val,1); //Motor forward
  //Se encontrar um obstaculo entre 0cm e 8cm procura outra rota...
  } else {
        Serial.print("Obstaculo encontrado a ");
        Serial.print(obstaculo);
        //tone(speaker, (obstaculo*100), 30);
        speed_val = potval;
        findroute();}
    } //auto
} // End Loop

//fazendo a Rota
void findroute() {
  MOTOR(0,0);                  // halt Para!
  MOTOR(speed_val,2);          // backward Anda para tras
  delay(250);                  // Continua por 250ms
  MOTOR(0,0);                  // halt Para e...
  look();                      // Olha para esquerda,direita e retorna as distancia do objeto 
  
  Serial.print("Para onde eu viro? E ou D");
  Serial.print(leftdist);
  Serial.print(" vs ");
  Serial.println(rightdist);
  
  if ( leftdist >= rightdist ) {  // decide para que lado virar
     //tone(speaker, (3000), 30);
     Serial.print("vou para esquerda ");
     Serial.println(leftdist);
     MOTOR(speed_val,3); // Motor turnleft
     //Se a distancia R < 40cm e > 10cm delay de 20* R 
     if ( rightdist <= 40 || rightdist > 10 ) delay(200*rightdist); else delay(2000); MOTOR(0,0);
   }
   else {
      //tone(speaker, (1000), 30);
      Serial.print("vou para direita ");
      Serial.println(rightdist);
      MOTOR(speed_val,4); //Motor turnright
      //Se a distancia L < 40cm e > 10cm delay de 20* L
      if ( leftdist <= 40 || leftdist > 10 ) delay(200*leftdist); else delay(2000); MOTOR(0,0);
   }
} //end findroute
 
//Olha para Esquerda,Direita e retorna as distancia
void look() {
  myservo.write(10);       //Coloca o servo em 10 graus
  delay(500);              //delay
  leftdist = mediaping();  //Grava a distancia do objeto 
  delay(100);              //delay
  myservo.write(90);       //Coloca o servo em 90 graus
  delay(350);              //delay
  myservo.write(160);      //Coloca o Servo em 160 graus
  delay(500);              //delay
  rightdist = mediaping(); //Grava a distancia do objeto
  delay(100);              //delay
  myservo.write(90);       //Coloca o servo em 90 graus
  delay(350);              //delay
  return;
} // EOF Look

//Rotina que controla os motores
void MOTOR(int X, int dir) {
    if (X >= 255){X = 255;}       //Trava no 255
    if (X <= 0){X = 0;}           //Trava no 0
    analogWrite(motor[4], X);     //Velocidade motor Direito
    analogWrite(motor[5], X );    //Velocidade motor Esquerdo
    digitalWrite(LED, HIGH);
  switch (dir) {
      case 1:                       //Rotina forward
      digitalWrite(motor[0],LOW);   //Motor L -
      digitalWrite(motor[1],HIGH);  //Motor L +
      digitalWrite(motor[2],LOW);   //Motor R -
      digitalWrite(motor[3],HIGH);  //Motor R +
      break;

      case 2:                       //Rotina de marcha Re, inverte os dois motores
      digitalWrite(motor[0],HIGH);  //Motor L -
      digitalWrite(motor[1],LOW);   //Motor L +
      digitalWrite(motor[2],HIGH);  //Motor R -
      digitalWrite(motor[3],LOW);   //Motor R +
      break;
  
      case 3:                       //Inverte motor esquerdo virando para esquerda
      digitalWrite(motor[0],HIGH);  //Motor L -
      digitalWrite(motor[1],LOW);   //Motor L +
      digitalWrite(motor[2],LOW);   //Motor R -
      digitalWrite(motor[3],HIGH);  //Motor R +
      break;

      case 4:                       //Inverte o motor direito Virando para direita
      digitalWrite(motor[0],LOW);   //Motor L +
      digitalWrite(motor[1],HIGH);  //Motor L -
      digitalWrite(motor[2],HIGH);  //Motor R +
      digitalWrite(motor[3],LOW);   //Motor R -
      break;

      case 0:                       //Motor Parado
      digitalWrite(motor[0],LOW);   //Motor L +
      digitalWrite(motor[1],LOW);   //Motor L -
      digitalWrite(motor[2],LOW);   //Motor R +
      digitalWrite(motor[3],LOW);   //Motor R -
      break;
  } //EOF switch
  digitalWrite(LED, LOW);
}// EOF motor

int ping() {
// HC-SR04 ultrasonic distance sensor
// A velocidade do som e de 340 m/s ou 29 microssegundos por centimetro.
// O ping e enviado para frente e reflete no objeto para encontrar a distancia
// A distancia do objeto fica na metade da distancia percorrida.

  digitalWrite(LED, LOW);
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = (duration/2) / 29.1;
  delay(100);
  digitalWrite(LED, HIGH);
  return distance;
} // END Ping

//Para melhorar a acertividade, mede a distancia dos objetos cinco vezes e retorna a media.
int mediaping(){
  int sval = 0;
  for (int i = 0; i < 5; i++){
    sval = sval + ping();
    delay(10);}
  sval = sval / 5;
  return sval;
  }
