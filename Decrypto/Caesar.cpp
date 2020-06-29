/*
 * * * * * * * * * * * * * * * * * * * * 移动互联网安全技术实验一* * * * * * * * * * * * * * * * * * * *
 *   WRITTEN BY: AMANE ICE                                                                             *
 *   DATE: 11/09/2018                                                                                  *
 *   REFERENCES: GUIDANCE BOOK OF MOBILE INTERNET SECURITY TECH.                                       *
 *   SCHOOL OF INFORMATION AND TELECOMMUNICATION ENGINNERING,                                          *
 *   BEIJING UNIVERSITY OF POSTS AND TELECOMMUNICATIONS                                                *                                                                                     
 * * * * * * * * * * * * * * * * * * * * 单表代替加密实现算法* * * * * * * * * * * * * * * * * * * * * * 

测试参考：（密钥）spectacular，（明文）china.
题目要求：
（1）按照单表代替密码的原则，以“bupt”为密钥，设计并输出字母代替表，发送明文是“China”（键盘输入），给出对应的密文；
（2）按照单表代替密码的原则，以“communication”为密钥，设计并输出字母代替表，发送明文是“BUPT”（键盘输入），给出对应的密文；
（3）按照单表代替密码的原则，以“bupt”为密钥，设计并输出字母代替逆向表，发送密文是“riiwniy”（键盘输入），给出对应的明文；
*/

#include "test.h"

int main() {
	while (1) {
		char c;
		cout << "请输入您想要的操作。\n1.正向加密\n2.正向解密\n3.倒置加密\n4.倒置解密\n5.退出\n";
		cin >> c;
		system("cls");//清屏
		switch (c){
		case '1':
			memset(secret_key, 0, sizeof(secret_key) / sizeof(char));//清空
			memset(x, 0, sizeof(x));memset(y, 0, sizeof(y));//清空
			memset(sub_table, 0, sizeof(sub_table));//清空
			cout << "【正向加密】请输入您的密钥！\n";
			cin >> secret_key;
			cout << "【正向加密】请输入您的明文！\n";
			cin >> x;
			generate_secret_table();//生成密码表
			get_en_text(sub_table);//依据正向表生成密文
			cout << "【正向加密】密文是" << y << "\n\n";
			break;
		case '2':
			memset(secret_key, 0, sizeof(secret_key) / sizeof(char));//清空
			memset(x, 0, sizeof(x));memset(y, 0, sizeof(y));//清空
			memset(sub_table, 0, sizeof(sub_table));//清空
			cout << "【正向解密】请输入您的密钥！\n";
			cin >> secret_key;
			cout << "【正向解密】请输入您的密文！\n";
			cin >> x;
			generate_secret_table();//生成密码表
			get_de_text(sub_table);//依据正向表生成明文
			cout << "【正向解密】明文是" << y << "\n\n";
			break;
		case '3':
			memset(secret_key, 0, sizeof(secret_key) / sizeof(char));//清空
			memset(x, 0, sizeof(x));memset(y, 0, sizeof(y));//清空
			memset(sub_table, 0, sizeof(sub_table));//清空
			cout << "【反向加密】请输入您的密钥！\n";
			cin >> secret_key;
			cout << "【反向加密】请输入您的明文！\n";
			cin >> x;
			generate_secret_table();//生成密码表
			reverse_table();//倒置密码表
			get_en_text(re_table);//依据逆向表生成密文
			cout << "【反向加密】密文是" << y << "\n\n";
			break;
		case '4':
			memset(secret_key, 0, sizeof(secret_key) / sizeof(char));//清空
			memset(x, 0, sizeof(x));memset(y, 0, sizeof(y));//清空
			memset(sub_table, 0, sizeof(sub_table));//清空
			cout << "【反向解密】请输入您的密钥！\n";
			cin >> secret_key;
			cout << "【反向解密】请输入您的密文！\n";
			cin >> x;
			generate_secret_table();//生成密码表
			reverse_table();//倒置密码表
			get_de_text(re_table);//依据逆向表生成明文
			cout << "【反向解密】明文是" << y << "\n\n";
			break;
		case '5':
			return 0;
		default:
			cout<<"输入有误!请重新输入：\n";
			break;
		}
	}
}

//创建密码表函数
void generate_secret_table(){
	table_len = 0;
	int key_len = strlen(secret_key);//获取密钥长度
	for (int i = 0;i < key_len;i++) {
		if (secret_key[i] >= 'A' && secret_key[i] <= 'Z')//大小写统一处理
			secret_key[i] += 32;
		if (x[i] >= 'A' && x[i] <= 'Z')//大小写统一处理
			x[i] += 32;
	}
	key_len--;

	for (char a = 'a';a <= 'z';a++)
		secret_key[++key_len] = a;//将字母表添在密钥数组后
	secret_key[++key_len] = '\0';//结束符
	sub_table[0] = secret_key[0];//密码表第一个字母一定是密钥第一个字母

	for (int j = 1;j < key_len;j++) {
		int flag = 0;//设置是否有相同字母的标志
		for (int i = 0;i <= table_len;i++)//遍历已经存入密码表的元素，若新元素有相同的则跳过，没有则添加在最后
			if (secret_key[j] == sub_table[i]) {
				flag = 1;
				break;
			}
		if (flag == 0){
			sub_table[++table_len] = secret_key[j];
		}
	}
	sub_table[++table_len] = '\0';//结束符
}

//密文生成函数
void get_en_text(char *table){//传入参数为密码表
	for (int i = 0;i < strlen(x);i++)
		y[i] = table[x[i] - 'a'];//根据明文字母在密码表中的位次，得到对应的密文字母
	y[strlen(x)] = '\0';//结束符
}

//明文生成函数
void get_de_text(char* table){//传入参数为密码表
	int count = 0;
	int z[N];
	char initial[27] = "abcdefghijklmnopqrstuvwxyz";//字母表
	for (int i = 0; i < N; i++){
		if (x[i] != 0)
			count++;//统计密文非零元素个数
	}

	int k = 0;
	for (int i = 0;i <= count; i++){
		for (int j = 0;j < table_len; j++){
			if (table[j] == x[i]){//找到密码表中与密文字母相等的字母序号并记录
				z[k] = j;
				k++;
				break;
			}
		}
	}
	for (int i = 0; i < count; i++)
		y[i] = initial[z[i]];//根据密文字母在字母表中的位次，得到对应的明文字母
}

//倒置密码表
void reverse_table()
{
	for (int i = 0;i < table_len;i++)
		re_table[i] = sub_table[table_len - i - 1];
}
