#define POS 1
#define NEG 0
#define CCW 1
#define CW 0

byte stepper0[] = {2, 3, 4, 5};
byte stepper1[] = {6, 7, 8, 9};
byte current_state[] = {0, 0};

void setup() {
  Serial.begin(115200);
  initStepper(stepper0);
  initStepper(stepper1);
}

void loop() {
	int n_steps[2];
	long int stepTime[2];
	bool dir[2];
	
	String data = getCommand();
	
	if(isDigit(data[0])) {
    translateData(data, n_steps, stepTime, dir);
    moveSteppers(n_steps, stepTime, dir);
    respondMaster();
	} else {
   
	}
}

String getCommand() {
	if(Serial.available() > 0) {
		String data = Serial.readString();
		Serial.println(data);
		return data;
	} else {
		return "f";
	}
}

void translateData(String data, int n_steps[2], long int stepTime[2], bool dir[2]) {
	dir[0] = (bool)(data[0] - '0');
	n_steps[0] = (data[1] - '0')*1000 + (data[2]  - '0')*100 + (data[3] - '0')*10 + data[4];
	stepTime[0] = (data[5] - '0')*100000 + (data[6] - '0')*10000 + (data[7] - '0')*1000 + (data[8] - '0')*100 + (data[9] - '0')*10 + (data[10] - '0');
	dir[1] = (bool)(data[11] - '0');
	n_steps[1] = (data[12] - '0')*1000 + (data[13]  - '0')*100 + (data[14] - '0')*10 + data[15];
	stepTime[1] = (data[16] - '0')*100000 + (data[17] - '0')*10000 + (data[18] - '0')*1000 + (data[19] - '0')*100 + (data[20] - '0')*10 + (data[21] - '0');
}

void moveSteppers(int n_steps[2], long int stepTime[2], bool dir[2]) {
	int stepsDone[2] = {0, 0};
	long long int timeStamp[2] = {0, 0};	
	
	timeStamp[0] = micros();
	timeStamp[1] = micros();
	
	while(abs(n_steps[0]) - stepsDone[0] > 0 || abs(n_steps[1]) - stepsDone[1] > 0) {
		if(abs(n_steps[0]) - stepsDone[0] > 0 && micros() - timeStamp[0] >= stepTime[0]) {
			oneStep(stepper0, &current_state[0], dir[0]);
			++stepsDone[0];
      timeStamp[0] = micros();
		}
		if(abs(n_steps[1]) - stepsDone[1] > 0 && micros() - timeStamp[1] >= stepTime[1]) {
			oneStep(stepper1, &current_state[1], dir[1]);
			++stepsDone[1];		
      timeStamp[1] = micros();
		}		
	}
}

void respondMaster() {
	Serial.write('z');
}

void oneStep(byte pin[4], byte* current_state, bool dir) {
  if(dir == POS){  
    switch(*current_state) {
      case 0:
        *current_state = 3;
        break;
      case 1:
        *current_state = 0;
        break;
      case 2:
        *current_state = 1;
        break;
      case 3:
        *current_state = 2;
        break;
    }
  } else if(dir == NEG) {
    switch(*current_state) {
      case 0:
        *current_state = 1;
        break;
      case 1:
        *current_state = 2;
        break;
      case 2:
        *current_state = 3;
        break;
      case 3:
        *current_state = 0;
        break;
    }
  }
  switch(*current_state) {
    case 0:
      digitalWrite(pin[0], HIGH);
      digitalWrite(pin[1], LOW);
      digitalWrite(pin[2], LOW);
      digitalWrite(pin[3], HIGH);
      break;
    case 1:
      digitalWrite(pin[0], HIGH);
      digitalWrite(pin[1], HIGH);
      digitalWrite(pin[2], LOW);
      digitalWrite(pin[3], LOW);
      break;
    case 2:
      digitalWrite(pin[0], LOW);
      digitalWrite(pin[1], HIGH);
      digitalWrite(pin[2], HIGH);
      digitalWrite(pin[3], LOW);
      break;
    case 3:
      digitalWrite(pin[0], LOW);
      digitalWrite(pin[1], LOW);
      digitalWrite(pin[2], HIGH);
      digitalWrite(pin[3], HIGH);
      break;
  }
}

void initStepper(byte in[4]) {
	pinMode(in[0], OUTPUT);
	pinMode(in[1], OUTPUT);
	pinMode(in[2], OUTPUT);
	pinMode(in[3], OUTPUT);
	digitalWrite(in[0], HIGH);
	digitalWrite(in[1], LOW);
	digitalWrite(in[2], LOW);
	digitalWrite(in[3], HIGH);
	delay(100);
}
