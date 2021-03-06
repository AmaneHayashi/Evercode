LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY key_lg IS --键盘逻辑
port(
	rst:                    IN STD_LOGIC;
	clk:                    IN STD_LOGIC;
	ISkey:                  OUT STD_LOGIC; --是否按键
	
	keyrow:                 IN STD_LOGIC_VECTOR(3 DOWNTO 0);  --按键的行坐标
	keycol:                 OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --按键的列坐标
	coordinate:             OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  --按键的坐标
	);
END key_lg;

ARCHITECTURE akey_lg OF key_lg IS
	
	TYPE state              IS(s0,s1,s2,s3,s4);
	
	SIGNAL now_state:       state;
	SIGNAL next_state:      state;
	SIGNAL ISkeytemp:       STD_LOGIC; --按键
	SIGNAL col:             STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL key_coordinate:  STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN

p1:PROCESS(rst,now_state) --五种状态
BEGIN
	IF rst='1' THEN
		next_state<=s0;
	ELSE
		CASE now_state IS
			WHEN s0=> --（s0->默认态）
	  			next_state<=s1;	
			WHEN s1=> --（s1->第一列扫描）
				IF ISkeytemp='1' THEN
					next_state<=s1;
				ELSE
					next_state<=s2;
				END IF;
			WHEN s2=> --（s2->第二列扫描）
				IF ISkeytemp='1' THEN
					next_state<=s2;
				ELSE
					next_state<=s3;
				END IF;
			WHEN s3=> --（s3->第三列扫描）
				IF ISkeytemp='1' THEN
					next_state<=s3;
				ELSE
					next_state<=s4;
				END IF;
			WHEN s4=> --（s4->第四列扫描）
				IF ISkeytemp='1' THEN
					next_state<=s4;
				ELSE
					next_state<=s1;
				END IF;
			WHEN OTHERS=>
				next_state<=s0;
		END CASE;
	END IF;
END PROCESS;
	
p2:PROCESS(rst,next_state,clk)
BEGIN
	IF rst='1' THEN
		now_state<=s0;
	ELSIF clk'event and clk='1' THEN
		now_state<=next_state;
	END IF;
END PROCESS;
	
p3:PROCESS(now_state,keyrow)
BEGIN
	CASE now_state IS
		WHEN s0=>
			ISkeytemp<='0';
			col<="1111";
			key_coordinate<="0000";
		WHEN s1=>
			col<="0111";
			CASE keyrow IS
				WHEN "0111" => --(4,4)
					key_coordinate <="0000";
					ISkeytemp<='1';
				WHEN "1011" => --(4,3)
					key_coordinate <="0001";
					ISkeytemp<='1';
				WHEN "1101" => --(4,2)
					key_coordinate <="0010";
					ISkeytemp<='1';
				WHEN "1110" => --(4,1)
					key_coordinate <="0011";
					ISkeytemp<='1';
				WHEN "1111"=> --NULL
					ISkeytemp<='0';
				WHEN OTHERS=>
					ISkeytemp<='1';
			END CASE;
		WHEN s2=>
			col<="1011";
			CASE keyrow IS
				WHEN "0111" => --(3,4)
					key_coordinate <="0100";
					ISkeytemp<='1';
				WHEN "1011" => --(3,3)
					key_coordinate <="0101";
					ISkeytemp<='1';
				WHEN "1101" => --(3,2)
					key_coordinate <="0110";
					ISkeytemp<='1';
				WHEN "1110" => --(3,1)
					key_coordinate <="0111";
					ISkeytemp<='1';
				WHEN "1111"=> --NULL
					ISkeytemp<='0';
				WHEN OTHERS=>
					ISkeytemp<=ISkeytemp;
			END CASE;
		WHEN s3=>
			col<="1101";
			CASE keyrow IS
				WHEN "0111" => --(2,4)
					key_coordinate <="1000";
					ISkeytemp<='1';
				WHEN "1011" => --(2,3)
					key_coordinate <="1001";
					ISkeytemp<='1';
				WHEN "1101" => --(2,2)
					key_coordinate <="1010";
					ISkeytemp<='1';
				WHEN "1110" => --(2,1)
					key_coordinate <="1011";
					ISkeytemp<='1';
				WHEN "1111"=> --NULL
					ISkeytemp<='0';
				WHEN OTHERS=>
					ISkeytemp<=ISkeytemp;
			END CASE;
		WHEN s4=>
			col<="1110";
			CASE keyrow IS
				WHEN "0111" => --(1,4)
					key_coordinate <="1100";
					ISkeytemp<='1';
				WHEN "1011" => --(1,3)
					key_coordinate <="1101";
					ISkeytemp<='1';
				WHEN "1101" => --(1,2)
					key_coordinate <="1110";
					ISkeytemp<='1';
				WHEN "1110" => --(1,1)
					key_coordinate <="1111";
					ISkeytemp<='1';
				WHEN "1111"=> --NULL
					ISkeytemp<='0';
				WHEN OTHERS=>
					ISkeytemp<=ISkeytemp;
			END CASE;
		WHEN OTHERS=> --NULL
			ISkeytemp<='0';
			col<="1111";
			key_coordinate<="0000";
	END CASE;
END PROCESS;
	
	keycol<=col;
	ISkey<=ISkeytemp;
	coordinate<=key_coordinate;
	
END akey_lg;
	