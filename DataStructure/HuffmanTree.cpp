/*利用二叉树结构实现哈夫曼编/解码器。
基本要求：
1、	初始化(Init)：能够对输入的任意长度的字符串s进行统计，统计每个字符的频度，并建立赫夫曼树
2、	建立编码表(CreateTable)：利用已经建好的赫夫曼树进行编码，并将每个字符的编码输出。
3、	编码(Encoding)：根据编码表对输入的字符串进行编码，并将编码后的字符串输出。
4、	译码(Decoding)：利用已经建好的赫夫曼树对编码后的字符串进行译码，并输出译码结果。
5、	打印(Print)：以直观的方式打印赫夫曼树（选作）
6、	计算输入的字符串编码前和编码后的长度，并进行分析，讨论赫夫曼编码的压缩效果。*/

#include"stdafx.h"
#include<iostream>
#include<string>
#include<iomanip>
#define N 10
using namespace std;

struct HNode
{
	int weight;//结点权值
	int parent;//双亲指针
	int LChild;//左孩子指针
	int RChild;//右孩子指针
};
//静态三叉链表，构造哈夫曼树
struct HCode
{
	char data;
	char code[100];
};
//哈夫曼编码表
class Huffman
{
private:
	HNode * HTree;//哈夫曼树
	HCode * HCodeTable;//哈夫曼树编码表
	char str[1024];//输入的字符串
	char leaf[256];//叶子结点数组
	int a[256];//记录每个出现的字符的次数
public:
	int n;//结点数
	int s1;//字符串长度
	void Init();//初始化函数
	void CreateHTree();//创建哈夫曼树
	void Selectmin(int &x, int &y, int s, int e);//寻找权值最小函数
	void CreateCodeTable();//创建编码表
	void Reverse(char d[]);//逆置函数
	void Encode(string *d);//编码
	void Decode(char *s, char *d);//解码
	void Printcode();//打印
	~Huffman();//析构函数
};


void Huffman::Init()
{
	int nNum[256] = {0};//初始化原始次数数组
	int ch = cin.get();//准备开始cin
	int i = 0;//初始化
	while((ch!='\r')&&(ch!='\n'))//while循环进入cin，当字符不为空（换行）
	{
		nNum[ch]++;//统计字符出现的次数
		str[i++]=ch;//记录原始字符串
		ch=cin.get();//继续读取
	}
	str[i]='\0';//读到空时，结束循环
	n = 0;//初始化
	for(i = 0;i<256;i++)//for循环进入过滤操作
	{
		if(nNum[i]>0)//如果某字符出现过
		{
			leaf[n]=(char)i;//通过leaf[n]得到过滤后的数组
			a[n]=nNum[i];//通过a[n]得到过滤后数组的出现次数
			n++;//循环
		}
	}
	s1 = strlen(str);//获取输入字符串长度
}

//初始化

void Huffman::Selectmin(int &x, int &y, int s, int e)
{
	int i;
	for (i = s;i <= e;i++)
	{
		if (HTree[i].parent == -1)
		{
			x = y = i;
			break;//找出第一个有效权值x
		}
	}
	for (i = s;i < e;i++)
	{
		if (HTree[i].parent == -1)//该权值未使用过
		{
			if (HTree[i].weight < HTree[x].weight)
			{
				y = x;
				x = i;//迭代
			}
			else if ((x == y) || (HTree[i].weight < HTree[y].weight))
				y = i;//找出次小值y
		}
	}
}
//选择最小值与次小值

void Huffman::CreateHTree()
{
	HTree = new HNode [2*n-1];//新建哈夫曼树
	for(int i = 0; i<n;i++)
	{
		HTree[i].weight = a[i];
		HTree[i].LChild = HTree[i].RChild = HTree[i].parent = -1;//初始化
	}
	int x,y;
	for(int i=n;i<2*n-1;i++)//哈夫曼树的建立
	{
		Selectmin(x,y,0,i);
		HTree[x].parent = HTree[y].parent = i;//分支
		HTree[i].weight = HTree[x].weight + HTree[y].weight;//权值
		HTree[i].LChild = x;//左孩子
		HTree[i].RChild = y;//右孩子
		HTree[i].parent = -1;//父结点
	}
}
//哈夫曼树的创建

void Huffman::CreateCodeTable()
{
	HCodeTable = new HCode[n];
	for (int i = 0; i < n; i++)//初始化编码表
		for (int j = 0; j < 100; j++)
			HCodeTable[i].code[j] = '\0';
	for(int i = 0; i < n ; i++)
	{
		HCodeTable[i].data = leaf[i];
		int child = i;
		int parent = HTree[i].parent;
		int k=0;
		while(parent!=-1)
		{
			if(child==HTree[parent].LChild)
				HCodeTable[i].code[k] = '0';//左孩子赋值0
			else
				HCodeTable[i].code[k] = '1';//右孩子赋值1
			k++;
			child = parent;
			parent = HTree[child].parent;
		}
		HCodeTable[i].code[k] = '\0';//末位置空
		Reverse(HCodeTable[i].code);//逆置函数
	}

	cout << "\n打印的哈夫曼编码表如下：\n";
	for (int i = 0; i < n; i++)//输出编码表
	{
		cout<<HCodeTable[i].data << "  " << HCodeTable[i].code << endl;
	}
}

//编码表的创建

void Huffman::Reverse(char d[])
{
	int m=0;
	char temp;
	while(d[m+1]!='\0')
		m++;//记录非空次数
	for(int i=0;i<=m/2;i++)
	{
		temp=d[i];
		d[i]=d[m-i];
		d[m-i]=temp;//利用工作变量实现交换
	}
}
//逆置函数

void Huffman::Encode(string *d)//d为编码记录串
{
	char*s = str;//字符串指针指向第一个字符
    float sum=0;//统计字节数
	while(*s!='\0')
	{
		for(int i=0;i<n;i++)
		{
			if(*s==HCodeTable[i].data)//比较编码值
			{
				for(int j=0;HCodeTable[i].code[j]!='\0';j++)
				{
					*d+=HCodeTable[i].code[j];//字符串连接
					sum+=1;//编码长度统计
				}
				s++;
				break;
			}
		}
	}
	cout<<"\n编码前长度："<<8*s1<<endl;
	cout<<"\n编码后的长度："<<sum<<endl;
	cout<<"\n压缩比为："<<8*s1/sum<<endl;
}

//编码操作


void Huffman::Decode(char *s, char *d)//s为编码串,d为解码串
{
	while(*s!='\0')
	{
		int parent = 2 * n - 2;
		while(HTree[parent].LChild!=-1)//如果不是叶子结点
		{
			if( *s == '0')
				parent = HTree[parent].LChild;//值为0对应左孩子
			else
				parent = HTree[parent].RChild;//值为1对应右孩子
			s++;
		}
		*d = HCodeTable[parent].data;//顺次记录
		d++;
	}
}

//解码操作

void Huffman::Printcode()
{
	cout<<"\n打印的哈夫曼树如下：\n"<<setiosflags(ios::left)<<setw(6)<<"n"<<setw(10)<<"weight"<<setw(10)<<"lchild"<<
	setw(10)<<"rchild"<<setw(10)<<"parent"<<setw(10)<<"char"<<setw(10)<<"code"<<endl; 
	
	for(int i=0;i<2*n-1;i++)
	{
		if(i<n) 
		{
			cout<<setiosflags(ios::left)<<setw(6)<<i<<setw(10)<<HTree[i].weight<<setw(10)<<HTree[i].LChild<<
				setw(10)<<HTree[i].RChild<<setw(10)<<HTree[i].parent<<setw(10)<<HCodeTable[i].data<<setw(10)<<HCodeTable[i].code<<endl;
		}
		else
		{
			cout<<setiosflags(ios::left)<<setw(6)<<i<<setw(10)<<HTree[i].weight<<setw(10)<<HTree[i].LChild<<
				setw(10)<<HTree[i].RChild<<setw(10)<<HTree[i].parent<<setw(10)<<"无"<<setw(10)<<"无"<<endl;
		}                      
	}
}

//哈夫曼树的打印

Huffman::~Huffman()
{
	delete []HTree;
	delete []HCodeTable;
}

//哈夫曼树的析构

void main()
{
	cout<<"*********************欢迎使用哈夫曼树转换工具！请输入您需要转化的字符串*********************\n"<<endl;
	Huffman HTest;
	HTest.Init();

	HTest.CreateHTree();
	HTest.CreateCodeTable();
	HTest.Printcode();

	string st="";
	HTest.Encode(&st);
	cout << "\n编码结果:" <<st<< endl;

	char d[65535]={'\0'};
	char *s=&st[0];
	HTest.Decode(s,d);
	cout << "\n解码结果:" << d << endl;
}
