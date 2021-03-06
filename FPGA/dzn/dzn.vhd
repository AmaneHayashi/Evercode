LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY dzn IS --点阵逻辑
	PORT(
		clk:              IN STD_LOGIC; --频率500Hz
		rst:              IN STD_LOGIC;
		ISxns:            IN STD_LOGIC; --胜利
		next_state:       IN STD_LOGIC;
		key:              IN STD_LOGIC;
		ISready:          IN STD_LOGIC;
		out_fail:         OUT STD_LOGIC;
		ISwin:            OUT STD_LOGIC;
	
		keyin:            IN STD_LOGIC_VECTOR(3 DOWNTO 0); --键盘输入
		path_max:         IN STD_LOGIC_VECTOR(6 DOWNTO 0); --最大步数
		incol0:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol1:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol2:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol3:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		path:             OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --步数
		pathe_max:        OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --最大步数
		col0:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col5:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg1:            OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg2:            OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END dzn;

ARCHITECTURE adzn OF dzn IS
	
    TYPE store_array      IS ARRAY (7 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE col_array        IS ARRAY (3 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    SIGNAL carr:          col_array;
    SIGNAL sarr:          store_array;
    SIGNAL fail :         STD_LOGIC;
    SIGNAL ISplay:        STD_LOGIC;
    SIGNAL pathe:         STD_LOGIC_VECTOR(6 DOWNTO 0);

COMPONENT dzn_st IS--点阵状态
	PORT(
		clk:              IN STD_LOGIC;
		next_state:       IN STD_LOGIC;
		rst:              IN STD_LOGIC;
		ISready:          IN STD_LOGIC;
		ISwin:            OUT STD_LOGIC;
		play:             OUT STD_LOGIC;--游戏进行
		
		colin0:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		colin1:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		colin2:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		colin3:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col_in0:          IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col_in1:          IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col_in2:          IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col_in3:          IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col5:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END COMPONENT;

COMPONENT dzn_lg IS--键盘按键时点阵变化
	PORT(
		rst:              IN STD_LOGIC;
		key:              IN STD_LOGIC;--键盘
        out_fail:         OUT STD_LOGIC;--失败
        
		keyin:            IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		maxpath:          IN STD_LOGIC_VECTOR(6 DOWNTO 0);--最大步数
		incol0:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol1:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol2:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol3:           IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		max_pathe:        OUT STD_LOGIC_VECTOR(6 DOWNTO 0);--最大步数
		pathnum:          OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		outcol0:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		outcol1:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		outcol2:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		outcol3:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);		
END COMPONENT;

BEGIN

PROCESS(ISxns) --初始化
BEGIN
	IF ISxns='0' OR fail ='0' THEN
		path<=pathe;
		col0<="00000000";
   		col2<=sarr(2);
		col3<=sarr(3);
   		col4<=sarr(4);
   		col5<=sarr(5);
		colg1<="01111110";
		colg2<="01000010";
	ELSE
		path<=pathe;
		col0<="ZZZZZZZZ";
   		col2<="ZZZZZZZZ";
   		col3<="ZZZZZZZZ";
   		col4<="ZZZZZZZZ";
   		col5<="ZZZZZZZZ";
   		colg1<="ZZZZZZZZ";
		colg2<="ZZZZZZZZ";
	END IF;
END PROCESS;
	
u1:dzn_st PORT MAP(
	clk=>clk,
	rst=>rst,
	next_state=>next_state,
	ISready=>ISready,
	colin0=>incol0,
	colin1=>incol1,
	colin2=>incol2,
	colin3=>incol3,
	col_in0=>carr(0),
	col_in1=>carr(1),
	col_in2=>carr(2),
	col_in3=>carr(3),
	col2=>sarr(2),
	col3=>sarr(3),
	col4=>sarr(4),
	col5=>sarr(5),
	ISwin=>ISwin,
	play=>ISplay
	);

u2:dzn_lg PORT MAP(
	rst=>rst OR (NOT ISplay),
	pathnum=>pathe,
	key=>key,--键盘
	out_fail=>fail,
	maxpath=>path_max,
	max_pathe=>pathe_max,
	keyin=>keyin,--键盘输入
	incol0=>sarr(2),
	incol1=>sarr(3),
	incol2=>sarr(4),
	incol3=>sarr(5),
	outcol0=>carr(0),
	outcol1=>carr(1),
	outcol2=>carr(2),
	outcol3=>carr(3)
	);

	out_fail<=fail;
	
END adzn;