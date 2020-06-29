#include "stdafx.h"

#include <iostream>
#include <stack>
using namespace std;
template <class T>
 struct Node
 {
		T data;
		Node<T>* lch;
		Node<T>* rch;
 };
 //创建二叉链表

template <class T> 
class BiTree
{
private:
    Node<T> *root;//根节点
	void Create (Node<T>* &R, T data[], int i, int n);//创建二叉树
	BiTree(BiTree<T>&t);//复制二叉树
    void Release(Node<T> *R);//释放二叉树
public:
	BiTree():root(NULL){}//无参构造函数
    BiTree(T data[],int n);//构造函数
	void Create(Node<T> **R, T data[]);//创建二叉树
	void CopyTree(Node<T>*src,Node<T>*&dst);//复制二叉树
	void PreOrder ( Node<T> *R ); //前序遍历
	void InOrder ( Node<T> *R );   //中序遍历
	void PostOrder ( Node<T> *R ); //后序遍历
	void LevelOrder ( Node<T> *R );  //层序遍历
	int Count(Node<T>* R);//计算结点总数
	bool Path(Node<T> *R, T x);//输出路径
	Node<T> *GetRoot(){return root;}//调用函数返回private数据成员root
	~BiTree();//析构函数
};

 template <class T>
 BiTree<T>::BiTree(T data[], int n)
 {
	 root = NULL;
	 Create(root,data,1,n);
 }
 //有参构造函数

template <class T>
void BiTree<T>::Create (Node<T>* &R, T data[], int i, int n)//i表示位置，n表示data数组长度
{
	
	if (i>n || data[i]==0)//如果i>n或数据恒为0，置空
		R = NULL;
	else
	{
		R = new Node<T>;
		R->data = data[i];//创建根节点
		Create(R->lch,data,2*i,n); //创建左子树   
		Create(R->rch,data,2*i+1,n);//创建右子树
	}
}

//创建二叉树（有参构造函数不能直接完成二叉树的创建工作，需要对Create函数进行调用）

template <class T>
BiTree<T>::BiTree(BiTree<T>&t)
{
    CopyTree(t ->root, this ->root);
}

template <class T>
void CopyTree(Node<T>*src,Node<T>*&dst)
{
	if(arc==NULL)//如果原指针为空
		dst=NULL;
	else
	{
		dst=new Node<T>;
		dst ->data= src ->data;//复制根结点
		CopyTree(src ->lch, dst ->lch);//复制左子树
		CopyTree(src ->rch, dst ->rch);//复制右子树
	}
}
//复制二叉树，时间复杂度O（n）

template < class T > 
void BiTree<T>::PreOrder( Node<T>  *R )
{
	if (R!=NULL) 
	{
		cout<<R ->data; // 访问结点
		PreOrder(R->lch);// 遍历左子树
     	PreOrder(R->rch); // 遍历右子树
	}
}   
 //前序遍历，时间复杂度O（n）

template < class T > 
void BiTree<T>::InOrder( Node<T>  *R )
{
	if (R!=NULL) 
	{
		InOrder(R->lch);    // 遍历左子树
		cout<<R ->data;       // 访问结点
		InOrder(R->rch);   // 遍历右子树
	}
}   
 //中序遍历，时间复杂度O（n）

template < class T > 
void BiTree<T>::PostOrder(Node<T>  *R )
{
	if (R!=NULL) 
	{
		PostOrder(R->lch);    // 遍历左子树
		PostOrder(R->rch);   // 遍历右子树
		cout<<R ->data;       // 访问结点
	}
}
 //后序遍历，时间复杂度O（n）

template <class T> 
void BiTree<T>::Release(Node<T> *R)
{
	if(R!=NULL)
	{
		Release(R->lch);//释放左子树
		Release(R->rch);//释放右子树
		delete R;//释放根结点（防止内存泄露，先子树再结点）
	}
}
template < class T > 
BiTree<T>::~BiTree()
{
	Release(root);//析构函数
}
 //释放二叉树，时间复杂度O（n）（有参构造函数不能直接完成二叉树的释放工作，需要对Release函数进行调用）

template < class T > 
void BiTree<T>::LevelOrder ( Node<T> *R )  //层序
{
	 Node<T>* queue[128];//MAXSIZE
	 int f=-1;
	 int r=-1;//初始化空队列
	
	 if(R!=NULL)
		 queue[++r]= R;//根节点入队

	 while (f!=r)
	 {
		 R = queue[++f];//队头元素入队
		 cout<<R->data;//出队打印
		 if (R->lch!=NULL)
			queue[++r]= R->lch;//左孩子入队
		 if (R->rch!=NULL)
			queue[++r]= R->rch;//右孩子入队
	 }
}
 //层序遍历，时间复杂度O（n）

template < class T > 
int BiTree<T>:: Count(Node<T>* R)
{
	if (R==NULL)
		return 0;//如果根节点为空，返回0
	if (R->lch==NULL && R->rch==NULL)
		return 1;//如果根节点没有左右子树，返回1
	else
	{
		int n = Count(R->lch);//左子树统计
		int m = Count(R->rch);//右子树统计
		return n+m+1;
	}
}
//统计结点总数，时间复杂度O（n）

template <class T>
bool BiTree<T>::Path(Node<T> *R, T x)   //二叉树路径
{
	if (R==NULL)
		return false;
	else
	{
		if ((R->data==x) || (Path(R->lch,x)) ||(Path(R->rch,x)))
		{cout <<R->data;return true;}
		else
			return false;
	}
}

//输出结点到根节点的路径，时间复杂度O（m）

void main()
{
	int k;
	char data[128]={0,'A','B','C','D','E','F',0,'G',0,0,0,'H',0};
	BiTree<char> tree(data,128);
	BiTree<char> Ntree;
	cout<<"\a\n请选择需要执行的功能k，1前序遍历；2中序遍历；3后序遍历；4层序遍历；5求结点数；6输出结点G到根节点的路径；"<<endl;
	int loop=0;
	do
	{
		cin>>k;
		switch(k) 
		{
		case 1:
			cout<<"前序遍历"<<endl;
			tree.PreOrder(tree.GetRoot());
			cout<<"\n";
			break;
		case 2:
			cout<<"中序遍历"<<endl;
			tree.InOrder(tree.GetRoot());
			cout<<"\n";
			break;
		case 3:
			cout<<"后序遍历"<<endl;
			tree.PostOrder(tree.GetRoot());
			cout<<"\n";
			break;
		case 4:
			cout<<"层序遍历"<<endl;
			tree.LevelOrder(tree.GetRoot());
			cout<<"\n";
			break;
		case 5:
			cout<<"二叉树的结点总数为：";
			cout<<tree.Count(tree.GetRoot());
			cout<<"\n";
			break;
		case 6:
			cout<<"结点G到根节点的路径为：";
			tree.Path(tree.GetRoot(),'G');
			cout<<"\n";
			break;
		case 0:
			loop=1;
			break;
		default:
			cout<<"输入的数值有误！请重新输入："<<"\n";
			break;
		}
	} 
	while(!loop);
}
