LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY dzn_st IS --点阵状态
	PORT(
		clk:            IN STD_LOGIC;
		rst:            IN STD_LOGIC;
		next_state:     IN STD_LOGIC;
		ISready:        IN STD_LOGIC;
		ISwin:          OUT STD_LOGIC; --赢下一局
		play:           OUT STD_LOGIC;
		
		colin0:         IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		colin1:         IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		colin2:         IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		colin3:         IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col_in0:        IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col_in1:        IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col_in2:        IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col_in3:        IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col2:           OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col3:           OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col4:           OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		col5:           OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)
		);
END dzn_st;

ARCHITECTURE adzn_st OF dzn_st IS
	
	TYPE state          IS (s0,s1,s2);
	TYPE dzn_array      IS ARRAY (3 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL state_now:   state;
	SIGNAL state_next:  state;
	SIGNAL arr:         dzn_array;
	SIGNAL ISplay:      STD_LOGIC;
	SIGNAL IS_win:       STD_LOGIC;
BEGIN

p1:PROCESS(state_now,rst,IS_win,next_state)
BEGIN
	IF rst='1' THEN
		state_next<=s0;
	ELSE
		CASE state_now IS
			WHEN s0=>
				IF ISready='1' THEN --开始游戏
					state_next<=s1;
				ELSE
					state_next<=s0;
				END IF;
			WHEN s1=>
				IF arr(0)="00000000" AND arr(1)="00000000" 
					AND arr(2)="00000000" AND arr(3)="00000000" THEN --全部灯灭
					state_next<=s2;
				ELSE 
					state_next<=s1;
				END IF;
			WHEN s2=>
				IF IS_win='1' AND next_state='1' THEN --胜利并按下BTN7
					state_next<=s0;
				ELSE
					state_next<=s2;
				END IF;
		END CASE;
	END IF;
END PROCESS;
	
p2:PROCESS(clk,rst,state_next)
BEGIN
	IF rst='1' THEN
		state_now<=s0;
	ELSIF clk'EVENT AND clk='1' THEN
		state_now<=state_next;
    END IF;
END PROCESS;
	
p3:PROCESS(state_now,colin0,colin1,colin2,colin3,arr)
BEGIN
	CASE state_now IS 
		WHEN s0=>
			IS_win<='0'; --非胜利
			ISplay<='0'; --未开始
			arr(0)<=colin0;
			arr(1)<=colin1;
			arr(2)<=colin2;
			arr(3)<=colin3;
		WHEN s1=>
			IS_win<='0'; --非胜利
			ISplay<='1'; --开始
			arr(0)<=col_in0;
			arr(1)<=col_in1;
			arr(2)<=col_in2;
			arr(3)<=col_in3;
		WHEN s2=>
			IS_win<='1'; --胜利
			ISplay<='1'; --开始
			arr(0)<=col_in0;
			arr(1)<=col_in1;
			arr(2)<=col_in2;
			arr(3)<=col_in3;
	END CASE;	
END PROCESS;
	
	col2<=arr(0);
	col3<=arr(1);
	col4<=arr(2);
	col5<=arr(3);
	ISwin<=IS_win;
	play<=ISplay;
	
END adzn_st;