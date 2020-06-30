library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.STD_LOGIC_ARITH.all;

entity jishu is --����ܼ���������
	port( 
		clk:in std_logic;--Ƶ��50MHz
     	rst:in std_logic;
     	iswin:in std_logic;--ʤ��
     	isfail: in std_logic;--ʧ��
     	col0:in std_logic_vector(7 downto 0);
     	col1:in std_logic_vector(7 downto 0);
		col2:in std_logic_vector(7 downto 0);
		col3:in std_logic_vector(7 downto 0);
		col4:in std_logic_vector(7 downto 0);
		col5:in std_logic_vector(7 downto 0);
		col6:in std_logic_vector(7 downto 0);
		col7:in std_logic_vector(7 downto 0);
	    colg1:in std_logic_vector(7 downto 0);
		colg2:in std_logic_vector(7 downto 0);
		colg_out:out std_logic_vector(7 downto 0); --��������̣�
		col_out:out std_logic_vector(7 downto 0); --��������죩
		row_out:out std_logic_vector(7 downto 0); --��ɨ��
		pathnum:in std_logic_vector(6 downto 0); --����
		wintimes:in std_logic_vector(1 downto 0); --ʤ������
		cat:out std_logic_vector(7 downto 0); --�����λ����0��Ч��
		disp_out:out std_logic_vector(6 downto 0); --�������ʾ
		);
end jishu;

architecture ajishu of jishu is
	type state is(s0,s1,s2,s3,s4,s5,s6,s7);
	type state2 is(ss0,ss1,ss2,ss3);
	signal cnt1:integer range 0 to 250000;
	signal cnt2:integer range 0 to 250000;
	signal scan_clk:std_logic;
	signal disp_clk:std_logic;
	signal state_now,state_next:state2;
	signal now_state,next_state:state;
	signal int_pathnum:integer range 0 to 99; --ʣ�ಽ������λʮ��������
	signal high_digit:integer range 0 to 9; --ʣ�ಽ������λʮ���������ĸ�λ
	signal low_digit:integer range 0 to 9; --ʣ�ಽ������λʮ���������ĵ�λ
	signal residue:integer;
begin

p1:process(clk,rst) --��Ƶ��
begin
	if rst='1' then
		cnt1<=0;
	elsif clk'event and clk='1' then
		if cnt1 = 25000 then --��Ƶ��Ƶ��1KHz
			cnt1<=0;
			scan_clk<= not scan_clk;
		else
			cnt1<=cnt1+1;
		end if;
	end if;
end process;
		
p2:process(now_state,rst)
begin
	if rst='1' then
		next_state<=s0;
	else
		case now_state is
			when s0=> next_state<=s1;
			when s1=> next_state<=s2;
			when s2=> next_state<=s3;
			when s3=> next_state<=s4;
			when s4=> next_state<=s5;
			when s5=> next_state<=s6;
			when s6=> next_state<=s7;
			when s7=> next_state<=s0;
			when others=> next_state<=s0;
		end case;
	end if;
end process;
		
p3:process(scan_clk)
begin
	if rst='1' then
		now_state<=s0;
	elsif scan_clk'event and scan_clk='1' then
		now_state<=next_state;
	end if;
end process;
		
p4:process(now_state) --8��״̬����ʾ��ɨ����8�е����״̬
begin
	case now_state is
		when s0=>
			if iswin='0' and isfail='0' then
				col_out<=col0;
				colg_out<=col0;
			else
				col_out<=col0;
				colg_out<="00000000";
			end if;
			row_out<="01111111";
		when s1=>
			if iswin='0' and isfail='0' then
				col_out<=col0;
				colg_out<=colg1;
			else
				col_out<=col1;
				colg_out<="00000000";
			end if;
				row_out<="10111111";
		when s2=>
			if iswin='0' and isfail='0'  then
				col_out<=col2;
				colg_out<=colg2;
			else
				col_out<=col2;
				colg_out<="00000000";
			end if;
			row_out<="11011111";
		when s3=>
			if iswin='0' and isfail='0'  then
				col_out<=col3;
				colg_out<=colg2;
			else
				col_out<=col3;
				colg_out<="00000000";
			end if;
				row_out<="11101111";
		when s4=>
			if iswin='0'and isfail='0'  then
				col_out<=col4;
				colg_out<=colg2;
			else
				col_out<=col4;
				colg_out<="00000000";
			end if;
			row_out<="11110111";
		when s5=>
			if iswin='0'and isfail='0'  then
				col_out<=col5;
				colg_out<=colg2;
			else
				col_out<=col5;
				colg_out<="00000000";
			end if;
			row_out<="11111011";
		when s6=>
			if iswin='0'and isfail='0'  then
				col_out<=col0;
				colg_out<=colg1;
			else
				col_out<=col6;
				colg_out<="00000000";
			end if;
			row_out<="11111101";
		when s7=>
			if iswin='0'and isfail='0'  then
				col_out<=col0;
				colg_out<=col0;
			else
				col_out<=col7;
				colg_out<="00000000";
			end if;
			row_out<="11111110";
		when others=>
			col_out<="00000000";
			row_out<="11111111";
	end case;
end process;
		
p5:process(clk,rst) --��Ƶ������ʱ�ӻ�����أ�
begin
	if rst='1' then
		cnt2<=0;
	elsif clk'event and clk='1' then
		if cnt2 = 25000 then --��Ƶ��Ƶ��1KHz
			cnt2<=0;
			disp_clk<= not disp_clk;
		else
			cnt2<=cnt2+1;
		end if;
	end if;
end process;
		
p6:process(state_now,rst)
begin
	if rst='1' then
		state_next<=ss0;
	else
		if iswin='0' and isfail = '0'then
			case state_now is
				when ss0=> state_next<=ss1;
				when ss1=> state_next<=ss2;
				when ss2=> state_next<=ss0;
				when others=> state_next<=ss0;
			end case;
		else 
			state_next<=ss3;
		end if;
	end if;
end process;
		
p7:process(disp_clk)
begin
	if rst='1' then
		state_now<=ss0;
	elsif disp_clk'event and disp_clk='1' then
		state_now<=state_next;
	end if;
end process;
		
p8:process(state_now)
begin 
	case state_now is
		when ss0=>--ʤ����������ܣ���8λ��ʾ��
			case wintimes is
				when "00" => disp_out<="1111110";
				when "01" => disp_out<="0110000";
				when "10" => disp_out<="1101101";
				when "11" => disp_out<="1111001";
				when others => disp_out<="0000000";
			end case;
			cat<="11111110";
		when ss1 =>--ʣ�ಽ������ܣ�ʮλ����3λ��ʾ��
			case high_digit is
				when 0 => disp_out<="1111110";
				when 1 => disp_out<="0110000";
				when 2 => disp_out<="1101101";
				when 3 => disp_out<="1111001";
				when 4 => disp_out<="0110011";
				when 5 => disp_out<="1011011";
				when 6 => disp_out<="1011111";
				when 7 => disp_out<="1110000";
				when 8 => disp_out<="1111111";
				when 9 => disp_out<="1111011";
				when others => disp_out<="0000000";
			end case;
			cat<="11011111";
		when ss2 =>--ʣ�ಽ������ܣ���λ����4λ��ʾ��
			case low_digit is
				when 0 => disp_out<="1111110";
				when 1 => disp_out<="0110000";
				when 2 => disp_out<="1101101";
				when 3 => disp_out<="1111001";
				when 4 => disp_out<="0110011";
				when 5 => disp_out<="1011011";
				when 6 => disp_out<="1011111";
				when 7 => disp_out<="1110000";
				when 8 => disp_out<="1111111";
				when 9 => disp_out<="1111011";
				when others => disp_out<="0000000";
			end case;
			cat<="11101111";
		when ss3=>
			cat<="11111111";
			disp_out<="0000000";
		when others =>
			cat<="11111111";
			disp_out<="0000000";
	end case;
end process;

p9:process(pathnum)--ʮλ���λ�����
begin
	int_pathnum<=CONV_INTEGER(pathnum);
	residue<= 12-int_pathnum;
	if residue>9 then
		high_digit<=residue/10;
		low_digit<=residue-10*high_digit;
	else
		high_digit<=0;
		low_digit<=residue;
	end if;
end process;
		
end ajishu;
			
			