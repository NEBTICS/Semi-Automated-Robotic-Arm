#include <SoftwareSerial.h> 
#include <Servo.h> 
Servo myservo1, myservo2, myservo3,myservo4; //created object of servo motor
SoftwareSerial Bluetooth(0, 1); // pin 0 & 1 use for bluetooth communication 
int servos1[90], servos2[90], servos3[90],servos4[90]; //Define arrays 
int servop1,servop2,servop3,servop4; //Created other variables for storing 
int index = 0; 
void setup() 
{
Serial.begin(9600); //serial communication between bluetooth and arduino
myservo1.attach(3); //servo motor connected to the 3 pwm pin of the arduino
myservo2.attach(5); 
myservo3.attach(6); 
myservo4.attach(9); 
pinMode(2, OUTPUT); // connect to input 1 of l293d 
pinMode(4, OUTPUT); // connect to input 4 of l293d 
pinMode(7, OUTPUT); // connect to input 3 of l293d 
pinMode(8, OUTPUT); // connect to input 2 of l293d 
myservo1.write(90); 
myservo2.write(115); 
myservo3.write(0);  
myservo4.write(90); 
} 
void loop() 
if (Serial.available() >= 2 ) 
{ 
unsigned int servopos = Serial.read(); 
unsigned int servopos1 = Serial.read(); 
unsigned int datareceived = (servopos1 * 256) + servopos; 
if (datareceived >= 1000 && datareceived < 1120) { 
int servo1 = datareceived; 
servo1 = map(servo1, 1080, 1100, 80, 100); 
myservo1.write(servo1); 
servop1=servo1; 
delay(500); 
myservo1.write(90); 
} if (datareceived >= 2000 && datareceived < 2180) { 
int servo2 = datareceived; 
servo2 = map(servo2, 2000, 2180, 0, 180); 
myservo2.write(servo2); 
servop2=servo2; 
delay(10); 
} 
if (datareceived >= 3000 && datareceived < 3180) { 
int servo3 = datareceived; 
servo3 = map(servo3, 3000, 3180, 0, 180); 
myservo3.write(servo3); 
servop3=servo3; 
delay(10); 
} 
if (datareceived >= 4080 && datareceived < 4120) { 
int servo4 = datareceived; 
servo4 = map(servo4, 4080, 4100, 80, 100); 
myservo4.write(servo4); 
servop4=servo4; 
delay(500); 
myservo4.write(90); 
}
if (datareceived >= 100 && datareceived < 110) { 
int save = datareceived; 
servos1[index] = servop1; // save position into the array 
servos2[index] = servop2; 
servos3[index] = servop3; 
servos4[index] = servop4; 
index++; 
}  
if (datareceived >= 400 && datareceived < 410) { 
int reset = datareceived; 
memset(servos1, 0, sizeof(servos1)); // Clear the array data to 0 
memset(servos2, 0, sizeof(servos2)); 
memset(servos3, 0, sizeof(servos3)); 
memset(servos4, 0, sizeof(servos4)); 
index = 0; 
} 
if (datareceived >= 600 && datareceived < 650) 
{ 
int Run = datareceived; 
Run=map(Run,600,650,0,50); 
for(int n=0;n<=2;n++){ 
for (int i = 0; i <= index - 1; i++) 
{ 
myservo1.write(servos1[i]); 
delay(1000); 
myservo1.write(90); 
delay(100); 
myservo2.write(servos2[i]); 
delay(1000); 
myservo3.write(servos3[i]); 
delay(1000); 
myservo4.write(servos4[i]); 
delay(1000); 
myservo4.write(90); 
delay(100); 
}
}
}
if (datareceived >= 9000 && datareceived < 9020) 
{ 
int forward = datareceived; 
forward = map(forward, 9000, 9020, 0, 20); 
digitalWrite(2, HIGH); 
digitalWrite (4, HIGH); 
digitalWrite(7, LOW); 
digitalWrite(8, LOW); 
delay(100); 
} else if (datareceived >= 5000 && datareceived < 5020)
{ 
int back = datareceived; 
back = map(back, 5000, 5020, 0, 20); 
digitalWrite(2, LOW); 
digitalWrite(4, LOW); 
digitalWrite(7, HIGH); 
digitalWrite(8,HIGH); 
}
else
{ 
digitalWrite (2, LOW); 
digitalWrite (4, LOW); 
digitalWrite (7, LOW); 
digitalWrite (8, LOW); 
}
if (datareceived >= 6000 && datareceived < 6020) 
{ 
int left = datareceived; 
left = map(left, 6000, 6020, 0, 20); 
digitalWrite (2, LOW); 
digitalWrite (4, HIGH); 
digitalWrite (7, LOW); 
digitalWrite (8, LOW); 
}
if (datareceived >= 7000 && datareceived < 7020)
{ 
int right = datareceived; 
right = map(right, 7000, 7020, 0, 20); 
digitalWrite (2,HIGH); 
digitalWrite (4,LOW); 
digitalWrite (7,LOW); 
digitalWrite (8,LOW); 
} 
} 
} 
