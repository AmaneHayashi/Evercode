LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY key IS --键盘输入
	PORT(
		clk:              IN STD_LOGIC; --频率500Hz
		rst:              IN STD_LOGIC;
		ISbutton:         OUT STD_LOGIC; --是否按键
		
		keyin:            IN STD_LOGIC_VECTOR(3 DOWNTO 0); --按键的行坐标
		keycol:           OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --按键的列坐标
		key_place:        OUT STD_LOGIC_VECTOR(3 DOWNTO 0) --按键的坐标
		);
END key;

ARCHITECTURE akey OF key IS

	SIGNAL ISflag:        STD_LOGIC;
	SIGNAL IS_button:     STD_LOGIC;
	SIGNAL temp_xy:       STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL key_position:  STD_LOGIC_VECTOR(3 DOWNTO 0);

COMPONENT key_lg --键盘逻辑
    PORT(
        clk:              IN STD_LOGIC;
        rst:              IN STD_LOGIC;
	    ISkey:            OUT STD_LOGIC; --是否按键
	
	    keyrow:           IN STD_LOGIC_VECTOR(3 DOWNTO 0); --按键的行坐标
	    keycol:           OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --按键的列坐标
	    coordinate:       OUT STD_LOGIC_VECTOR(3 DOWNTO 0) --按键的坐标
	    );
END COMPONENT;

COMPONENT key_st --键盘状态
    PORT(
		clk:            IN STD_LOGIC;
		rst:            IN STD_LOGIC;
		ISkey:          IN STD_LOGIC; --键盘输入
		IS_key:         OUT STD_LOGIC; --键盘输入激励
		
		keyin:          IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		keyout:         OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

BEGIN
u1: key_lg PORT MAP (
	clk=>clk,
	rst=>rst,
	ISkey =>ISflag,
	keyrow=>keyin,
	keycol=>keycol,
	coordinate=>temp_xy
	);

u2: key_st PORT MAP(
	clk=>clk,
	rst=>rst,
	keyin=>temp_xy,
	ISkey=>ISflag,
	keyout=>key_position,
	IS_key=>IS_button
	);

	key_place<=key_position;
	ISbutton<=IS_button;

END akey;