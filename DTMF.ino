  // Relay Pinouts
const int relay1 = 2;
const int relay2 = 3;

void setup() {
  Serial.begin(9600); 

  // DTMF Decoder Pinouts
  pinMode(8, INPUT);  // STQ pin
  pinMode(9, INPUT);  // Q4 pin
  pinMode(10, INPUT); // Q3 pin
  pinMode(11, INPUT); // Q2 pin
  pinMode(12, INPUT); // Q1 pin

  // Relay Outputs
  pinMode(relay1, OUTPUT);
  pinMode(relay2, OUTPUT);

  // Turn off both relays initially
  digitalWrite(relay1, HIGH);
  digitalWrite(relay2, HIGH);
}

void loop() {
  bool signal = digitalRead(8);  // Validate DTMF signal (STQ pin)

  if (signal == HIGH) {  // If a button is pressed
    delay(50);

    // Debugging
    Serial.print("Q1: ");
    Serial.print(digitalRead(12));
    Serial.print(", Q2: ");
    Serial.print(digitalRead(11));
    Serial.print(", Q3: ");
    Serial.print(digitalRead(10));
    Serial.print(", Q4: ");
    Serial.println(digitalRead(9));

    // Combine the pin readings
    uint8_t number_pressed = (digitalRead(12) << 0) | 
                             (digitalRead(11) << 1) | 
                             (digitalRead(10) << 2) | 
                             (digitalRead(9) << 3);

    Serial.print("Detected Button (Binary): ");
    Serial.println(number_pressed, BIN);

    // Controlling relay based on the detected signal
    switch (number_pressed) {
      case 0x01:
        Serial.println("Button Pressed = 1, Appliance 1 ON");
        digitalWrite(relay1, LOW);  // Turn ON
        break;
      case 0x02:
        Serial.println("Button Pressed = 2, Appliance 1 OFF");
        digitalWrite(relay1, HIGH); // Turn OFF
        break;
      case 0x03:
        Serial.println("Button Pressed = 3, Appliance 2 ON");
        digitalWrite(relay2, LOW);  // Turn ON
        break;
      case 0x04:
        Serial.println("Button Pressed = 4, Appliance 2 OFF");
        digitalWrite(relay2, HIGH); // Turn OFF
        break;
      default:
        Serial.println("Unknown button or misread");
        break;
    }

    delay(300);
  }

  delay(100);
}
