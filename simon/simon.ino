/*Simon Says game by Robert Spann*/

int switch1 = 11; //The four button input pins
int switch2 = 10;
int switch3 = 9;
int switch4 = 8;
int led1 = 5; //LED pins
int led2 = 4;
int led3 = 3;
int led4 = 2;
int turn = 0;
int input1 = LOW;
int input2 = LOW;
int input3 = LOW;
int input4 = LOW;

int randomArray[100]; //Intentionally long to store up to 100 inputs (doubtful anyone will get this far)
int inputArray[100];


void setup() {

  Serial.begin(9600); 

  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  pinMode(switch1, INPUT);
  pinMode(switch2, INPUT);
  pinMode(switch3, INPUT);
  pinMode(switch4, INPUT);
  randomSeed(analogRead(0)); //Added to generate "more randomness" with the randomArray for the output function
 
 for (int y=0; y<=99; y++){ //For statement to loop through the output and input functions
   output();
   input();
 }
 
   }
   
void output() { //function for generating the array to be matched by the player
    
   for (int y=turn; y <= turn; y++){ //Limited by the turn variable
    Serial.println(""); //Some serial output to follow along
    Serial.print("Turn: ");
    Serial.print(y);
    Serial.println("");
    randomArray[y] = random(1, 5); //Assigning a random number (1-4) to the randomArray[y], y being the turn count
    for (int x=0; x <= turn; x++){ 

      Serial.print(randomArray
);

      if (randomArray
== 1) {  //if statements to display the stored values in the array
       digitalWrite(led1, HIGH);
        delay(500);
        digitalWrite(led1, LOW);
        delay(100);
      }

      if (randomArray
== 2) {
       digitalWrite(led2, HIGH);
        delay(500);
        digitalWrite(led2, LOW);
        delay(100);
      }

      if (randomArray
== 3) {
       digitalWrite(led3, HIGH);
        delay(500);
        digitalWrite(led3, LOW);
        delay(100);
      }

      if (randomArray
== 4) {
       digitalWrite(led4, HIGH);
        delay(500);
        digitalWrite(led4, LOW);
        delay(100);
      }
     }
    }
   }
  
  
  
void input() { //Function for allowing user input and checking input against the generated array

  for (int x=0; x <= turn;){ //Statement controlled by turn count
    input1 = digitalRead(switch1);
    input2 = digitalRead(switch2);
    input3 = digitalRead(switch3);
    input4 = digitalRead(switch4);

    if (input1 == HIGH){ //Checking for button push
      digitalWrite(led1, HIGH);
      delay(200);
      digitalWrite(led1, LOW);
      inputArray
= 1;
     delay(50);
      Serial.print(" ");
      Serial.print(1);
      if (inputArray
!= randomArray
) { //Checks value input by user and checks it against
       fail();                              //the value in the same spot on the generated array
      }                                      //The fail function is called if it does not match
      x++;
    }

    if (input2 == HIGH){
      digitalWrite(led2, HIGH);
      delay(200);
      digitalWrite(led2, LOW);
      inputArray
= 2;
     delay(50);
      Serial.print(" ");
      Serial.print(2);
      if (inputArray
!= randomArray
) {
       fail();
      }
      x++;

    }

    if (input3 == HIGH){
      digitalWrite(led3, HIGH);
      delay(200);
      digitalWrite(led3, LOW);
      inputArray
= 3;
     delay(50);
      Serial.print(" ");
      Serial.print(3);
      if (inputArray
!= randomArray
) {
       fail();
      }
      x++;

    }

    if (input4 == HIGH){

      digitalWrite(led4, HIGH);
      delay(200);
      digitalWrite(led4, LOW);
      inputArray
= 4;
     delay(50);
      Serial.print(" ");
      Serial.print(4);
      if (inputArray
!= randomArray
) {
       fail();
      }
      x++;

    }
   }
  delay(500);
  turn++; //Increments the turn count, also the last action before starting the output function over again
}

void fail() { //Function used if the player fails to match the sequence
  
  for (int y=0; y<=5; y++){ //Flashes lights for failure
   digitalWrite(led1, HIGH);
   digitalWrite(led2, HIGH);
   digitalWrite(led3, HIGH);
   digitalWrite(led4, HIGH);
   delay(200);
   digitalWrite(led1, LOW);
   digitalWrite(led2, LOW);
   digitalWrite(led3, LOW);
   digitalWrite(led4, LOW);
   delay(200);
  }
  delay(500);
  turn = -1; //Resets turn value so the game starts over without need for a reset button
}

void loop() { //Unused void loop(), though for some reason it doesn't compile without this /shrug
}