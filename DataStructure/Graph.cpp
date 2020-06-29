#include"stdafx.h"
#include <iostream>
#include<stack>
using namespace std;

const int MAXSIZE = 15;
const int MAX_VERTEX = 30;
bool S[128];
int Disk[128];
int Path[128];

struct VEdge
{
	int fromV;//起始顶点
	int endV;//终止顶点
	int weight;//边的权值
};
VEdge EdgeList[MAXSIZE];

template<class T> class MGraph//邻接矩阵
{
public:
	MGraph(T a[],int n,int e);//构造函数（图的建立）
	~MGraph() {};//析构函数（图的销毁）
	void DFS(int v);//从v出发深度优先
	void BFS(int v);//从v出发广度优先
	void Prim(MGraph G);//普里姆算法
	void Kruskal(VEdge EdgeList[],int n,int e);//克鲁斯卡尔算法
	void Print(int Disk[],int Path[],int n);
	int FindMin(int Disk[],bool S[],int n);
	void ShortPath(MGraph G,int v,int Disk[],int Path[]);//Dijkstra算法
public:
	int arcs[MAXSIZE][MAXSIZE];//弧
	int vNum,arcNum;//顶点数，边数
private:
	T vertex[MAXSIZE];//顶点
};

template<class T>
MGraph<T>::MGraph(T a[],int n,int e)//n为顶点数，e为边数
{
	int i,j,k,value;
	vNum = n;//简化
	arcNum = e;//简化
	for(k=0;k<n;k++)   vertex[k]=a[k];//初始化顶点
	for (k=0; k<n; k++)
		for (j=0;j<n;j++) 
			arcs[k][j] = -1;//初始化边

	for(k=0;k<e;k++)
	{
		cout<<"请输入相邻节点的下标：";
		cin>>i>>j;
		cout<<"请输入该边的权值：";
		cin>>value;
		arcs[i][j]=value;
		arcs[j][i]=arcs[i][j];//对角线对称元素赋值
	}
}

//以邻接矩阵为存储结构，建立带权的无向图，时间复杂度O（n^2）

int visited[MAXSIZE]={false};//初始化
template<class T>

void MGraph<T>::DFS(int v)
{
	cout<<vertex[v];
	visited[v]=true;
	for(int j=0;j<vNum;j++)//连通图
		if(arcs[v][j]>0 && !visited[j])//如果j未被访问（j为下一个邻接点）
			DFS(j);//从j开始深度优先遍历
}

//以邻接矩阵为存储结构，递归下的深度优先遍历，时间复杂度O（n^2）

/*
bool bVisited[MAXSIZE]={false};//初始化
template<class T>
void MGraph<T>::DFS(int v)
{
	int stack[MAXSIZE];//定义顺序栈
	int top = -1, i = 0;
	cout<<vertex[v]<<'\a';//访问结点v
	bVisited[v]=true;//已访问
	stack[++top]=v;//结点v入栈
	while(top!=-1)//若栈非空
	{
		v=stack[top];//设置为栈顶
		for(i=0;i<vNum;i++)
			if(arcs[v][i]>0 && !bVisited[i])//是否有未访问过的邻接点
			{
				cout<<vertex[i]<<'\a';//访问结点i
				bVisited[i]=true;//已访问
				stack[++top]=i;//i入栈
				break;
			}
			if(i==vNum) top--;//若没有未访问的结点，出栈
	}	
}

//以邻接矩阵为存储结构，非递归下的深度优先遍历，时间复杂度O（n^2）
*/

int visitedd[MAXSIZE]={false};//初始化
template<class T>

void MGraph<T>::BFS(int v)
{
	int queue[MAXSIZE];
	int f = 0 ,r = 0;//生成一个空队列
	cout<<vertex[v];  visitedd[v] = true;//访问v
	queue[++r] = v;//v入队
	while(f!=r)//当队头队尾不等（队列非空）
	{
		v=queue[++f];//队头入队
		for(int j=0;j<vNum;j++)
		{
			if(arcs[v][j]>0 && !visitedd[j])//若j未被访问
			{
				cout<<vertex[j];   visitedd[j]=true;//访问j
				queue[++r]=j;//j入队s
			}
		}
	}
}

//以邻接矩阵为存储结构，广度优先遍历，时间复杂度O（n^2）

int adjvex[MAXSIZE];//U集合中的顶点下标
int lowcost[MAXSIZE];//U->V-U的最小权值边
template<class T>
int mininum(MGraph<T> G,int lowcast[])//创建辅助数组
{
	int min=10000;//赋值最大边权值
	int k=0;
	for(int i=0;i<G.vNum;i++)
	{
		if(lowcast[i]>0&&lowcast[i]<min)//如果lowcast[i]存在且lowcast[i]权值小于min
		{
			min=lowcast[i];
			k=i;
		}//寻找U-{V-U}中边权值最小的顶点
	}
	return k;
}
//寻找辅助数组lowcost中的最小值

template<class T>
void MGraph<T>:: Prim(MGraph G)
{
	for(int i=0;i<G.vNum;i++)
	{
		adjvex[i]=0;
		lowcost[i]=G.arcs[0][i];//辅助数组存储所有到v0的边
	}
	lowcost[0]=0;//初始化U={v0}
	for(int i=1;i<G.vNum;i++)
	{
		int k=mininum(G,lowcost);//求下一个边权值最小的邻接点
		cout<<'V'<<adjvex[k]<<"->V"<<k<<endl;
		lowcost[k]=0;//U=U+{Vk}
		for(int j=0;j<G.vNum;j++)//更新辅助数组
		{
			if ((lowcost[j] != 0 && G.arcs[k][j] >0 && G.arcs[k][j] < lowcost[j]) || (G.arcs[k][j] >0 && lowcost[j] == -1))
				//如果最小权值不为0，且有更小的权值点或不连通
			{
				lowcost[j]=G.arcs[k][j];
				adjvex[j]=k;//更新U->{V-U}的边权值
			}
		}
	}
}

//以邻接矩阵为存储结构，普里姆算法，时间复杂度O（n^2）

template<class T>

void GenSortEdge(MGraph<T> G,VEdge EdgeList[])
{
	int k = 0,i,j;
	for(i=0;i<G.vNum;i++)
		for(j=i;j<G.vNum;j++)
			if (G.arcs[i][j]>0)//如果权值不为最大值
			{
				EdgeList[k].fromV=i;//起始顶点
				EdgeList[k].endV=j;//终止顶点
				EdgeList[k].weight=G.arcs[i][j];//边的权值
				k++;
			}//边赋值
			for (int i = 0; i < G.arcNum; i++)
			{
				for (int j = 0; j < G.arcNum - i; j++)
				{
					if (EdgeList[j].weight > EdgeList[j + 1].weight)
					{
						VEdge temp = EdgeList[j + 1];
						EdgeList[j + 1] = EdgeList[j];
						EdgeList[j] = temp;
					}
				}//边的排序（冒泡排序）
			}
}

//获取EdgeList并对其进行排序

template<class T>
void MGraph<T>::Kruskal(VEdge EdgeList[],int n,int e)
{
	int vset[MAX_VERTEX];//建立边集数组
	for(int i=0;i<n;i++)
		vset[i]=i;//初始化边集数组vset
	int k=0,j=0;
	while(k<n-1)
	{
		int m=EdgeList[j].fromV,l=EdgeList[j].endV;//起始顶点，终止顶点
		int sn1=vset[m];//m所属集合
		int sn2=vset[l];//l所属集合
		if(sn1!=sn2)//如果两个顶点属于不同的集合
		{
			cout<<'V'<<m<<"->V"<<l<<endl;
			k++;
			for(int i=0;i<n;i++)
			{
				if(vset[i]==sn2)
					vset[i]=sn1;//排序完毕后，集合编号为sn2的全部改为sn1
			}

		}
		j++;
	}
}

//以邻接矩阵为存储结构，边集数组为辅助结构，克鲁斯卡尔算法，时间复杂度O（n^2）

template<class T>

int MGraph<T>::FindMin(int Disk[],bool S[],int n)//S数组存储顶点i是否被添加，Disk数组储存到顶点i的路径长度
{
	int k=0,min=10000;//初始化
	for(int i=0;i<n;i++)
	{
		if(!S[i]&&min>Disk[i])//如果i未被添加，且路径长度小于max
		{
			min=Disk[i];//赋值
			k=i;//递归
		}
	}
	if(min==-1)
		return -1;//false
	return k;
}

//在Disk数组中寻找最小值（距离v0最近的顶点）

template<class T>

void MGraph<T>::Print(int Disk[],int Path[],int n)//Path数组记录顶点i的前一个顶点
{
	for(int i=0;i<n;i++)
	{
		cout<<'V'<<i<<"到V0的最短路径为: "<<Disk[i]<<"\t路径为：{V"<<i;
		int pre=Path[i];
		while(pre!=-1)//如果前一个结点存在
		{
			cout<<'V'<<pre;
			pre=Path[pre];//递归
		}
		cout<<"}"<<endl;
	}
}

//打印路径，从结点vi沿P数组回溯到v0

template<class T>

void MGraph<T>::ShortPath(MGraph G,int v,int Disk[],int Path[])
{
	bool S[128]={false};//初始化
	for(int i=0;i<G.vNum;i++)//初始化辅助数组
	{
		Disk[i]=G.arcs[v][i];
		if(Disk[i]!=-1)
			Path[i]=v;//如果有前驱，就记录
		else
		{
			Path[i]=-1;
			Disk[i]=10000;
		}//如果没有前驱，输出false
	}
		S[v]=true;
	Disk[v]=0;//初始化顶点v0，v0属于S
	for (int i = 0; i < G.vNum; i++)
	{
		if ((v = FindMin(Disk, S, G.vNum)) == -1)//寻找离v0最近的顶点
			return;
		S[v] = true;//加S
		for (int j = 0; j < G.vNum; j++)//更新辅助数组
		{
			int weight;
			if (G.arcs[v][j] == -1)//如果不连通
				weight =10000;
			else
				weight = G.arcs[v][j];
			if (!S[j] && (Disk[j] > weight + Disk[v]))//如果未添加且路径更短
			{
				Disk[j] = G.arcs[v][j] + Disk[v];
				Path[j] = v;
			}
		}
	}
	Print(Disk,Path,G.vNum);
}


//求指定顶点到其他各顶点的最短路径，时间复杂度O（n^2）

void main()
{	
	int v,e;
	cout<<"请输入顶点数(<10)和边数(<10)：";
	cin>>v>>e;

	{
		char ch[20]={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t'};
		MGraph<char> A(ch,v,e);

		cout<<"请输入深度优先遍历的起始顶点下标：";
		int s;
		cin>>s;
		cout<<"图的深度优先遍历为:"<<endl;  
		A.DFS(s);
		cout<<endl;

		cout<<"请输入广度优先遍历的起始顶点下标：";
		int k;
		cin>>k;
		cout<<"图的广度优先遍历为："<<endl;
		A.BFS(k);
		cout<<endl;

		cout<<"由普利姆算法求得的最小生成树为："<<endl;
		A.Prim(A);

		cout<<"由克鲁斯卡尔算法求得的最小生成树为："<<endl;
		VEdge EdgeList[MAXSIZE];
		GenSortEdge(A,EdgeList);
		A.Kruskal(EdgeList,v,e);

		A.ShortPath(A,0,Disk,Path);
		cout<<endl;
	}
}
