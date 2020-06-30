LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY core IS --主程序
	PORT(
		mainclk:           IN STD_LOGIC;  --主时钟（50MHz，SW9上“1000”）
		rst:               IN STD_LOGIC;  --复位键（BTN7）
		next_state:        IN STD_LOGIC;  --下一关（BTN6）
		beepout:           OUT STD_LOGIC; --蜂鸣器（BEEP）
	
		key_row:           IN STD_LOGIC_vector(3 DOWNTO 0);  --键盘行（KBROW）
		key_col:           OUT STD_LOGIC_vector(3 DOWNTO 0); --键盘列（KBCOL）
		disp_num:          OUT STD_LOGIC_vector(6 DOWNTO 0); --数码管显示（AA~AG）
		disp_cat:          OUT STD_LOGIC_vector(7 DOWNTO 0); --数码管位数（CAT）
		row:               OUT STD_LOGIC_vector(7 DOWNTO 0); --点阵行（ROW）
		colr:              OUT STD_LOGIC_vector(7 DOWNTO 0); --点阵列·红色（COLR）
		colg:              OUT STD_LOGIC_vector(7 DOWNTO 0)  --点阵列·绿色（COLG）
		);
END core;

ARCHITECTURE acore OF core IS
COMPONENT dvdr IS --分频器
	PORT(
		mclk:              IN STD_LOGIC;  --主频50MHz
		rst:               IN STD_LOGIC;
		clk1:              OUT STD_LOGIC; --分频1
		clk2:              OUT STD_LOGIC; --分频2
		clk3:              OUT STD_LOGIC  --分频3
		);
END COMPONENT;

COMPONENT pic IS --15种状态游戏界面
	PORT(
		clk1:              IN STD_LOGIC;  --频率2.5KHz
		clk2:              IN STD_LOGIC;  --频率2KHz
		rst:               IN STD_LOGIC;
		fail:              IN STD_LOGIC;
		ISxns:             IN STD_LOGIC;  --游戏胜利
		ISready:           OUT STD_LOGIC; --开始游戏
		
		cnt:               IN STD_LOGIC_VECTOR(1 DOWNTO 0);  --状态计数器
		max_path:          OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --最大步数
		col1:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END COMPONENT;	

COMPONENT dzn IS --点阵逻辑
	PORT(
		clk:               IN STD_LOGIC; --频率500Hz
		rst:               IN STD_LOGIC;
		ISxns:             IN STD_LOGIC; --胜利
		next_state:        IN STD_LOGIC;
		key:               IN STD_LOGIC;
		ISready:           IN STD_LOGIC;
		out_fail:          OUT STD_LOGIC;
		ISwin:             OUT STD_LOGIC;
	
		keyin:             IN STD_LOGIC_VECTOR(3 DOWNTO 0);  --键盘输入
		path_max:          IN STD_LOGIC_VECTOR(6 DOWNTO 0);  --最大步数
		incol0:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol1:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol2:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol3:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		path:              OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --步数
		pathe_max:         OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --最大步数
		col0:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col5:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg1:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg2:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END COMPONENT;

COMPONENT xns IS --庆祝或失败动画
	PORT(
		clk:               IN STD_LOGIC;  --频率500Hz
        rst:               IN STD_LOGIC;
        win:               IN STD_LOGIC;  --胜利
		fail:              IN STD_LOGIC;  --失败
        out_xns:           OUT STD_LOGIC; --胜利
        
        out_cnt:           OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        out_col0:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col1:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col2:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col3:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col4:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col5:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col6:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_col7:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END COMPONENT;

COMPONENT key IS --键盘输入
	PORT(
		clk:               IN STD_LOGIC; --频率500Hz
		rst:               IN STD_LOGIC;
		ISbutton:          OUT STD_LOGIC;
		
		keyin:             IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		keycol:            OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		key_place:         OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT disp IS --数码管计数与设置
	PORT( 
		clk:               IN STD_LOGIC; --频率50MHz
     	rst:               IN STD_LOGIC;
     	ISxns:             IN STD_LOGIC; --胜利
     	ISfail:            IN STD_LOGIC; --失败
     	
     	wintimes:          IN STD_LOGIC_VECTOR(1 DOWNTO 0);  --胜利次数
     	pathnum:           IN STD_LOGIC_VECTOR(6 DOWNTO 0);  --步数
     	col0:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
     	col1:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col5:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col6:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		col7:              IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    colg1:             IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg2:             IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		disp_out:          OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --数码管显示
		colg_out:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --列输出（绿）
		col_out:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --列输出（红）
		row_out:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --行扫描
		cat:               OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  --数码管位数（0有效）
		);
END COMPONENT;

COMPONENT extr IS --附加部分
	PORT(
		clk:               IN STD_LOGIC; --频率50MHz
		rst:               IN STD_LOGIC;
		ISxns:             IN STD_LOGIC; --胜利
		ISfail:            IN STD_LOGIC; --失败
		beep:              OUT STD_LOGIC --蜂鸣器
		);
END COMPONENT;

	SIGNAL clk1:           STD_LOGIC; --分频时钟
	SIGNAL clk2:           STD_LOGIC; --分频时钟
	SIGNAL clk3:           STD_LOGIC; --分频时钟
	SIGNAL ISxns_temp:     STD_LOGIC; --庆祝标志
	SIGNAL ISfail_temp:    STD_LOGIC; --失败标志
	SIGNAL ISwin_temp:     STD_LOGIC; --胜利标志
	SIGNAL ISkey_temp:     STD_LOGIC; --按键标志
	SIGNAL ISready_temp:   STD_LOGIC; --开始游戏标志
	SIGNAL mcol1:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL mcol2:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL mcol3:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL mcol4:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol0:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol1:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol2:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol3:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol4:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol5:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol6:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scol7:          STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scolg1:         STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL scolg2:         STD_LOGIC_vector(7 DOWNTO 0);
	SIGNAL maxpath:        STD_LOGIC_vector(6 DOWNTO 0); --最大步数
	SIGNAL button_place:   STD_LOGIC_vector(3 DOWNTO 0); --按键坐标
	SIGNAL wintimes_temp:  STD_LOGIC_vector(1 DOWNTO 0); --胜利次数
	SIGNAL key_col_temp:   STD_LOGIC_vector(3 DOWNTO 0); --按键列坐标
	SIGNAL path_temp:      STD_LOGIC_vector(6 DOWNTO 0); --步数
	SIGNAL maxpath_out:    STD_LOGIC_vector(6 DOWNTO 0); --最大步数
	SIGNAL disp_num_out:   STD_LOGIC_vector(6 DOWNTO 0); --数码管显示
	SIGNAL colr_out:       STD_LOGIC_vector(7 DOWNTO 0); --点阵列（红色）
	SIGNAL colg_out:       STD_LOGIC_vector(7 DOWNTO 0); --点阵列（绿色）
	SIGNAL row_out:        STD_LOGIC_vector(7 DOWNTO 0); --点阵行
	SIGNAL disp_cat_out:   STD_LOGIC_vector(7 DOWNTO 0); --数码管位数
	
begin 
u1:dvdr PORT MAP(
	mclk=>mainclk,
	rst=>rst,
	clk1=>clk1,
	clk2=>clk2,
	clk3=>clk3
	);

u2:pic PORT MAP(
	clk1=>clk1,
	clk2=>clk3,
	rst=>rst,
	ISxns=>ISxns_temp,
	fail=>ISfail_temp,
	cnt=>wintimes_temp,
	ISready=>ISready_temp,
	col1=>mcol1,
	col2=>mcol2,
	col3=>mcol3,
	col4=>mcol4,
	max_path=>maxpath
	);

u3:dzn PORT MAP(
	clk=>clk2,
	rst=>rst,
	ISxns=>ISxns_temp,
	next_state=>next_state,
	key=>ISkey_temp,
	keyin=>button_place,
	path_max=>maxpath,
	pathe_max=>maxpath_out,
	out_fail=>ISfail_temp,
	path=>path_temp,
	ISready=>ISready_temp,
	ISwin=>ISwin_temp,
	incol0=>mcol1,
	incol1=>mcol2,
	incol2=>mcol3,
	incol3=>mcol4,
	col0=>scol0,
	col2=>scol2,
	col3=>scol3,	
	col4=>scol4,	
	col5=>scol5,	
	colg1=>scolg1,  
	colg2=>scolg2
	);

u4:xns PORT MAP(
	clk=>clk2,
	rst=>rst,
	win=>ISwin_temp,
	fail=>ISfail_temp,
	out_xns=>ISxns_temp,
	out_col0=>scol0,
	out_col1=>scol1,
	out_col2=>scol2,
	out_col3=>scol3,
	out_col4=>scol4,
	out_col5=>scol5,
	out_col6=>scol6,
	out_col7=>scol7, 
	out_cnt=>wintimes_temp
	);

u5:key PORT MAP(
	clk=>clk2,
	rst=>rst,
	keyin=>key_row,
	keycol=>key_col_temp,
	ISbutton=>ISkey_temp,
	key_place=>button_place
	);

u6:disp PORT MAP(
	clk=>mainclk,
	rst=>rst,
	ISxns=>ISxns_temp,
	ISfail=>ISfail_temp,
	wintimes=>wintimes_temp,
	pathnum=>path_temp,
	col0=>scol0,
	col1=>scol1,
	col2=>scol2,
	col3=>scol3,
	col4=>scol4,
	col5=>scol5,
	col6=>scol6,
	col7=>scol7,
	colg1=>scolg1,
	colg2=>scolg2,
	disp_out=>disp_num_out,
	colg_out=>colg_out,
	col_out=>colr_out,
	row_out=>row_out,
	cat=>disp_cat_out
	);

u7:extr PORT MAP(
	clk=>mainclk,
	rst=>rst,
	ISxns=>ISxns_temp,
	ISfail=>ISfail_temp,
	beep=>beepout
	);

	row<=row_out;
	colr<=colr_out;
	colg<=colg_out;
	disp_num<=disp_num_out;
	disp_cat<=disp_cat_out;
	key_col<=key_col_temp;

END acore;