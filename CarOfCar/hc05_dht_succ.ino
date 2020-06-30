#include<Wire.h>
int i=0;
int humi;//定义湿度
int tol;//定义校对码
int temp;//定义温度
int j;//定义变量
unsigned int loopCnt;
int chr[40] = {0};//创建数字数组，用来存放40个bit
unsigned long time;
#define pin 2//定义DHT11引脚号

void setup()
{
  Serial.begin(38400);//设置串口波特率38400
  pinMode(13, OUTPUT);
}
void loop()
{
  bgn:

  delay(2000);
  pinMode(pin,OUTPUT);
  digitalWrite(pin,LOW);
  delay(20);
  digitalWrite(pin,HIGH);
  delayMicroseconds(40);
  digitalWrite(pin,LOW);//设置2号接口模式：输入
  pinMode(pin,INPUT);
  //高电平响应信号
  loopCnt=10000;

  while(digitalRead(pin) != HIGH)
  {
    if(loopCnt-- == 0)
    {
      //如果长时间不返回高电平，输出个提示，重头开始。
      Serial.println("HIGH");
      goto bgn;
    }
  }
  //低电平响应信号
  loopCnt=30000;
  while(digitalRead(pin) != LOW)
  {
    if(loopCnt-- == 0)
    {
      //如果长时间不返回低电平，输出个提示，重头开始。
      Serial.println("LOW");
      goto bgn;
    }
  }
  //开始读取bit1-40的数值 
  for(int i=0;i<40;i++)
  {
    while(digitalRead(pin) == LOW)
    {
      
    }
    time = micros();
    while(digitalRead(pin) == HIGH)
    {
      
    }
    //当出现低电平，记下时间，再减去刚才储存的time
    //得出的值若大于50μs，则为‘1’，否则为‘0’
    //并储存到数组里去
    if (micros() - time >50)
    {
      chr[i]=1;
    } 
    else
    {
      chr[i]=0; 
    }
  }
  
  //湿度，8位的bit，转换为数值
  humi=chr[0]*128+chr[1]*64+chr[2]*32+chr[3]*16+chr[4]*8+chr[5]*4+chr[6]*2+chr[7];

  //温度，8位的bit，转换为数值
  temp=chr[16]*128+chr[17]*64+chr[18]*32+chr[19]*16+chr[20]*8+chr[21]*4+chr[22]*2+chr[23];

  //校对码，8位的bit，转换为数值
  tol=chr[32]*128+chr[33]*64+chr[34]*32+chr[35]*16+chr[36]*8+chr[37]*4+chr[38]*2+chr[39];
  
  //输出：温度、湿度、校对码
  
  if((temp>=32)||(humi<=20))
    Serial.print("DANGER!\n");
  else
  {
    Serial.print("temp:");
    Serial.println(temp);
    Serial.print("humi:");
    Serial.print(humi);
    Serial.println("%RH");
    Serial.print("tol:");
    Serial.print(tol);
    Serial.print("\n");
  }
  while(Serial.available())
  {
    char c=Serial.read();
    if(c=='1')
    {
      digitalWrite(13, HIGH);
    }
    if(c=='2')
    {
      digitalWrite(13, LOW);
    }
  }
}
