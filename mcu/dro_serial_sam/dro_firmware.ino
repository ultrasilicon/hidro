#include <Arduino.h>

template<unsigned char A_PIN, unsigned char B_PIN> struct Scale {
  volatile bool a_val;
  volatile bool a_prev;
  volatile bool b_val;
  volatile bool b_prev;
  float counter;

  Scale(void(*isr)()) {
    pinMode(A_PIN, INPUT);
    attachInterrupt(A_PIN, isr, CHANGE);
    a_val = digitalRead(A_PIN);
    a_prev = a_val;

    pinMode(B_PIN, INPUT);
    attachInterrupt(B_PIN, isr, CHANGE);
    b_val = digitalRead(B_PIN);
    b_prev = b_val;

    counter = 0;
  }

  int update() {
    a_val = digitalRead(A_PIN);
    b_val = digitalRead(B_PIN);

    // parse quadrature signal
    if (a_prev && b_prev) {
      if (!a_val && b_val) counter ++;
      if (a_val && !b_val) counter --;
    } else if (!a_prev && b_prev) {
      if (!a_val && !b_val) counter ++;
      if (a_val && b_val) counter --;
    } else if (!a_prev && !b_prev) {
      if (a_val && !b_val) counter ++;
      if (!a_val && b_val) counter --;
    } else if (a_prev && !b_prev) {
      if (a_val && b_val) counter ++;
      if (!a_val && !b_val) counter --;
    }

    a_prev = a_val;
    b_prev = b_val;
  }

  float getValue() {
    return this->counter * 0.005;
  }
};


Scale<9, 10>* scale_x = nullptr;
Scale<4, 5>* scale_y = nullptr;
Scale<2, 3>* scale_z = nullptr;
int timestamp = 0;

void setup()
{
  SerialUSB.begin(9600);
  
  scale_x = new Scale<9, 10>([](){scale_x->update();});
  scale_y = new Scale<4, 5>([](){scale_y->update();});
  scale_z = new Scale<2, 3>([](){scale_z->update();});
}

void loop()
{
  if(millis() - timestamp < 10)
    return;
    
  SerialUSB.print(scale_x->getValue(), 3);
  SerialUSB.print(" ");
  SerialUSB.print(scale_y->getValue(), 3);
  SerialUSB.print(" ");
  SerialUSB.print(scale_z->getValue(), 3);
  SerialUSB.print("\n");
  
  timestamp = millis();
}
