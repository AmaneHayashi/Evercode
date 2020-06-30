LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY key_st IS --����״̬
    PORT(
		clk:            IN STD_LOGIC;
		rst:            IN STD_LOGIC;
		ISkey:          IN STD_LOGIC;  --��������
		IS_key:         OUT STD_LOGIC; --�������뼤��
		
		keyin:          IN STD_LOGIC_VECTOR(3 downto 0);
		keyout:         OUT STD_LOGIC_VECTOR(3 downto 0)
		);
END key_st;

ARCHITECTURE akey_st of key_st IS 
	
	TYPE state IS(s0,s1);
	
	SIGNAL now_state:   state;
	SIGNAL next_state:  state;
	SIGNAL IScarry:     STD_LOGIC; --��λ�ź�
	SIGNAL temp_cnt:    STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL temp_key:    STD_LOGIC_VECTOR(3 downto 0);
	
BEGIN
	 
p1:PROCESS(now_state,rst)
BEGIN
	IF rst='1' THEN
		next_state<=s0;
	ELSE
		CASE now_state IS
			WHEN s0=>
				IF IScarry='0' THEN
					next_state<=s0;
				ELSE 
					next_state<=s1;
				END IF;
			WHEN s1=>
				IF ISkey='1' THEN
					next_state<=s1;
				ELSE
					next_state<=s0;
				END IF;
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
	 
p3:PROCESS(now_state) --����״̬��s0->Ĭ�ϣ�s1->�������뼤����
BEGIN
	CASE now_state IS
		WHEN s0=>
			IF ISkey='0' THEN --������ʱ
				temp_cnt<="0000";
				IScarry<='0';
			ELSE
				IF clk'EVENT AND clk='1' THEN --������ʱ�����Ƶ
					IF temp_cnt="0000" THEN
						temp_key<=keyin;
						temp_cnt<=temp_cnt+1;
						IScarry<='0';
					ELSE
						IF temp_key=keyin THEN --��ʮ����״̬s1
							IF temp_cnt="1001" THEN
								temp_cnt<="0000";
								IScarry<='1';
							ELSE
								temp_cnt<=temp_cnt+1;
								IScarry<='0';
							END IF;
						ELSE 
							temp_cnt<="0000";
							IScarry<='0';
						END IF;
					END IF;
				END IF;
	 		END IF;
		WHEN s1=>
			IScarry<='1';
			temp_key<=temp_key;
	 	WHEN OTHERS=>
	 		temp_cnt<="0000";
	 		IScarry<='0';
	 END CASE;
END PROCESS;

	 IS_key<=IScarry;
	 keyout<=temp_key;
	 
END akey_st;