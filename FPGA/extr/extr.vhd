LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY extr IS --���Ӳ���
	PORT(
		clk:           IN STD_LOGIC; --Ƶ��50MHz
		rst:           IN STD_LOGIC;
		ISxns:         IN STD_LOGIC; --ʤ��
		ISfail:        IN STD_LOGIC; --ʧ��
		beep:          OUT STD_LOGIC --������
		);
END extr;

ARCHITECTURE aextr OF extr IS

	SIGNAL beep_clk:   STD_LOGIC;
	SIGNAL cnt:        INTEGER RANGE 0 TO 7500;
	SIGNAL state_code:  STD_LOGIC_VECTOR(1 DOWNTO 0); --״̬��
	
COMPONENT extr_st IS --������״̬����
	PORT(
		clk:           IN STD_LOGIC;
		ISxns:         IN STD_LOGIC; --ʤ��
		ISfail:        IN STD_LOGIC; --ʧ��
		
		statecode:     OUT STD_LOGIC_VECTOR(1 DOWNTO 0) --״̬��
		);
END COMPONENT;

COMPONENT extr_beep IS --��������
	PORT(
		clk:               IN STD_LOGIC;  --Ƶ��1MHz
		beepout:           OUT STD_LOGIC; --������	
		
		bstatecode:        IN STD_LOGIC_VECTOR(1 DOWNTO 0) --״̬��
	    );
END COMPONENT;

BEGIN 

p1:PROCESS(clk,rst) --��Ƶ��
BEGIN
	IF rst='1' THEN
		cnt<=0;
	ELSIF clk'EVENT AND clk='1' THEN
		IF cnt = 25 THEN --��Ƶ��Ƶ��1MHz
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
 