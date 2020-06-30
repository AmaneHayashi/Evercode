LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY disp IS --数码管计数与设置
	PORT( 
		clk:                      IN STD_LOGIC; --频率50MHz
     	rst:                      IN STD_LOGIC;
     	ISxns:                    IN STD_LOGIC; --胜利
     	ISfail:                   IN STD_LOGIC; --失败
     	
     	wintimes:                 IN STD_LOGIC_VECTOR(1 DOWNTO 0); --胜利次数
     	pathnum:                  IN STD_LOGIC_VECTOR(6 DOWNTO 0); --步数
     	col0:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
     	col1:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col5:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col6:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col7:                     IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    colg1:                    IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg2:                    IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		disp_out:                 OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --数码管显示
		colg_out:                 OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --列输出（绿）
		col_out:                  OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --列输出（红）
		row_out:                  OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --行扫描
		cat:                      OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  --数码管位数（0有效）
		);
END disp;

architecture adisp OF disp IS
	TYPE state                    IS(s0,s1,s2,s3,s4,s5,s6,s7);
	TYPE state2                   IS(ss0,ss1,ss2,ss3);
	
	SIGNAL state_now,state_next:  state2;
	SIGNAL now_state,next_state:  state;	
	SIGNAL residue:               INTEGER;
	SIGNAL scan_clk:              std_logic;
	SIGNAL disp_clk:              std_logic;
	SIGNAL cnt1:                  INTEGER RANGE 0 TO 250000;
	SIGNAL cnt2:                  INTEGER RANGE 0 TO 250000;
	SIGNAL int_pathnum:           INTEGER RANGE 0 TO 99; --剩余步数（二位十进制数）
	SIGNAL high_digit:            INTEGER RANGE 0 TO 9;  --剩余步数（二位十进制数）的高位
	SIGNAL low_digit:             INTEGER RANGE 0 TO 9;  --剩余步数（二位十进制数）的低位
	
BEGIN

p1:PROCESS(clk,rst) --分频器
BEGIN
	IF rst='1' THEN
		cnt1<=0;
	ELSIF clk'EVENT AND clk='1' THEN
		IF cnt1 = 25000 THEN --分频后，频率1KHz
			cnt1<=0;
			scan_clk<= NOT scan_clk;
		ELSE
			cnt1<=cnt1+1;
		END IF;
	END IF;
END PROCESS;
		
p2:PROCESS(now_state,rst)
BEGIN
	IF rst='1' THEN
		next_state<=s0;
	ELSE
		CASE now_state IS
			WHEN s0=> next_state<=s1;
			WHEN s1=> next_state<=s2;
			WHEN s2=> next_state<=s3;
			WHEN s3=> next_state<=s4;
			WHEN s4=> next_state<=s5;
			WHEN s5=> next_state<=s6;
			WHEN s6=> next_state<=s7;
			WHEN s7=> next_state<=s0;
			WHEN OTHERS=> next_state<=s0;
		END CASE;
	END IF;
END PROCESS;
		
p3:PROCESS(scan_clk)
BEGIN
	IF rst='1' THEN
		now_state<=s0;
	ELSIF scan_clk'EVENT AND scan_clk='1' THEN
		now_state<=next_state;
	END IF;
END PROCESS;
		
p4:PROCESS(now_state) --8种状态，表示行扫描下8列点阵的状态
BEGIN
	CASE now_state IS
		WHEN s0=> --（行扫描）第一列
			IF ISxns='0' AND ISfail='0' THEN
				col_out<=col0;
				colg_out<=col0;
			ELSE
				col_out<=col0;
				colg_out<="00000000";
			END IF;
			row_out<="01111111";
		WHEN s1=> --（行扫描）第二列
			IF ISxns='0' AND ISfail='0' THEN
				col_out<=col0;
				colg_out<=colg1;
			ELSE
				col_out<=col1;
				colg_out<="00000000";
			END IF;
				row_out<="10111111";
		WHEN s2=> --（行扫描）第三列
			IF ISxns='0' AND ISfail='0'  THEN
				col_out<=col2;
				colg_out<=colg2;
			ELSE
				col_out<=col2;
				colg_out<="00000000";
			END IF;
			row_out<="11011111";
		WHEN s3=> --（行扫描）第四列
			IF ISxns='0' AND ISfail='0'  THEN
				col_out<=col3;
				colg_out<=colg2;
			ELSE
				col_out<=col3;
				colg_out<="00000000";
			END IF;
				row_out<="11101111";
		WHEN s4=> --（行扫描）第五列
			IF ISxns='0'AND ISfail='0'  THEN
				col_out<=col4;
				colg_out<=colg2;
			ELSE
				col_out<=col4;
				colg_out<="00000000";
			END IF;
			row_out<="11110111";
		WHEN s5=> --（行扫描）第六列
			IF ISxns='0'AND ISfail='0'  THEN
				col_out<=col5;
				colg_out<=colg2;
			ELSE
				col_out<=col5;
				colg_out<="00000000";
			END IF;
			row_out<="11111011";
		WHEN s6=> --（行扫描）第七列
			IF ISxns='0'AND ISfail='0'  THEN
				col_out<=col0;
				colg_out<=colg1;
			ELSE
				col_out<=col6;
				colg_out<="00000000";
			END IF;
			row_out<="11111101";
		WHEN s7=> --（行扫描）第八列
			IF ISxns='0'AND ISfail='0'  THEN
				col_out<=col0;
				colg_out<=col0;
			ELSE
				col_out<=col7;
				colg_out<="00000000";
			END IF;
			row_out<="11111110";
		WHEN OTHERS=>
			col_out<="00000000";
			row_out<="11111111";
	END CASE;
END PROCESS;
		
p5:PROCESS(clk,rst) --分频器（两时钟互不相关）
BEGIN
	IF rst='1' THEN
		cnt2<=0;
	ELSIF clk'EVENT AND clk='1' THEN
		IF cnt2 = 25000 THEN --分频后，频率1KHz
			cnt2<=0;
			disp_clk<= NOT disp_clk;
		ELSE
			cnt2<=cnt2+1;
		END IF;
	END IF;
END PROCESS;
		
p6:PROCESS(state_now,rst) --3种状态，表示数码管3位（剩余步数2位，胜利次数1位）
BEGIN
	IF rst='1' THEN
		state_next<=ss0;
	ELSE
		IF ISxns='0' AND ISfail = '0'THEN
			CASE state_now IS
				WHEN ss0=> state_next<=ss1;
				WHEN ss1=> state_next<=ss2;
				WHEN ss2=> state_next<=ss0;
				WHEN OTHERS=> state_next<=ss0;
			END CASE;
		ELSE 
			state_next<=ss3;
		END IF;
	END IF;
END PROCESS;
		
p7:PROCESS(disp_clk)
BEGIN
	IF rst='1' THEN
		state_now<=ss0;
	ELSIF disp_clk'EVENT AND disp_clk='1' THEN
		state_now<=state_next;
	END IF;
END PROCESS;
		
p8:PROCESS(state_now)
BEGIN 
	CASE state_now IS
		WHEN ss0=> --胜利次数数码管（第8位显示）
			CASE wintimes IS
				WHEN "00" => disp_out<="1111110";
				WHEN "01" => disp_out<="0110000";
				WHEN "10" => disp_out<="1101101";
				WHEN "11" => disp_out<="1111001";
				WHEN OTHERS => disp_out<="0000000";
			END CASE;
			cat<="11111110";
		WHEN ss1 => --剩余步数数码管（十位，第3位显示）
			CASE high_digit IS
				WHEN 0 => disp_out<="1111110";
				WHEN 1 => disp_out<="0110000";
				WHEN 2 => disp_out<="1101101";
				WHEN 3 => disp_out<="1111001";
				WHEN 4 => disp_out<="0110011";
				WHEN 5 => disp_out<="1011011";
				WHEN 6 => disp_out<="1011111";
				WHEN 7 => disp_out<="1110000";
				WHEN 8 => disp_out<="1111111";
				WHEN 9 => disp_out<="1111011";
				WHEN OTHERS => disp_out<="0000000";
			END CASE;
			cat<="11011111";
		WHEN ss2 => --剩余步数数码管（个位，第4位显示）
			CASE low_digit IS
				WHEN 0 => disp_out<="1111110";
				WHEN 1 => disp_out<="0110000";
				WHEN 2 => disp_out<="1101101";
				WHEN 3 => disp_out<="1111001";
				WHEN 4 => disp_out<="0110011";
				WHEN 5 => disp_out<="1011011";
				WHEN 6 => disp_out<="1011111";
				WHEN 7 => disp_out<="1110000";
				WHEN 8 => disp_out<="1111111";
				WHEN 9 => disp_out<="1111011";
				WHEN OTHERS => disp_out<="0000000";
			END CASE;
			cat<="11101111";
		WHEN ss3=>
			cat<="11111111";
			disp_out<="0000000";
		WHEN OTHERS =>
			cat<="11111111";
			disp_out<="0000000";
	END CASE;
END PROCESS;

p9:PROCESS(pathnum) --十位与个位的求解
BEGIN
	int_pathnum<=CONV_INTEGER(pathnum); --转换为int
	residue<= 12-int_pathnum;
	IF residue>9 THEN --剩余步数大于10时，商给高位，余数给低位
		high_digit<=residue/10;
		low_digit<=residue-10*high_digit;
	ELSE --剩余步数小于10时，高位为0，低位为剩余步数
		high_digit<=0;
		low_digit<=residue;
	END IF;
END PROCESS;
		
END adisp;
			
			