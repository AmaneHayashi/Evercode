LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pic IS --15种状态游戏界面
	PORT(
		clk1:        IN STD_LOGIC;  --频率2.5KHz
		clk2:        IN STD_LOGIC;  --频率2KHz
		rst:         IN STD_LOGIC;
		fail:        IN STD_LOGIC;  --游戏失败
		ISxns:       IN STD_LOGIC;  --游戏胜利
		ISready:     OUT STD_LOGIC; --开始游戏
		
		cnt:         IN STD_LOGIC_VECTOR(1 DOWNTO 0);  --状态计数器
		max_path:    OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --最大步数
		col1:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END pic;

ARCHITECTURE apic OF pic IS

COMPONENT pic_rdm IS --随机数设置
	PORT( 
		 clk:        IN STD_LOGIC;
		 rdm:        OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		 );
END COMPONENT;

COMPONENT pic_st IS --状态设置
	PORT(
		clk:         IN STD_LOGIC;
		rst:         IN STD_LOGIC;
		ISxns:       IN STD_LOGIC;
		fail:        IN STD_LOGIC;
		ready:       OUT STD_LOGIC;
		
		in_cnt:      IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		in_num:      IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		pic_num:     OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT pic_p IS --点阵设置
PORT (
		IS_ready:    IN STD_LOGIC;
		
		pic_num:     IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		max_path:    OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		col1:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:        OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END COMPONENT;

    SIGNAL ISrdy:    STD_LOGIC;
	SIGNAL rdm:      STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL pic_num:  STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL path_max: STD_LOGIC_VECTOR(6 DOWNTO 0);
	
BEGIN

u1:pic_rdm PORT MAP(
	clk=>clk1,
	rdm=>rdm
	);
	
u2:pic_st PORT MAP(
	clk=>clk2,
	rst=>rst,
	ISxns=>ISxns,
	fail=>fail,
	in_num=>rdm,
	in_cnt=>cnt,
	ready=>ISrdy,
	pic_num=>pic_num
	);

u3:pic_p PORT MAP(
	pic_num =>pic_num,
	IS_ready=>ISrdy,
	max_path=>path_max,
	col1=>col1,
	col2=>col2,
	col3=>col3,
	col4=>col4
	);

	ISready<=ISrdy;
	max_path<=path_max;

END apic;
