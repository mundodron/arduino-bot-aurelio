#include <IRremote.h>
#include <Servo.h>

// Motor
int motor_pin1 = 2; //Motor L -
int motor_pin2 = 3; //Motor L +
int motor_pin3 = 4; //Motor R -
int motor_pin4 = 7; //Motor R +
int M1_PWM = 5;     //Velocidade motor Direito
int M2_PWM = 6;     //Velocidade motor Esquerdo

//Ping  HC-SR04 ultrasonic distance sensor
int trigPin = 9;
int echoPin = 8;
long duration, distance;

// Infrared to Arduino D11
int RECV_PIN = 11;

//Potenciometro
int potpin = 0;
int potval;

//Servo
int servopin = 10;
Servo myservo;

//Speaker attached to Arduino D12
int speaker = 12;

//LED pin attached to Arduino D13
int LED = 13;

// Variaveis
int incomingByte;
int leftdist;
int rightdist;
int obstaculo;
int state = 1;
int onoff = 0;
int autoroute = 0;
int speed_val;
IRrecv irrecv(RECV_PIN);
decode_results results;

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

  //Ping HC-SR04
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // declare imputs botao
  //pinMode(botao, INPUT);

  //Infrared
    irrecv.enableIRIn(); // Start the receiver

  // Tada
  // tone(speaker, frequency, duration)
  serial('Iniciando Sistema');
  tone(speaker, 200, 300);
  delay(100);
  tone(speaker, 300, 400);
  delay(80);
  tone(speaker, 100, 300);

  digitalWrite(LED, LOW);

  //Serial setup
  Serial.begin(9600);
  Serial.write('Power On');
}

void loop(){
  infrared();

 //Velocidade dos motores
if (onoff == 1) {
    analogWrite(M1_PWM, 80); //Velocidade motor Direito
    analogWrite(M2_PWM, 80); //Velocidade motor Esquerdo
 } else{
    analogWrite(M1_PWM, 0); //Velocidade motor Direito
    analogWrite(M2_PWM, 0); //Velocidade motor Esquerdo
 }

 // Potenciometro
 potval = analogRead(potpin);               // Le o valor do potenciometro (valor 0 a 1023)
 potval = map(potval, 0, 1023, 0, 255);     // Coloca o valor recebido do potenciometro na escala de 0 a 180 graus
 speed_val = potval;
 serial('Velocidade' || potval);
 //Explorar se nao houver obstaculo em menos de 8cm toca o barco
 obstaculo = ping();
 if (autoroute = 1) {
    if(obstaculo > 8 ) {
        serial('nehum obstaculo em menos de 8cm tocando o barco' || obstaculo || 'cm');
        if(obstaculo > 20 ) { //triplica a velocidade se nao encontrar nada por perto
            serial('nenhum obstaculo em menos de 30cm triplica velocidade' || obstaculo || 'cm');
            //tone(speaker, 500, 20);
            speed_val = speed_val*5;
            }
    //tone(speaker, (obstaculo*50), 2);
    MOTOR_forward(speed_val);
    }
    //Se encontrar um obstaculo entre 0cm e 8cm procura outra rota...
    if(obstaculo <= 8) {
        serial('Obstaculo encontrado a ' || obstaculo);
        //tone(speaker, (obstaculo*100), 30);
        findroute();
    }
 } //auto
} // End Loop


//fazendo a Rota
void findroute() {
  MOTOR_halt();                // para!
  MOTOR_backward(speed_val);   // Anda para tras
  lookleft();                  // Olha para esquerda e retorna distancia do objeto
  lookright();                 // Olha para direita e retorna distancia do objeto
  serial('Para onde eu viro? ' || leftdist || ' vs ' || rightdist);
 if ( leftdist > rightdist )  // decide para que lado virar
 {
   //tone(speaker,300, 30);
   serial('Esquerda ');
   MOTOR_turnleft(speed_val);
 }
 else
 {
    //tone(speaker, 1000, 30);
    serial('Direita ');
    MOTOR_turnright(speed_val);
 }
}

 //Olha para Esquerda e retorna a distancia
void lookleft() {
  myservo.write(30);
  delay(700);
  leftdist = ping();
  serial('Olhando para esquerda ');
  serial('Obstaculo a ' || leftdist || 'cm');
  myservo.write(90);
  delay(200);
  return;
}

//Olha para Direita e retorna a disntancia
void lookright () {
  myservo.write(150);
  delay(700);
  rightdist = ping();
  serial('Olhando para Direita ');
  serial('Obstaculo a ' || rightdist || 'cm');
  myservo.write(90);
  delay(200);
  return;
}

void MOTOR_forward(int X) {
  analogWrite(M1_PWM, X);    //Velocidade motor Direito
  analogWrite(M2_PWM, X );   //Velocidade motor Esquerdo
  digitalWrite(LED, HIGH);
  serial('Vou para frente ' || distance || 'cm');
  digitalWrite(motor_pin1,LOW);   //Motor L -
  digitalWrite(motor_pin2,HIGH);  //Motor L +
  digitalWrite(motor_pin3,LOW);   //Motor R -
  digitalWrite(motor_pin4,HIGH);  //Motor R +
  digitalWrite(LED, LOW);
   return;
 }

// Rotina de marcha Re, inverte os dois motores
void MOTOR_backward(int X) {
   analogWrite(M1_PWM, X);         //Velocidade motor Direito
   analogWrite(M2_PWM, X);         //Velocidade motor Esquerdo
   serial('Voltando ');
   digitalWrite(motor_pin1,HIGH);  //Motor L -
   digitalWrite(motor_pin2,LOW);   //Motor L +
   digitalWrite(motor_pin3,HIGH);  //Motor R -
   digitalWrite(motor_pin4,LOW);   //Motor R +
   delay(250);
   MOTOR_halt();
  return;
}

void MOTOR_turnleft (int X) {     //inverte motor esquerdo virando para esquerda
  analogWrite(M1_PWM, X);         //Velocidade motor Direito
  analogWrite(M2_PWM, X);         //Velocidade motor Esquerdo
  digitalWrite(motor_pin1,HIGH);  //Motor L -
  digitalWrite(motor_pin2,LOW);   //Motor L +
  digitalWrite(motor_pin3,LOW);   //Motor R -
  digitalWrite(motor_pin4,HIGH);  //Motor R +
 if ( rightdist < 90 || rightdist > 4 ) {
  delay(200*rightdist);
 }
 else {
  delay(500);
 }
  MOTOR_halt();
  return;
}

void MOTOR_turnright (int X) {    //inverte o motor direito Virando para direita
  analogWrite(M1_PWM, X);         //Velocidade motor Direito
  analogWrite(M2_PWM, X);         //Velocidade motor Esquerdo
  digitalWrite(motor_pin1,LOW);   //Motor L +
  digitalWrite(motor_pin2,HIGH);  //Motor L -
  digitalWrite(motor_pin3,HIGH);  //Motor R +
  digitalWrite(motor_pin4,LOW);   //Motor R -
 if ( rightdist < 90 || rightdist > 4 ) {
  delay(200*leftdist);
 }
 else {
  delay(500);
 }
  MOTOR_halt();
  return;
}

// Parado
void MOTOR_halt () {
  serial('Parando ');
  analogWrite(M1_PWM, 0); //Velocidade motor Direito
  analogWrite(M2_PWM, 0); //Velocidade motor Esquerdo
  digitalWrite(motor_pin1,LOW);
  digitalWrite(motor_pin2,LOW);
  digitalWrite(motor_pin3,LOW);
  digitalWrite(motor_pin4,LOW);
  delay(250);
  return;
}

int ping() {
// HC-SR04 ultrasonic distance sensor (Especifico)
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
  digitalWrite(LED, HIGH);
  delay(100);
  return distance;
}

  //Speed Control
    void test_speed(){
        // constrain speed value to between 0-255
        if (speed_val > 250){
            speed_val = 255;
            Serial.println(" MAX ");
            tone(speaker,610, 90);
        }
        if (speed_val < 0){
            speed_val = 0;
            Serial.println(" MIN ");
            tone(speaker,510, 90);
        }
     } //end test_speed

// Comunicacao Serial
char serial(char X){
  //Porta serial
  if (Serial.available() > 0) {
  incomingByte = Serial.read();
  digitalWrite(LED, HIGH);
  Serial.write(X);
 // Serial.println(incomingByte);
  delay(10);
 // check incoming byte for direction
        // if byte is equal to "105" or "i", go forward
        if (incomingByte == 105){
            MOTOR_forward;
            delay(25);
        }
        // if byte is equal to "106" or "j", go turnleft
        else if (incomingByte == 106){
            MOTOR_turnleft;
            delay(25);
        }
        // if byte is equal to "108" or "l", go turnright
        else if (incomingByte == 108){
            MOTOR_turnright;
            delay(25);
        }
        // if byte is equal to "107" or "k", go backward
        else if (incomingByte == 107){
            MOTOR_backward;
            delay(25);
        }
//        else {
//            MOTOR_stop();
//            digitalWrite(LED, LOW);
//        }
    } // end if serial
} //end serial();

char infrared(){
  if (irrecv.decode(&results)) {
      tone(speaker,121, 40);
    digitalWrite(LED, HIGH);
    Serial.println(results.value);
    if (results.value == 3041526525){
         MOTOR_forward(speed_val);
         delay (25);
    }
     else if (results.value == 3041575485){
         MOTOR_turnright(speed_val);
         delay (25);
     }
     else if (results.value == 3041542845){
         MOTOR_turnleft(speed_val);
         delay (25);
     }
     else if (results.value == 3041559165){
         MOTOR_backward(speed_val);
         delay (25);
     }
     else if (results.value == 3041546415){
     speed_val = speed_val + 5;
         Serial.println(" SPEED " || speed_val);
         test_speed();
         delay (25);
     }
     else if (results.value == 3041579055){
     speed_val = speed_val - 5;
         Serial.println(" SPEED " || speed_val);
         test_speed();
         delay (25);
     }
     else if (results.value == 3041579055){
        MOTOR_halt();
        digitalWrite(LED, LOW);
          }
     else if (results.value == 3041556615){
        if (onoff = 1) {
           onoff == 0;
        }
        else{
           onoff == 1;
        }
        }
     else if (results.value == 3041536215){
        if (autoroute = 1) {
           autoroute == 0;
        }
        else{
           autoroute == 1;
        }
        }
        delay (25);
     irrecv.resume(); // Receive the next value
  }
}

