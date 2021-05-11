/*
  Quadrature Decoder
*/
#include "Arduino.h"
#include <digitalWriteFast.h>

#define INT_XA 0
#define INT_XB 1
#define XA 2
#define XB 3

#define YA 5
#define YB 6

volatile bool xa_val;
volatile bool xa_prev;
volatile bool xb_val;
volatile bool xb_prev;
float x_counter;
float x_counter_prev;

volatile bool ya_val;
volatile bool ya_prev;
volatile bool yb_val;
volatile bool yb_prev;
float y_counter;
float y_counter_prev;


void setup()
{
  Serial.begin(9600);
  
  // init quadrature encoder pins
  pinMode(XA, INPUT);
  pinMode(XB, INPUT);
  attachInterrupt(INT_XA, scaleIntX, CHANGE);
  attachInterrupt(INT_XB, scaleIntX, CHANGE);
  
  pinMode(YA, INPUT);
  pinMode(YB, INPUT);


  // Enable all ports for PCI 
  PCICR  |= 0b00000111;
  // Enable PCINT21 (Pin5), PCINT22 (Pin6) for PCI
  PCMSK2 |= 0b01100000;
  

  // init vals
  xa_val = digitalReadFast(XA);
  xa_prev = xa_val;
  xb_val = digitalReadFast(XB);
  xb_prev = xb_val;
  x_counter = 0;
  x_counter_prev = 0;

  ya_val = digitalReadFast(YA);
  ya_prev = ya_val;
  yb_val = digitalReadFast(YB);
  yb_prev = yb_val;
  y_counter = 0;
  y_counter_prev = 0;
}

void loop()
{
  Serial.print(x_counter * 0.005, 3);
  Serial.print(" ");
  Serial.print(y_counter * 0.005, 3);
  Serial.print("\n");

  x_counter_prev = x_counter;
  y_counter_prev = y_counter;
}

void scaleIntX() {
  xb_val = digitalReadFast(XB);
  xa_val = digitalReadFast(XA);

  x_counter += parseQuadSignal();

  xa_prev = xa_val;
  xb_prev = xb_val;
}

ISR(PCINT2_vect)
{
  yb_val = digitalReadFast(YB);
  ya_val = digitalReadFast(YA);

  y_counter += yParseQuadSignal();

  ya_prev = ya_val;
  yb_prev = yb_val;
}


int parseQuadSignal() {
  if (xa_prev && xb_prev) {
    if (!xa_val && xb_val) return 1;
    if (xa_val && !xb_val) return -1;
  } else if (!xa_prev && xb_prev) {
    if (!xa_val && !xb_val) return 1;
    if (xa_val && xb_val) return -1;
  } else if (!xa_prev && !xb_prev) {
    if (xa_val && !xb_val) return 1;
    if (!xa_val && xb_val) return -1;
  } else if (xa_prev && !xb_prev) {
    if (xa_val && xb_val) return 1;
    if (!xa_val && !xb_val) return -1;
  }
}

int yParseQuadSignal() {
  if (ya_prev && yb_prev) {
    if (!ya_val && yb_val) return 1;
    if (ya_val && !yb_val) return -1;
  } else if (!ya_prev && yb_prev) {
    if (!ya_val && !yb_val) return 1;
    if (ya_val && yb_val) return -1;
  } else if (!ya_prev && !yb_prev) {
    if (ya_val && !yb_val) return 1;
    if (!ya_val && yb_val) return -1;
  } else if (ya_prev && !yb_prev) {
    if (ya_val && yb_val) return 1;
    if (!ya_val && !yb_val) return -1;
  }
}
