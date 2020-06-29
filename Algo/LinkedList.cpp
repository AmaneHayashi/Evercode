#include "stdafx.h"
#include "stdafx.h"
#include<iostream>
using namespace std;
template <class T>

struct Node
{
	T data;
	struct Node<T> * next; 
};
//使用结构类型定义带头结点的单链表

template <class T>
class LinkList
{
public:
	LinkList()//无参
	{
		front = new Node<T>;
	    front-> next = NULL;
	}
//构造空单链表，时间复杂度O（1）

	LinkList(T a[],int n);//有参
	LinkList(const LinkList&List);//复制
    void Insert(int i,T x);//插入
    T Delete(Node<T> * p);//删除，返回删除的数据
	Node <T> * Get(int i);//按位查找，查找第i个元素，返回元素地址
	int Locate(T x);//按值查找，查找值为x的元素，返回元素序号
	int GetLength();//长度
	void PrintList();//打印
    ~LinkList();//析构
private:
    Node<T> * front;
	int length;
};

/*
template<class T>
LinkList <T>::LinkList(T a[], int n)
{
	front=new Node <T>;
	front ->next = NULL;
	for(int i=n-1;i>=0;i--)
	{
		Node<T> * s = new Node <T>; 
		s->data = a[i];
		s->next = front -> next;
		front->next = s; 
	}
	length=n;
}
//头插法构造链表，时间复杂度O（n）,s为新指针
*/

template<class T>
LinkList<T>::LinkList(T a[], int n) 
{
	front = new Node<T>;
	Node<T> * r= front;
	for (int i=0;i<n;i++)
	{
		Node<T> * s =new Node <T>;
		s -> data=a[i];
		r -> next=s;
		r = s;
	}
	 r -> next=NULL;
	 length=n;
}

//尾插法构造链表，时间复杂度O（n）,r为尾指针，s为新指针

template <class T> 
int LinkList<T>::GetLength()
{
    return length;
}

//获取链表长度，时间复杂度O（1）

template <class T>
LinkList<T>::LinkList(const LinkList& List)
{
    first = new Node<T>;
    first ->next =NULL;
    for(int i=List.GetLength(),i>0;i++)
	{
		Node<T> * s=new Node<T>;
		s ->data=List.Get(i)->data;
		s ->next=first ->next;
		first ->next=s;
	}
}

//复制构造函数，时间复杂度O（n）。先提取List的每个节点上的data，再利用头插法，将List的数据依次插到LinkList的头结点后面。

template<class T>
void LinkList<T>::Insert(int i,T x)
{
	Node <T> * p=front;
	if(i!=1) p=Get(i-1);//若不是在第一个位置插入，得到第i-1个元素的地址
	if(p!=NULL){
		Node<T> * s =new Node<T>;
		s ->data=x;
		s ->next=p->next;
		p ->next=s;//新结点插入p所指的结点之后
		length++;
	}
	else 
		throw"插入位置错误";
}

//插入元素，时间复杂度O（n）

template<class T>
T LinkList<T>::Delete(Node<T> * p)
{
	T x = p ->data;
	Node<T> * q = p ->next;
	p ->next=q ->next;
	p ->data=q ->data;
	delete p;
	length--;
	return x;
}

//删除结点，时间复杂度O（1）.在已知结点的后面插入新结点，将已知结点的data域（与值）赋给新的data域（与值），最后删除p。

template<class T>
Node<T> * LinkList<T>::Get(int i)//获取元素
{
	Node<T> * p =front ->next;
	int j =1;
	while(p&&(j !=i))
	{
		p = p ->next;
		j++;
	}
	return p;
}

//按位查找元素，时间复杂度O（n）

template<class T>
int LinkList<T>::Locate(T x)
{
	Node<T> * p =front ->next;
	int j=1;
	while(p)
	{
		if(p ->data ==x) return j;
		p= p ->next;
		j++;
	}
	return -1;
}

//按值查找元素，时间复杂度O（n）

template<class T>
void LinkList<T>::PrintList()
{
	Node<T> * p =front;
	while (p->next)
	{
		cout << p->next->data << " ";
		p = p->next;
	}
	cout<<endl;
}

//打印链表，时间复杂度O（n）

template<class T>
LinkList<T>::~LinkList()
{
	Node<T> * p =front ->next;
	while(p)
	{
		front = p;//暂存结点
		p = p ->next;//移动指针
		delete front;//释放指针
	}
}

//析构函数，时间复杂度O（n）

int main()
{
	int a[9]={1,2,3,4,5,6,7,8,9};
	LinkList<int>list(a,9);                                                                                                                                            
	cout<<"获取链表长度"<<endl;
	cout<<list.GetLength()<<endl;                                   
	cout<<"获取数据5的位置"<<endl;
	cout<<list.Get(5)<<endl;
	cout<<"打印链表" <<endl;
	list.PrintList();
	cout<<"找位置为7的值"<<endl;
	cout<<list.Locate(7)<<endl;
	cout<<"在位置5插入12"<<endl;
	list.Insert(5,12) ;
	list.PrintList();
	list.~LinkList();
	system("pause");
	return 0;
}
