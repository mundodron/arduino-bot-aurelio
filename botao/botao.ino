//A boolean holds one of two values, true or false. (Each boolean variable occupies one byte of memory.)

int LEDpin = 13;       // LED on pin 13
int switchPin = 5;   // momentary switch on 5, other side connected to ground

boolean running = false;

void setup()
{
  pinMode(LEDpin, OUTPUT);
  pinMode(switchPin, INPUT);
  digitalWrite(switchPin, HIGH);      // turn on pullup resistor
}

void loop()
{
  if (digitalRead(switchPin) == LOW)
  {  // switch is pressed - pullup keeps pin high normally
    delay(100);                        // delay to debounce switch
    running = !running;                // toggle running variable
    digitalWrite(LEDpin, running)      // indicate via LED
  }
}