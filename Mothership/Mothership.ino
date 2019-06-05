
#include <avr/sleep.h>

#define FASTLED_INTERRUPT_RETRY_COUNT 1
#include <FastLED.h>

#define LED_PIN     10
#define COLOR_ORDER GRB
#define CHIPSET     WS2811
#define NUM_LEDS    2

#define BRIGHTNESS  200
#define FRAMES_PER_SECOND 60

#define IDLE_TIMEOUT 30000

#define STATE_IDLE 0
#define STATE_SLEEP 1
#define STATE_SHAKE 2
#define STATE_SHOW 3
#define STATE_BLACKBALL 4

bool gReverseDirection = false;

long idle_timer = 0;
int state = STATE_SLEEP;
boolean blackball = false;

CRGB leds[NUM_LEDS];
CRGB ball_colors[] = {CRGB::Black, CRGB::Blue, CRGB::Red, CRGB::Yellow};
CRGB colors[] = {CRGB::Black, CRGB::Black};

CRGBPalette16 gPal;

void setup() {
  delay(3000); // sanity delay
  FastLED.addLeds<CHIPSET, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection( TypicalLEDStrip );
  FastLED.setBrightness( BRIGHTNESS );

  // Flash to show power on
  for ( int i = 0; i < NUM_LEDS; i++) {
    leds[i] = CRGB::Green;
  }
  FastLED.show(); 

  FastLED.delay(1000 );
  
  pinMode(3, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(3), shaken, LOW);
  
  // We'll reset this on shake
  gPal = CRGBPalette16( CRGB::Blue, CRGB::Aqua,  CRGB::White);
}

void loop()
{
  // Add entropy to random number generator; we use a lot of it.
  random16_add_entropy( random());
  
  static int fade;
  switch(state)
  {
    case STATE_SHAKE:
      shake();
      fade = 0;
      break;
   
   
    case STATE_IDLE:
      if(blackball)
        Fire2012WithPalette(); // run simulation frame, using palette colors
      else
        pulse();

      if(idle_timer && (idle_timer - millis()) < 5000 && fade < 256)
      {
        fade+=1;
      }
      leds[0].fadeToBlackBy(fade);
      leds[1].fadeToBlackBy(fade);
      
      FastLED.show(); // display this frame
      if(idle_timer && idle_timer < millis()) {
        Serial.println("Sleepy time");
        sleep();
      }
      break;
     case STATE_SLEEP:
      idle_timer = millis() + IDLE_TIMEOUT;
      state = STATE_IDLE;
      break;
  }
  
  
  FastLED.delay(1000 / FRAMES_PER_SECOND);
}

void shaken()
{
  state = STATE_SHAKE;
}
void shake()
{
  idle_timer = 0;
  
  // Determine colors
  getColors();

  if(!blackball) {
    show();
  }
  // Set a timeout for idle / shutdown
  state = STATE_SLEEP;
}

void show() {
  // Show
  for(int i = 0; i < NUM_LEDS; i++) {
    leds[i] = colors[i];
  }
  FastLED.show();
  FastLED.delay(5000);
}
void getColors()
{
  randomSeed(millis());
  int rand;
  colors[0] = ball_colors[random(0,4)];
  
  // Make sure second isn't the same
  do
  {
    colors[1] = ball_colors[random(0,4)];
  } while(colors[0] == colors[1]);

  if(colors[0] == ball_colors[0] || colors[1] == ball_colors[0])
  {
    blackball = true;
    gPal = CRGBPalette16( CRGB::Black, CRGB::Purple, CRGB::BlueViolet, CRGB::DarkOrchid);
  }
  else
  {
    blackball = false;
    gPal = CRGBPalette16( colors[0], colors[1]);
  }
}

/**
 * Turn things off, go to sleep
 */
void sleep()
{
  leds[0] = CRGB::Black;
  leds[1] = CRGB::Black;
  FastLED.show();
  FastLED.delay(1000);
  
  state = STATE_SHAKE;
  sleep_enable();
  set_sleep_mode(SLEEP_MODE_PWR_DOWN);
  sleep_cpu();
}
// Fire2012 by Mark Kriegsman, July 2012
// as part of "Five Elements" shown here: http://youtu.be/knWiGsmgycY
////
// This basic one-dimensional 'fire' simulation works roughly as follows:
// There's a underlying array of 'heat' cells, that model the temperature
// at each point along the line.  Every cycle through the simulation,
// four steps are performed:
//  1) All cells cool down a little bit, losing heat to the air
//  2) The heat from each cell drifts 'up' and diffuses a little
//  3) Sometimes randomly new 'sparks' of heat are added at the bottom
//  4) The heat from each cell is rendered as a color into the leds array
//     The heat-to-color mapping uses a black-body radiation approximation.
//
// Temperature is in arbitrary units from 0 (cold black) to 255 (white hot).
//
// This simulation scales it self a bit depending on NUM_LEDS; it should look
// "OK" on anywhere from 20 to 100 LEDs without too much tweaking.
//
// I recommend running this simulation at anywhere from 30-100 frames per second,
// meaning an interframe delay of about 10-35 milliseconds.
//
// Looks best on a high-density LED setup (60+ pixels/meter).
//
//
// There are two main parameters you can play with to control the look and
// feel of your fire: COOLING (used in step 1 above), and SPARKING (used
// in step 3 above).
//
// COOLING: How much does the air cool as it rises?
// Less cooling = taller flames.  More cooling = shorter flames.
// Default 55, suggested range 20-100
#define COOLING  55

// SPARKING: What chance (out of 255) is there that a new spark will be lit?
// Higher chance = more roaring fire.  Lower chance = more flickery fire.
// Default 120, suggested range 50-200.
#define SPARKING 120


void Fire2012WithPalette()
{
  // Array of temperature readings at each simulation cell
  static byte heat[NUM_LEDS];

  // Step 1.  Cool down every cell a little
  for ( int i = 0; i < NUM_LEDS; i++) {
    heat[i] = qsub8( heat[i],  random8(0, ((COOLING * 10) / NUM_LEDS) + 2));
  }

  // Step 2.  Heat from each cell drifts 'up' and diffuses a little
  for ( int k = NUM_LEDS - 1; k >= 2; k--) {
    heat[k] = (heat[k - 1] + heat[k - 2] + heat[k - 2] ) / 3;
  }

  // Step 3.  Randomly ignite new 'sparks' of heat near the bottom
  if ( random8() < SPARKING ) {
    int y = random8(7);
    heat[y] = qadd8( heat[y], random8(160, 255) );
  }

  // Step 4.  Map from heat cells to LED colors
  for ( int j = 0; j < NUM_LEDS; j++) {
    // Scale the heat value from 0-255 down to 0-240
    // for best results with color palettes.
    byte colorindex = scale8( heat[j], 240);
    CRGB color = ColorFromPalette( gPal, colorindex);
    int pixelnumber;
    if ( gReverseDirection ) {
      pixelnumber = (NUM_LEDS - 1) - j;
    } else {
      pixelnumber = j;
    }
    leds[pixelnumber] = color;
  }
}

uint8_t hueA = 66;  // Start hue at valueMin.
uint8_t satA = 200;  // Start saturation at valueMin.
float valueMin = 0.0;  // Pulse minimum value (Should be less then valueMax).

uint8_t hueB = 83;  // End hue at valueMax.
uint8_t satB = 255;  // End saturation at valueMax.
float valueMax = 200.0;  // Pulse maximum value (Should be larger then valueMin).
static float delta = (valueMax - valueMin) / 2.35040238;  // Do Not Edit

void pulse()
{
  float pulseSpeed = 4;
  float dV = ((exp(sin(pulseSpeed * millis()/2000.0*PI)) -0.36787944) * delta);
  float val = valueMin + dV;
  Serial.print("val: "); Serial.println(val);
  float sat = map(val, valueMin, valueMax, satA, satB);  // Map sat based on current val

  for (int i = 0; i < NUM_LEDS; i++) {
    leds[i] = colors[i];
    leds[i].subtractFromRGB(val);
  }
}

