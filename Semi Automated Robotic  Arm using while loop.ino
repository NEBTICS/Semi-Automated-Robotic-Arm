#include<SoftwareSerial.h>
#include<Servo.h>

Servo myservo1, myservo2, myservo3, myservo4;
SoftwareSerial bluetooth(0, 1);
// int servos1[90], servos2[90], servos3[90],servos4[90];//AUTOMATION
int servop1, servop2, servop3, servop4;

int mot1 = 2;
int mot2 = 4;
int mot3 = 7;
int mot4 = 8;
void setup()
{
  Serial.begin(9600);
  bluetooth.begin(9600);
  myservo1.attach(6);//gripper
  myservo2.attach(5);//shoulder
  myservo3.attach(9);//elbow
  myservo4.attach(3);//base
  pinMode(mot1, OUTPUT); // connect to input 1 of l293d
  pinMode(mot2, OUTPUT); // connect to input 4 of l293d
  pinMode(mot3, OUTPUT); // connect to input 3 of l293d
  pinMode(mot4, OUTPUT); // connect to input 2 of l293d
 myservo1.write(90);//gripper
  myservo2.write(0);//shoulder
  myservo3.write(0);//elbow
  myservo4.write(0);//

}
int base_pos = 0, shoulder_pos = 0, elbow_pos = 0;
void loop()
{
  int data = 0;
  digitalWrite(mot1, LOW); //Initialis
  digitalWrite(mot2, LOW);
  digitalWrite(mot3, LOW);
  digitalWrite(mot4, LOW);

  //  if (bluetooth.available() > 0) //if bluetooth module is transmitting data
  //  {
  //    data = bluetooth.read(); // store the data in pos variable
  //    Serial.println(data);
  //  }
  data = ReceiveData();
  if (data == 70) { //Forward
    do {
      digitalWrite(mot2, HIGH);
      digitalWrite(mot4, HIGH);
      data = ReceiveData();
    } while (data != 102);
  }
  else if (data == 82) { //Right
    do {
      digitalWrite(mot4, HIGH);
      data = ReceiveData();
    } while (data != 114);
  }
  else if (data == 76) { //Left
    do {
      digitalWrite(mot2, HIGH);
      data = ReceiveData();
    } while (data != 108);
  }
  else if (data == 66) { //Back
    do {
      digitalWrite(mot1, HIGH);
      digitalWrite(mot3, HIGH);
      data = ReceiveData();
    } while (data != 98);
  }
  else if (data == 65) {//Base left
    while(data==65) {
      base_pos += 1;
      myservo4.write(base_pos);
      data = ReceiveData();
      if(base_pos<0)
      break;
      delay(150);
    } 
  }
  else if (data == 68) {//Base Right
    while (data == 68) {
      base_pos -= 1;
      myservo4.write(base_pos);
      data = ReceiveData();
      if (base_pos < 0)
        break;
      delay(150);
    }
  }
  else if (data == 83) {//Shoulder down
    while (data == 83) {
      shoulder_pos += 1;
      myservo2.write(shoulder_pos);
      data = ReceiveData();
      if (shoulder_pos < 0)
        break;
      delay(150);
    }
  }
  else if (data == 67) {//Shoulder up
    while (data = 67) {
      shoulder_pos -= 1;
      myservo2.write(shoulder_pos);
      data = ReceiveData();
      if (shoulder_pos < 0)
        break;
      delay(150);
    }
  }

  else if (data == 69) {//Elbow down
    while (data = 69) {
      elbow_pos += 1;
      myservo3.write(elbow_pos);
      if (elbow_pos > 40)
        break;
      data = ReceiveData();
      delay(150);
    }
  }
  else if (data == 85) {//Elbow up
    while (data = 85 ) {
      elbow_pos -= 1;
      myservo3.write(elbow_pos);
      data = ReceiveData();
      if (elbow_pos < 0)
        break;
      delay(150);
    }
  }

  else if (data == 71) {//Gripper close
    myservo1.write(80);
    delay(1000);
    myservo1.write(90);
  }
  else if (data == 79) {//Gripper open
    myservo1.write(100);
    delay(1000);
    myservo1.write(90);
  }

}

int ReceiveData() {
  int data;
  if (bluetooth.available() > 0) //if bluetooth module is transmitting data
  {
    data = bluetooth.read(); // store the data in pos variable
    Serial.println(data);
  }
  return data;
}
