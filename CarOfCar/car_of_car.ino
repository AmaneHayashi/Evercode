 #include <IRremote.h>//打开IDE：项目→加载库→添加→搜索IRremote→安装IRredmote库
int RECV_PIN = 11;//红外接收端口
IRrecv irrecv(RECV_PIN);
decode_results results;//结构声明
   
int Left_motor_back=5;     //左电机后退(IN1)
int Left_motor_go=4;     //左电机前进(IN2)

int Right_motor_go=6;    // 右电机前进(IN3)
int Right_motor_back=7;    // 右电机后退(IN4)
   
int EN1=9;//使能端口1  
int EN2=10;//使能端口2  

int TrigPin = 2; 
int EchoPin = 3; 

int i=0;

unsigned int distance;

void setup()  
{  
    

  for (i=4;i<=7;i++) //为Arduino 电机驱动板  
    pinMode(i,OUTPUT); //设置数字端口4,5,6,7为输出模式  
   
  for (i=4;i<=7;i++)   
    digitalWrite(i,HIGH); //设置数字端口4,5,6,7为HIGH,电机保持不动  
   
   
  pinMode(9,OUTPUT);//设置数字端口9 10为输出模式  
  pinMode(10,OUTPUT);  
  digitalWrite(9,HIGH);
  digitalWrite(10,HIGH);
 
  
  //pinMode(13, OUTPUT);//端口模式，输出
  
  
  pinMode(TrigPin, OUTPUT); 
  pinMode(EchoPin, INPUT); 
  
  
  irrecv.enableIRIn();

  Serial.begin(9600);   //波特率9600
}  

void run()     // 前进
{
  digitalWrite(Right_motor_go,HIGH);  // 右电机前进
  digitalWrite(Right_motor_back,LOW);     
  digitalWrite(Left_motor_go,HIGH);  // 左电机前进
  digitalWrite(Left_motor_back,LOW);
}

void brake()         //刹车，停车
{
  digitalWrite(Right_motor_go,LOW);
  digitalWrite(Right_motor_back,LOW);
  digitalWrite(Left_motor_go,LOW);
  digitalWrite(Left_motor_back,LOW);
}

void left()         //左转(左轮不动，右轮前进)
{
  digitalWrite(Right_motor_go,HIGH);    // 右电机前进
  digitalWrite(Right_motor_back,LOW);
  digitalWrite(Left_motor_go,LOW);   //左轮不动
  digitalWrite(Left_motor_back,LOW);
}

void right()        //右转(右轮不动，左轮前进)
{
  digitalWrite(Right_motor_go,LOW);   //右电机不动
  digitalWrite(Right_motor_back,LOW);
  digitalWrite(Left_motor_go,HIGH);//左电机前进
  digitalWrite(Left_motor_back,LOW);
}

void back()          //后退
{
  digitalWrite(Right_motor_go,LOW);  //右轮后退
  digitalWrite(Right_motor_back,HIGH);
  digitalWrite(Left_motor_go,LOW);  //左轮后退
  digitalWrite(Left_motor_back,HIGH);
}


void range() 
{ 
  // 产生一个大于10us的高脉冲去触发TrigPin 
  digitalWrite(TrigPin, LOW); 
  delayMicroseconds(5); 
  digitalWrite(TrigPin, HIGH); 
  delayMicroseconds(15);
  digitalWrite(TrigPin, LOW); 
  int s = pulseIn(EchoPin, HIGH) / 58.00;
  distance=s;
  Serial.print("Distance=");
  Serial.print(distance); 
  Serial.print("cm"); 
  Serial.print('\n'); 
}

void selfmotion()       //自动模式
{
  range();//执行测距函数
  if(distance<30)
  {
    brake();
    delay(300); 
    back();
    delay(300);
    left();
    delay(1200);  
  }
  else
  {
    run();
  }
}

void loop() 
{ 
  //主函数
  if(irrecv.decode(&results))
  {  
    //如果接收到信息
    switch(results.value)
    {
      case 0xFF18E7:  //上,对应前进
      run();
      i=0;
      break;
      case 0xFF4AB5:  //下，对应后退
      back();
      i=0;
      break;
      case 0xFF10EF:  //左，对应左转
      left();
      i=0;
      break;
      case 0xFF5AA5:  //右，对应右转
      right();
      i=0;
      break;
      case 0xFF38C7:  //停止，对应OK
      brake();
      i=0;
      break;
      case 0xFF9867:  //自动行进避障模式，对应0
      i=1;
      break;
      default:
      break;
    }
    irrecv.resume();
  }
  if(i==1)
  {
  //进入自动行进避障模式
  selfmotion();
  }
}

