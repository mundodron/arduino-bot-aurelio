int E1 = 12; 
int M1 = 10;
int E2 = 4; 
int M2 = 2;
 
void setup(){
    pinMode(M1, OUTPUT); 
    pinMode(M2, OUTPUT);
}
 
void loop(){
    int value;
    for(value = 0 ; value <= 255; value+=5){
        digitalWrite(M1,HIGH); 
        digitalWrite(M2, HIGH); 
        analogWrite(E1, value); //PWM speed adjusting 
        analogWrite(E2, value); //PWM speed adjusting 
        delay(30);
    } 
}

