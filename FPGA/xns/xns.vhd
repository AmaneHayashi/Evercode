LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY xns IS --庆祝或失败动画
	PORT(
		clk:            IN STD_LOGIC;  --频率500Hz
        rst:            IN STD_LOGIC;
        win:            IN STD_LOGIC;  --胜利
		fail:           IN STD_LOGIC;  --失败
        out_xns:        OUT STD_LOGIC; --胜利
        
        out_cnt:        OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        out_col0:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col1:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col2:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col3:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col4:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col5:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col6:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col7:       OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END xns;

ARCHITECTURE axns OF xns IS
COMPONENT xns_add --胜利次数同步计数器
	PORT(
		ISwin:          IN STD_LOGIC;
		rst:            IN STD_LOGIC;
		
		cnt:            OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
END COMPONENT;

COMPONENT xns_pic --动画显示
    PORT(
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
END COMPONENT;

    SIGNAL win_cnt:     STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL temp_xns:    STD_LOGIC;

BEGIN

u1:xns_add PORT MAP( 
	ISwin=>win,
	rst=>rst,
	cnt=>win_cnt
	);

u2:xns_pic PORT MAP(
	clk=>clk,
	rst=>rst,
	fail=>fail,
	ISxns=>temp_xns,
	wintimes=>win_cnt,
	col0=>out_col0,
	col1=>out_col1,
	col2=>out_col2,
	col3=>out_col3,
	col4=>out_col4,
	col5=>out_col5,
	col6=>out_col6,
	col7=>out_col7
	);
	
	out_cnt<=win_cnt;
	out_xns<=temp_xns;
	
END axns;
