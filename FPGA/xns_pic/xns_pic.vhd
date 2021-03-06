LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY xns_pic IS --动画显示
    port(
        clk:            IN STD_LOGIC;
        rst:            IN STD_LOGIC; 
        fail:           IN STD_LOGIC;
        ISxns:          OUT STD_LOGIC;  
        
        wintimes:       IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        col0:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        col1:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        col2:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        col3:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        col4:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        col5:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        col6:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        col7:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
END xns_pic;

ARCHITECTURE axns_pic OF xns_pic IS
    
    TYPE state          IS (s0,s1,s2);
    
    SIGNAL now_state:   state;
    SIGNAL next_state:  state;
    SIGNAL num:         INTEGER RANGE 0 TO 101;
    
BEGIN
	
p1:PROCESS(now_state,rst) --三种状态（s0->正常，s1->胜利庆祝，s2->失败警告）
BEGIN
    IF rst='1' THEN
        next_state<=s0;
    ELSE
        CASE now_state IS
            WHEN s0=>
                IF wintimes="11" THEN
                    next_state<=s1;
	            ELSIF fail='1' THEN
                    next_state<=s2;
	            ELSE 
	                next_state<=s0;
                END IF;
            WHEN s1=>
                next_state<=s1;
            WHEN s2=>
                next_state<=s2;
	        WHEN OTHERS =>
	            next_state <=s0;
        END CASE;
    END IF;
END PROCESS;

p2:PROCESS(clk,rst)
BEGIN
    IF rst='1' THEN 
        now_state<=s0;
    ELSE
        now_state<=next_state;
    END IF;
END PROCESS; 
	 
pp:PROCESS(rst,clk)--动画每帧时间
BEGIN
    IF rst='1' THEN
	    num<=0;
	ELSIF clk'event and clk='1' THEN
	    IF num=100 THEN
	        num<=0;
	    ELSE
	        num<=num+1;
	    END IF ;
	END IF;
END PROCESS;

p3:PROCESS(now_state,wintimes)
BEGIN
	CASE now_state IS
	    WHEN s0 =>
			col0<="ZZZZZZZZ";
			col1<="ZZZZZZZZ";
			col2<="ZZZZZZZZ";
			col3<="ZZZZZZZZ";
			col4<="ZZZZZZZZ";
			col5<="ZZZZZZZZ";
			col6<="ZZZZZZZZ";
			col7<="ZZZZZZZZ";
   		WHEN s1=>--SUCCESS
	 		IF num<33 THEN--显示W
	 			col0<="10000001";
	 			col1<="10000001";
	 			col2<="10000001";
	 			col3<="10000001";
	 			col4<="01000010";
	 			col5<="01011010";
	 			col6<="01011010";
				col7<="00100100";
			 ELSIF num>32 and num<66 THEN--显示I
	 			col0<="00111100";
	 			col1<="00011000";
	 			col2<="00011000";
	 			col3<="00011000";
	 			col4<="00011000";
	 			col5<="00011000";
	 			col6<="00011000";
	 			col7<="00111100";
			 ELSE--显示N
	 			col0<="10000000";
	 			col1<="10000010";
	 			col2<="10000101";
	 			col3<="10001001";
	 			col4<="10010001";
				col5<="10100001";
	 			col6<="01000001";
	 			col7<="00000001";
	 		END IF;
	 	WHEN s2=>--WRONG
			IF num<33 THEN--显示E
	  			col0<="01111110";
	  			col1<="00000010";
	  			col2<="00000010";
	  			col3<="01111110";
	  			col4<="01111110";
	  			col5<="00000010";
	  			col6<="00000010";
	  			col7<="01111110";
	 		ELSIF num>32 and num<66 THEN--显示N
	  			col0<="10000000";
	  			col1<="10000010";
	  			col2<="10000101";
	  			col3<="10001001";
	  			col4<="10010001";
	  			col5<="10100001";
	  			col6<="01000001";
	  			col7<="00000001";
	 		 ELSE--显示D
	  			col0<="00011110";
	  			col1<="00100010";
	  			col2<="01000010";
	  			col3<="01000010";
	  			col4<="01000010";
	  			col5<="01000010";
	  			col6<="00100010";
	  			col7<="00011110";
		  END IF;
		  WHEN OTHERS =>
	 	 	 	col0<="ZZZZZZZZ";
	  			col1<="ZZZZZZZZ";
	 		    col2<="ZZZZZZZZ";
	 			col3<="ZZZZZZZZ";
	 			col4<="ZZZZZZZZ";
	  			col5<="ZZZZZZZZ";
	 			col6<="ZZZZZZZZ";
	 	 	 	col7<="ZZZZZZZZ";
	 END CASE;
END PROCESS;

px:PROCESS(wintimes)
BEGIN
	IF wintimes="11"THEN--当赢下3局时
		ISxns<='1';
	ELSE
		ISxns<='0';
	END IF;
END PROCESS;
	
END axns_pic;