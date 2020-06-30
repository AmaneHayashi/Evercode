LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY extr IS --附加部分
	PORT(
		clk:           IN STD_LOGIC; --频率50MHz
		rst:           IN STD_LOGIC;
		ISxns:         IN STD_LOGIC; --胜利
		ISfail:        IN STD_LOGIC; --失败
		beep:          OUT STD_LOGIC --蜂鸣器
		);
END extr;

ARCHITECTURE aextr OF extr IS

	SIGNAL beep_clk:   STD_LOGIC;
	SIGNAL cnt:        INTEGER RANGE 0 TO 7500;
	SIGNAL state_code:  STD_LOGIC_VECTOR(1 DOWNTO 0); --状态码
	
COMPONENT extr_st IS --蜂鸣器状态设置
	PORT(
		clk:           IN STD_LOGIC;
		ISxns:         IN STD_LOGIC; --胜利
		ISfail:        IN STD_LOGIC; --失败
		
		statecode:     OUT STD_LOGIC_VECTOR(1 DOWNTO 0) --状态码
		);
END COMPONENT;

COMPONENT extr_beep IS --音乐设置
	PORT(
		clk:               IN STD_LOGIC;  --频率1MHz
		beepout:           OUT STD_LOGIC; --蜂鸣器	
		
		bstatecode:        IN STD_LOGIC_VECTOR(1 DOWNTO 0) --状态码
	    );
END COMPONENT;

BEGIN 

p1:PROCESS(clk,rst) --分频器
BEGIN
	IF rst='1' THEN
		cnt<=0;
	ELSIF clk'EVENT AND clk='1' THEN
		IF cnt = 25 THEN --分频后，频率1MHz
			cnt<=0;
			beep_clk<=NOT beep_clk;
		ELSE
			cnt<=cnt+1;
		END IF;
	END IF;
END PROCESS;

u1:extr_st PORT MAP(
	clk=>beep_clk,
	ISxns=>ISxns,
	ISfail=>ISfail,
	statecode=>state_code
	);
u2:extr_beep PORT MAP(
	clk=>beep_clk,
	bstatecode=>state_code,
	beepout=>beep
	);
END aextr;
 