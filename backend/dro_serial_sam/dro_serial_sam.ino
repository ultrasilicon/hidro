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
    pinMode(B_PIN, INPUT);
    attachInterrupt(B_PIN, isr, CHANGE);

    a_val = digitalRead(A_PIN);
    a_prev = a_val;
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
Scale<7, 8>* scale_y = nullptr;
Scale<3, 4>* scale_z = nullptr;
int timestamp = 0;

void setup()
{
  Serial.begin(9600);
  scale_x = new Scale<9, 10>([](){scale_x->update();});
  scale_y = new Scale<7, 8>([](){scale_y->update();});
  scale_z = new Scale<3, 4>([](){scale_z->update();});
}

void loop()
{
  if(millis() - timestamp < 10)
    return;
    
  Serial.print(scale_x->getValue(), 3);
  Serial.print(" ");
  Serial.print(scale_y->getValue(), 3);
  Serial.print(" ");
  Serial.print(scale_z->getValue(), 3);
  Serial.print("\n");
  
  timestamp = millis();
}
