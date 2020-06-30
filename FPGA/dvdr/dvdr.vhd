LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY dvdr IS--��Ƶ��
	PORT(
		mclk:      IN STD_LOGIC; --��Ƶ50MHz
		rst:       IN STD_LOGIC;
		clk1:      OUT STD_LOGIC;--��Ƶ1
		clk2:      OUT STD_LOGIC;--��Ƶ2
		clk3:      OUT STD_LOGIC --��Ƶ3
		);
END dvdr;

ARCHITECTURE advdr OF dvdr IS
	
	SIGNAL clk_1:  STD_LOGIC;
	SIGNAL clk_2:  STD_LOGIC;
	SIGNAL clk_3:  STD_LOGIC;
	SIGNAL cnt1:   INTEGER RANGE 0 TO 10000;
	SIGNAL cnt2:   INTEGER RANGE 0 TO 250000;
	SIGNAL cnt3:   INTEGER RANGE 0 TO 12500;

BEGIN

p1:PROCESS(mclk,rst)
BEGIN
	IF rst='1' THEN
		cnt1<=0;
	ELSIF mclk'EVENT and mclk='1' THEN
		IF cnt1 = 10000 THEN --��Ƶϵ��20000
			cnt1<=0;
			clk_1<=NOT clk_1;
		ELSE
			cnt1<=cnt1+1;
		END IF;
	END IF;
END PROCESS;
	
p2:PROCESS(mclk,rst)
BEGIN
	IF rst='1' THEN
		cnt2<=0;
	ELSIF mclk'EVENT and mclk='1' THEN
		IF cnt2 = 250000 THEN --��Ƶϵ��500000
			cnt2<=0;
			clk_2<=NOT clk_2;
		ELSE
			cnt2<=cnt2+1;
		END IF;
	END IF;
END PROCESS;
	
p3:PROCESS(mclk,rst)
BEGIN
	IF rst='1' THEN
		cnt3<=0;
	ELSIF mclk'EVENT and mclk='1' THEN
		IF cnt3 = 12500 THEN --��Ƶϵ��25000
			cnt3<=0;
			clk_3<=NOT clk_3;
		ELSE
			cnt3<=cnt3+1;
		END IF;
	END IF;
END PROCESS;

	clk1<=clk_1;--Ƶ��2.5KHz
	clk2<=clk_2;--Ƶ��500Hz
	clk3<=clk_3;--Ƶ��2KHz

END advdr;
			