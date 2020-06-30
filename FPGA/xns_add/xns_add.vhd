LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY xns_add IS --ʤ������ͬ��������
	PORT(
		ISwin:       IN STD_LOGIC;
		rst:         IN STD_LOGIC;
		
		cnt:         OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
END xns_add;

ARCHITECTURE axns_add OF xns_add IS

    SIGNAL win_cnt:  STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

PROCESS(ISwin,rst)
BEGIN
	IF rst='1' THEN 
		win_cnt<="00";
	ELSIF ISwin'EVENT AND ISwin='0' THEN --��һ��ʤ������ʱ������cnt=2ʱ�������
		IF win_cnt="11" THEN
			win_cnt<="00";
		ELSE
			win_cnt<=win_cnt+1;
		END IF ;
	END IF;
END PROCESS;

	cnt<=win_cnt;
	
END axns_add;
	