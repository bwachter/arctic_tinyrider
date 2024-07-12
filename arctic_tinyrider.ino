#include <IBusBM.h>
#include <Servo.h>

/*
 The further you go down the defines the less likely you should
 want to change something.

 Channel numbers are C indexes, i.e., one less than your transmitter
 shows you.

 PWM values are based on the servo library, ranging from 0 to 180 - not
 the native 0-255 of Arduino PWM (which is a wrong frequency).
*/

//#define ESC_PWM_REVERSED 1

// the digital pin the motor is attached to
#define MOTOR_PIN 3

// the digital pin the servo is attached to
#define SERVO_PIN 10

// arduino can tolerate about 20µA per pin, with a total of 200µA
// a bright 5mm LED draws roughly 20µA - so three sets of two LEDs
// should be safe. If you need more connect them to power directly,
// and trigger them via transistor

// the power LEDs also serve as back lights
#define POWER_LED 13
#define POWER_LEDS {2,13}
#define FRONT_LEDS {11,12}
#define EFFECT_LEDS {4,5}

// this should be a three state switch, and needs to be setup as aux channel
// comment this definition if you don't want that feature
#define CONTROL_CHANNEL 7

// a two state switch, preventing throttle to engage unless switched on
// comment this definition if you don't want that feature
#define IGNITION_CHANNEL 6

#define EFFECT_CHANNEL 5

/*
  This configures an input (default: VRA on channel 5) to adjust the speed
  curve.

  The speed curve itself needs adjustment below and recompilation to change.
  Default settings have roughly half the maximum speed with VRA on zero, going
  up to full speed with VRA on max.

  Comment the SPEED_CHANNEL definition if you don't want that.
*/
#define SPEED_CHANNEL 4
#define SPEED_MIN 90
#define SPEED_MAX 180

// time LED should remain in a specific status. This is per loop - so
// take LOOP_DELAY into account as well.
#define LED_DELAY 10
// slightly delays the loop to allow time for mechanical elements to
// move, at cost of slight input delay.
#define LOOP_DELAY 20

#define PWM_MIN 0
#define PWM_MAX 180

// with trim the values sent by the transmitter might be over/under this range,
// but this is good enough for now
#define RX_MIN 1000
#define RX_MAX 2000

IBusBM IBus;
Servo steeringServo;
Servo motor;
int ignition=1000;
int led_state=0;
int throttle_channel;
int steering_channel;
int failsafe_channel;
int reverse_channel;

int power_leds[]=POWER_LEDS;
int front_leds[]=FRONT_LEDS;
int effect_leds[]=EFFECT_LEDS;

enum led_effects{
  led_on,
  led_off,
  led_cycle
};

void setup_controls(){
#ifdef CONTROL_CHANNEL
  int controls = IBus.readChannel(CONTROL_CHANNEL);
#else
  int controls = 1000;
#endif
  if (controls == 1500){
    // throttle right, steering left
    throttle_channel=1;
    steering_channel=3;
    failsafe_channel=0;
    reverse_channel=2;
  } else if (controls == 2000) {
    // throttle and steering right
    throttle_channel=1;
    steering_channel=0;
    failsafe_channel=3;
    reverse_channel=2;
  } else {
    // default, throttle on the left, steering right
    throttle_channel=2;
    steering_channel=0;
    failsafe_channel=3;
    reverse_channel=1;
  }
}

void set_led(int leds[], int cycle, int effect){
  switch(effect){
    case led_on:
      digitalWrite(leds[0], HIGH);
      digitalWrite(leds[1], HIGH);
      break;
    case led_off:
      digitalWrite(leds[0], LOW);
      digitalWrite(leds[1], LOW);
      break;
    case led_cycle:
      if (cycle < 0){
        digitalWrite(leds[0], LOW);
        digitalWrite(leds[1], LOW);
      } else {
        digitalWrite(leds[0], HIGH);
        digitalWrite(leds[1], HIGH);
      }
      break;
  }
}

void setup() {
  pinMode(POWER_LED, OUTPUT);
  IBus.begin(Serial);
  steeringServo.attach(SERVO_PIN);
  motor.attach(MOTOR_PIN, 1000, 2000);
  motor.write(0);
  setup_controls();
}

void loop() {
  if (led_state >= LED_DELAY)
    led_state = LED_DELAY*-1;
  led_state++;

  setup_controls();

  int steer;
  steer = IBus.readChannel(steering_channel);
  Serial.print("Steer: ");
  Serial.print(steer);
  if (steer >= 1000 and steer <= 2000)
    steeringServo.writeMicroseconds(steer);
  else
    steeringServo.writeMicroseconds(1500);

#ifdef IGNITION_CHANNEL
  ignition = IBus.readChannel(IGNITION_CHANNEL);
  if (ignition != 2000){
    motor.write(0);

    set_led(power_leds, led_state, led_cycle);
  } else {
#endif
    set_led(power_leds, led_state, led_on);
    int throttle;
    throttle = IBus.readChannel(throttle_channel);
    Serial.print(" Throttle: ");
    Serial.print(throttle);
    int pwm = map(throttle, RX_MIN, RX_MAX, PWM_MIN, PWM_MAX);
    Serial.print(" ");
    Serial.print(pwm);
#ifdef SPEED_CHANNEL
    int pwm_max_raw = IBus.readChannel(SPEED_CHANNEL);
    int pwm_max = map(pwm_max_raw, RX_MIN, RX_MAX, SPEED_MIN, SPEED_MAX);
    int pwm_adjusted = map(throttle, RX_MIN, RX_MAX, PWM_MIN, pwm_max);
    Serial.print(" adjusted ");
    Serial.print(pwm_adjusted);
    motor.write(pwm_adjusted);
#else
    motor.write(pwm);
#endif
#ifdef IGNITION_CHANNEL
  }
#endif

  int failsafe = IBus.readChannel(failsafe_channel);
  Serial.print(" failsafe ");
  Serial.print(failsafe);
  Serial.println();

  delay(LOOP_DELAY);
}
