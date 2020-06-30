LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pic_rdm IS --随机数设置
	PORT( 
		 clk:         IN STD_LOGIC;
		 
		 rdm:         OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		 );
END pic_rdm;

ARCHITECTURE apic_rdm OF pic_rdm IS
	
    SIGNAL temp:      STD_LOGIC;
	SIGNAL temp2:     STD_LOGIC;
    SIGNAL temp_rdm:  STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN

PROCESS(clk)
BEGIN
	temp<=temp_rdm(0);
	temp2<=temp_rdm(3);
	IF temp_rdm="0000" THEN
		temp_rdm<="1110";
	ELSIF clk'EVENT AND clk='1' THEN
		temp_rdm<=temp_rdm(2 DOWNTO 0)&( temp XOR temp2); --生成4位序列
	END IF;
END PROCESS;

	rdm<=temp_rdm;

END apic_rdm;
