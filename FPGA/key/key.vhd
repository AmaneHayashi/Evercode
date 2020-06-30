LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY key IS --��������
	PORT(
		clk:              IN STD_LOGIC; --Ƶ��500Hz
		rst:              IN STD_LOGIC;
		ISbutton:         OUT STD_LOGIC; --�Ƿ񰴼�
		
		keyin:            IN STD_LOGIC_VECTOR(3 DOWNTO 0); --������������
		keycol:           OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --������������
		key_place:        OUT STD_LOGIC_VECTOR(3 DOWNTO 0) --����������
		);
END key;

ARCHITECTURE akey OF key IS

	SIGNAL ISflag:        STD_LOGIC;
	SIGNAL IS_button:     STD_LOGIC;
	SIGNAL temp_xy:       STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL key_position:  STD_LOGIC_VECTOR(3 DOWNTO 0);

COMPONENT key_lg --�����߼�
    PORT(
        clk:              IN STD_LOGIC;
        rst:              IN STD_LOGIC;
	    ISkey:            OUT STD_LOGIC; --�Ƿ񰴼�
	
	    keyrow:           IN STD_LOGIC_VECTOR(3 DOWNTO 0); --������������
	    keycol:           OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --������������
	    coordinate:       OUT STD_LOGIC_VECTOR(3 DOWNTO 0) --����������
	    );
END COMPONENT;

COMPONENT key_st --����״̬
    PORT(
		clk:            IN STD_LOGIC;
		rst:            IN STD_LOGIC;
		ISkey:          IN STD_LOGIC; --��������
		IS_key:         OUT STD_LOGIC; --�������뼤��
		
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