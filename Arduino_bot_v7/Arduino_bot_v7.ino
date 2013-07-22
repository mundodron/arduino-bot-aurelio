/*
    Arduino_bot
    Aurelio Monteiro Avanzi
*/
#include <Servo.h>
//#include <IRremote.h>

// Controle do Motor
int motor[] = {2, 3, 4, 7, 5, 6};
// indice: Motor L -, Motor L +, Motor R -, Motor R +, Velocidade motor Direito, Velocidade motor Esquerdo

//Ping  HC-SR04 ultrasonic distance sensor
int trigPin = 9;
int echoPin = 8;
long duration, distance;

// Infrared to Arduino D11
//int RECV_PIN = 11;

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
int incomingByte;
int leftdist;
int rightdist;
int obstaculo;
int state = 1;
int onoff = 1;
int autoroute = 0;
int speed_val;
//IRrecv irrecv(RECV_PIN);
//decode_results results;

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
  //  irrecv.enableIRIn(); // Start the receiver
  
  //Serial setup
  Serial.begin(9600);
  Serial.println("Power On");
  // Tada
  // tone(speaker, frequency, duration)
  // serial('Iniciando Sistema');
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
  // serial('Velocidade' || potval);
 
 //Explorar se nao houver obstaculo em menos de 8cm toca o barco
 obstaculo = ping();
 if (autoroute = 1) {
    if(obstaculo > 8 ) {
        serial("nehum obstaculo em menos de 8cm tocando o barco" || obstaculo || "cm");
        if(obstaculo > 20 ) { //quintuplica a velocidade se nao encontrar nada por perto
            serial("nenhum obstaculo em menos de 30cm triplica velocidade" || obstaculo || "cm");
            //tone(speaker, 5000, 20);
            speed_val = speed_val*5;
            }
    //tone(speaker, (obstaculo*50), 2);
    MOTOR_forward(speed_val);
    }
    //Se encontrar um obstaculo entre 0cm e 8cm procura outra rota...
    if(obstaculo <= 8) {
        serial("Obstaculo encontrado a " || obstaculo);
        //tone(speaker, (obstaculo*100), 30);
		speed_val = potval;
        findroute();
    }
 } //auto
} // End Loop

//fazendo a Rota
void findroute() {
  MOTOR_halt();                // para!
  MOTOR_backward(speed_val);   // Anda para tras
  delay(250);                  // Continua por 250ms
  MOTOR_halt();                // Para e...
  look();                      // Olha para esquerda,direita e retorna as distancia do objeto 
  
  Serial.print("Para onde eu viro? ");
  Serial.print(leftdist);
  Serial.print(" vs ");
  Serial.println(rightdist);
  
  if ( leftdist >= rightdist )  // decide para que lado virar
   {
   //tone(speaker, (3000), 30);
     Serial.print("vou para esquerda ");
	 Serial.println(leftdist);
     MOTOR_turnleft(speed_val);
     //Se a distancia R < 40cm e > 4cm delay de 20* R 
	 if ( rightdist <= 40 || rightdist > 4 ) delay(20*rightdist); else delay(400); MOTOR_halt();
   }
 else
   {
    //tone(speaker, (1000), 30);
     Serial.print("vou para direita ");
	 Serial.println(rightdist);
     MOTOR_turnright(speed_val);
	 //Se a distancia L < 40cm e > 4cm delay de 20* L
	 if ( leftdist <= 40 || leftdist > 4 ) delay(20*leftdist); else delay(400); MOTOR_halt();
   }
} //end findroute
  //Olha para Esquerda,Direita e retorna as distancia
void look() {
  myservo.write(10);  //Coloca o servo em 10°
  delay(400);         //delay
  leftdist = ping();  //Grava a distancia do objeto 
  delay(200);         //delay
  myservo.write(90);  //Coloca o servo em 90°
  delay(500);         //delay
  myservo.write(160); //Coloca o Servo em 160°
  delay(500);         //delay
  rightdist = ping(); //Grava a distancia do objeto
  delay(200);         //delay
  myservo.write(90);  //Coloca o servo em 90°
  delay(400);         //delay
  return;
} // EOF Look

void MOTOR_forward(int X) {
 if (onoff == 1) {
  analogWrite(motor[4], X);    //Velocidade motor Direito
  analogWrite(motor[5], X );   //Velocidade motor Esquerdo
  digitalWrite(LED, HIGH);
  //serial('Vou para frente ' || distance || 'cm');
  digitalWrite(motor[0],LOW);   //Motor L -
  digitalWrite(motor[1],HIGH);  //Motor L +
  digitalWrite(motor[2],LOW);   //Motor R -
  digitalWrite(motor[3],HIGH);  //Motor R +
  digitalWrite(LED, LOW);
   return;
  }
 }

// Rotina de marcha Re, inverte os dois motores
void MOTOR_backward(int X) {
   analogWrite(motor[4], X);     //Velocidade motor Direito
   analogWrite(motor[5], X);     //Velocidade motor Esquerdo
   digitalWrite(motor[0],HIGH);  //Motor L -
   digitalWrite(motor[1],LOW);   //Motor L +
   digitalWrite(motor[2],HIGH);  //Motor R -
   digitalWrite(motor[3],LOW);   //Motor R +
  return;
}

void MOTOR_turnleft (int X) {   //inverte motor esquerdo virando para esquerda
  analogWrite(motor[4], X);     //Velocidade motor Direito
  analogWrite(motor[5], X);     //Velocidade motor Esquerdo
  digitalWrite(motor[0],HIGH);  //Motor L -
  digitalWrite(motor[1],LOW);   //Motor L +
  digitalWrite(motor[2],LOW);   //Motor R -
  digitalWrite(motor[3],HIGH);  //Motor R +
  return;
}

void MOTOR_turnright (int X) {  //inverte o motor direito Virando para direita
  analogWrite(motor[4], X);     //Velocidade motor Direito
  analogWrite(motor[5], X);     //Velocidade motor Esquerdo
  digitalWrite(motor[0],LOW);   //Motor L +
  digitalWrite(motor[1],HIGH);  //Motor L -
  digitalWrite(motor[2],HIGH);  //Motor R +
  digitalWrite(motor[3],LOW);   //Motor R -
  return;
}


void MOTOR_halt () {        //Parado
  analogWrite(motor[4], 0); //Velocidade motor Direito
  analogWrite(motor[5], 0); //Velocidade motor Esquerdo
  digitalWrite(motor[0],LOW);
  digitalWrite(motor[1],LOW);
  digitalWrite(motor[2],LOW);
  digitalWrite(motor[3],LOW);
  delay(250);
  return;
}

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
  digitalWrite(LED, HIGH);
  delay(100);
  return distance;
} // END Ping

  //Speed Control 
    void test_speed(){
        if (speed_val >= 255){ speed_val = 255;
            Serial.println(" MAX ");
            //tone(speaker, (6100), 90);
			}
        if (speed_val <= 0){ speed_val = 0;
            Serial.println(" MIN ");
            //tone(speaker, (5100), 90);
			}
     } //end test_speed

// Comunicacao Serial
char serial(char X){
  //Porta serial
  if (Serial.available() > 0) {
  incomingByte = Serial.read(); 
  digitalWrite(LED, HIGH);
  //Serial.write(X);
  Serial.println(X);
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

/*
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
         Serial.println(" SPEED " || speed_val);
         test_speed();
         delay (25);
     }
     else if (results.value == 3041579055){ // Remote -
     speed_val = speed_val - 5;
         Serial.println(" SPEED " || speed_val);
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
