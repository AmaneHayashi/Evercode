LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY extr_beep IS --音乐设置
	PORT(
		clk:               IN STD_LOGIC;  --频率1MHz
		beepout:           OUT STD_LOGIC; --蜂鸣器	
		
		bstatecode:        IN STD_LOGIC_VECTOR(1 DOWNTO 0) --状态码
	    );
END extr_beep;

ARCHITECTURE aextr_beep OF extr_beep IS

	SIGNAL tempbeep:       STD_LOGIC;
	SIGNAL beeptone:       INTEGER RANGE 0 TO 1200;

BEGIN

ToneCtrl: PROCESS(clk)
	
	VARIABLE cntForTime:   INTEGER RANGE 0 TO 500000 := 0;
	VARIABLE beepcnt:      INTEGER RANGE 0 TO 17 := 0;	
	VARIABLE ISbreak:      STD_LOGIC := '0';  --蜂鸣标志
	
	CONSTANT mC:           INTEGER := 956; --Alto do（中音1，频率1046Hz）
	CONSTANT mD:           INTEGER := 852; --Alto re（中音2，频率1175Hz）
	CONSTANT mE:           INTEGER := 759; --Alto mi（中音3，频率1318Hz）
	CONSTANT mF:           INTEGER := 716; --Alto fa（中音4，频率1397Hz）
	CONSTANT mG:           INTEGER := 638; --Alto so（中音5，频率1568Hz）
	CONSTANT mA:           INTEGER := 568; --Alto la（中音6，频率1760Hz）
	CONSTANT mB:           INTEGER := 506; --Alto si（中音7，频率1967Hz）
	
BEGIN
	IF(clk'EVENT AND clk = '1')THEN
		IF beepcnt = 17 THEN 
			beepcnt := 0;
		ELSE
			beepcnt := beepcnt + 1;
		END IF;
	    CASE bStateCode IS
			WHEN "00" =>  --不工作
				beeptone <= 0; cntForTime := 0; ISbreak := '0'; beepcnt := 0;
			WHEN "01" =>  --胜利
				IF(ISbreak = '0') THEN
					CASE beepcnt IS
						WHEN 0 => beeptone <= mC;
						WHEN 1 => beeptone <= mC;
						WHEN 2 => beeptone <= mG;
						WHEN 3 => beeptone <= mG;
						WHEN 4 => beeptone <= mA;
						WHEN 5 => beeptone <= mA;
						WHEN 6 => beeptone <= mG;
						WHEN 7 => beeptone <= 0;
						WHEN 8 => beeptone <= 0;
						WHEN 9 => beeptone <= mF;
						WHEN 10 => beeptone <= mF;
						WHEN 11 => beeptone <= mE;
						WHEN 12 => beeptone <= mE;
						WHEN 13 => beeptone <= mD;
						WHEN 14 => beeptone <= mD;
						WHEN 15 => beeptone <= mC;
						WHEN 16 => beeptone <= 0;
						WHEN 17 => beeptone <= 0;ISbreak := '1';
					END CASE;
				END IF;
			WHEN "10" =>  --失败
				IF(ISbreak = '0') THEN
					CASE beepcnt IS	
						WHEN 0 => beeptone <= mG;
						WHEN 1 => beeptone <= mG;
						WHEN 2 => beeptone <= mF;
						WHEN 3 => beeptone <= mF;
						WHEN 4 => beeptone <= mE;
						WHEN 5 => beeptone <= mE;
						WHEN 6 => beeptone <= mD;
						WHEN 7 => beeptone <= 0;
						WHEN 8 => beeptone <= 0;
						WHEN 9 => beeptone <= mG;
						WHEN 10 => beeptone <= mG;
						WHEN 11 => beeptone <= mF;
						WHEN 12 => beeptone <= mF;
						WHEN 13 => beeptone <= mE;
						WHEN 14 => beeptone <= mE;
						WHEN 15 => beeptone <= mD;
						WHEN 16 => beeptone <= 0;
						WHEN 17 => beeptone <= 0;ISbreak := '1';
					END CASE;
				END IF;
			WHEN "11" =>  --测试
				beeptone <= 0; cntForTime := 0; ISbreak := '0'; beepcnt := 0;
		END CASE;
	END IF;
END PROCESS ToneCtrl;
	
BeepVoice: PROCESS(clk)  --蜂鸣输出
	
	VARIABLE cnt: INTEGER RANGE 0 TO 1000 := 0;
	
BEGIN
	IF(beeptone = 0) THEN
		tempbeep <= '0';
	ELSE
		IF(clk'EVENT AND clk = '1')THEN
			IF(cnt = beeptone) THEN  --蜂鸣时间为各音调对应的常数，频率即为音调频率
				cnt := 0;
				tempbeep <= NOT tempbeep;
			ELSE
				cnt := cnt + 1;
			END IF;
		END IF;
	END IF;	
END PROCESS BeepVoice;

	beepout <= tempbeep;

END aextr_beep;