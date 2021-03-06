LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pic_st IS --状态设置
	PORT(
		clk:            IN STD_LOGIC;
		rst:            IN STD_LOGIC;
		ISxns:          IN STD_LOGIC;
		fail:           IN STD_LOGIC;
		ready:          OUT STD_LOGIC;
		
		in_cnt:         IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		in_num:         IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		pic_num:        OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END pic_st;

ARCHITECTURE apic_st OF pic_st IS
	
	type state          IS (s0,s1,s2,s3);
	
	SIGNAL num1:        STD_LOGIC_VECTOR(3 DOWNTO 0); --第num1个点阵图形
	SIGNAL num2:        STD_LOGIC_VECTOR(3 DOWNTO 0); --第num2个点阵图形
	SIGNAL num3:        STD_LOGIC_VECTOR(3 DOWNTO 0); --第num3个点阵图形
	SIGNAL out_num:     STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL flag:        STD_LOGIC; --复位允许标志
	SIGNAL ISready:     STD_LOGIC; --准备好标志
	SIGNAL now_state:   state;
	SIGNAL next_state:  state;
	
BEGIN

p1:PROCESS(now_state,rst)
BEGIN
	IF rst='1' THEN
		next_state<=s0;
	ELSE
		CASE now_state IS 
			WHEN s0=> --默认时四种状态顺次进行
				CASE in_cnt IS
					WHEN "00" =>
						next_state<=s1;
					WHEN "01" =>
						next_state<=s2;
					WHEN "10" =>
						next_state<=s3;
					WHEN others =>
						next_state<=s0;
				END CASE;
			WHEN s1=>
				IF in_cnt="01" THEN
					next_state<=s0;
				ELSE 
					next_state<=s1;
				END IF;
			WHEN s2=>
				IF in_cnt="10" OR flag='0' THEN
					next_state<=s0;
				ELSE 
					next_state<=s2;
				END IF;	
			WHEN s3=>
				IF ISxns='1' OR fail='1' OR flag='0'  THEN --庆祝或失败或复位时
					next_state<=s0;
				ELSE
					next_state<=s3;
				END IF;
			WHEN OTHERS=>
				next_state<=s0;
		END CASE;
	END IF;
END PROCESS;
	
p2:PROCESS(clk,rst)
BEGIN
	IF rst='1' THEN 
		now_state<=s0;
	ELSIF clk'EVENT AND clk='1' THEN
		now_state<=next_state;
	END IF;
END PROCESS; 
	
p3:PROCESS(now_state)
BEGIN
	CASE now_state IS
		WHEN s0=>
	CASE in_cnt IS --同步计数器进入四种状态
		WHEN "00" =>
			num1<=in_num;
		WHEN "01" =>
			num2<=in_num;
		WHEN "10" =>
			num3<=in_num;
		WHEN others =>
			num1<=in_num;
	END CASE;
	
	ISready<= '0'; --未开始
	flag<='0'; --复位允许标志
	
	WHEN s1=>
		ISready<= '1';
		out_num<=num1;
		flag<='0';
	
	WHEN s2=>
		IF num1/=num2 THEN --若num1与num2不等（两次出现的图形不同）
			flag <= '1';
			out_num<=num2;
			ISready<='1';
		ELSE 
			flag <='0';
			ISready<= '0';
	END IF;
	
	WHEN s3=>
		IF num1/=num3 AND num3/=num2 THEN --若num2与num1,num3不等（两次出现的图形不同）
			flag <= '1';
			out_num<=num3;
			ISready<='1';
		ELSE 
			flag <='0';
			ISready<= '0';
	END IF;
	
	WHEN OTHERS=>
		out_num<="0000";
		flag<='0';
		ISready<= '0';
	END CASE;
END PROCESS;

	pic_num<=out_num; --输出点阵状态数
	ready<=ISready;
	
END apic_st;