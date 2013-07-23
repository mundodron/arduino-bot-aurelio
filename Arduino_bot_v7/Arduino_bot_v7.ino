/*
    Arduino_bot
    Aurelio Monteiro Avanzi
*/

//#include <IRremote.h>
#include <Servo.h>

// Controle do Motor
int motor[] = {2, 3, 4, 7, 5, 6};
// indice: Motor L -, Motor L +, Motor R -, Motor R +, Velocidade motor Direito, Velocidade motor Esquerdo

//Ping  HC-SR04 ultrasonic distance sensor
int trigPin = 9;
int echoPin = 8;
long duration, distance;

// Infrared to Arduino D11
//int RECV_PIN = 11;
//IRrecv irrecv(RECV_PIN);
//decode_results results;

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
  //infrared();

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
          speed_val = speed_val*5;}
    //tone(speaker, (obstaculo*50), 2);
    MOTOR(speed_val,"forward");
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
  MOTOR(0,"halt");             // Para!
  MOTOR(speed_val,"backward"); // Anda para tras
  delay(250);                  // Continua por 250ms
  MOTOR(0,"halt");             // Para e...
  look();                      // Olha para esquerda,direita e retorna as distancia do objeto 
  
  Serial.print("Para onde eu viro? E ou D");
  Serial.print(leftdist);
  Serial.print(" vs ");
  Serial.println(rightdist);
  
  if ( leftdist >= rightdist ) }  // decide para que lado virar
     //tone(speaker, (3000), 30);
     Serial.print("vou para esquerda ");
	 Serial.println(leftdist);
     MOTOR(speed_val,"turnleft");
     //Se a distancia R < 40cm e > 10cm delay de 20* R 
	 if ( rightdist <= 40 || rightdist > 10 ) delay(20*rightdist); else delay(500); MOTOR_halt();
   }
   else {
      //tone(speaker, (1000), 30);
      Serial.print("vou para direita ");
	  Serial.println(rightdist);
      MOTOR(speed_val,"turnright");
	  //Se a distancia L < 40cm e > 10cm delay de 20* L
	  if ( leftdist <= 40 || leftdist > 10 ) delay(20*leftdist); else delay(500); MOTOR_halt();
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

//Para melhorar a acertividade mede a distancia dos objetos cinco vezes e retorna a media.
int mediaping(){
  int i;
  int sval = 0;
  for (i = 0; i < 5; i++){
    sval = sval + ping();
	delay(10);}
  sval = sval / 5;
  return sval;
  }

//Rotina que controla os motores
void MOTOR(int X, char dir) {
    if (X >= 255){X = 255;}       //Trava no 255
	if (X <= 0){X = 0;}           //Trava no 0
	analogWrite(motor[4], X);     //Velocidade motor Direito
    analogWrite(motor[5], X );    //Velocidade motor Esquerdo
    digitalWrite(LED, HIGH);
  if (dir = "forward" ){          // Rotina forward
    digitalWrite(motor[0],LOW);   //Motor L -
    digitalWrite(motor[1],HIGH);  //Motor L +
    digitalWrite(motor[2],LOW);   //Motor R -
    digitalWrite(motor[3],HIGH);  //Motor R +
    digitalWrite(LED, LOW);
  }
  else if (dir = "backward" ) {   // Rotina de marcha Re, inverte os dois motores
   digitalWrite(motor[0],HIGH);   //Motor L -
   digitalWrite(motor[1],LOW);    //Motor L +
   digitalWrite(motor[2],HIGH);   //Motor R -
   digitalWrite(motor[3],LOW);    //Motor R +
  }                             
  else if (dir = "turnleft" ) {   //inverte motor esquerdo virando para esquerda
   digitalWrite(motor[0],HIGH);   //Motor L -
   digitalWrite(motor[1],LOW);    //Motor L +
   digitalWrite(motor[2],LOW);    //Motor R -
   digitalWrite(motor[3],HIGH);   //Motor R +
  }                               
  else if (dir = "turnright"){    //inverte o motor direito Virando para direita
   digitalWrite(motor[0],LOW);    //Motor L +
   digitalWrite(motor[1],HIGH);   //Motor L -
   digitalWrite(motor[2],HIGH);   //Motor R +
   digitalWrite(motor[3],LOW);    //Motor R -
  }                               
  else {                          //motor Parado
   digitalWrite(motor[0],LOW);    //Motor L +
   digitalWrite(motor[1],LOW);    //Motor L -
   digitalWrite(motor[2],LOW);    //Motor R +
   digitalWrite(motor[3],LOW);    //Motor R -
  }
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

	 
	 /*
// Controle infravermelho
char infrared(){
  if (irrecv.decode(&results)) {
      //tone(speaker, (12100), 40);
    digitalWrite(LED, HIGH);
    Serial.println(results.value);
    if (results.value == 3041526525){ // Remote ^
         MOTOR_forward(speed_val);
         delay (25);
    }
     else if (results.value == 3041575485){ // Remote >
         MOTOR_turnright(speed_val);
         delay (25);
     }
     else if (results.value == 3041542845){ // Remote <
         MOTOR_turnleft(speed_val);
         delay (25);
     }
     else if (results.value == 3041559165){ // Remote v
         MOTOR_backward(speed_val);
         delay (25);
     }
     else if (results.value == 3041546415){ // Remote +
     speed_val = speed_val + 5;
         Serial.print(" SPEED ");
		 Serial.println(speed_val);
         test_speed();
         delay (25);
     }
     else if (results.value == 3041579055){ // Remote -
     speed_val = speed_val - 5;
         Serial.print(" SPEED ");
		 Serial.println(speed_val);
         test_speed();
         delay (25);
     }
     else if (results.value == 3041536215 ){ // Remote BMS
        MOTOR_halt();
        //digitalWrite(LED, LOW);
          }
     else if (results.value == 3041556615 ){ // Remote CD
        if (onoff = 1) {
             onoff == 0;
          }
        else{
             onoff == 1;
          }
		delay(25);
     } //onoff
     else if (results.value == 3041540295){ // Remote TUNER
        if (autoroute = 1) {
           autoroute == 0;
        }
        else{
           autoroute == 1;
        }
       delay(25);
     } //autoroute
        delay (25);
     irrecv.resume(); // Receive the next value
	   digitalWrite(LED, LOW);
  }
} // End infrared
*/

