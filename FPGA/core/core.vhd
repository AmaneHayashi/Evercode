LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY core IS --������
	PORT(
		mainclk:           IN STD_LOGIC;  --��ʱ�ӣ�50MHz��SW9�ϡ�1000����
		rst:               IN STD_LOGIC;  --��λ����BTN7��
		next_state:        IN STD_LOGIC;  --��һ�أ�BTN6��
		beepout:           OUT STD_LOGIC; --��������BEEP��
	
		key_row:           IN STD_LOGIC_vector(3 DOWNTO 0);  --�����У�KBROW��
		key_col:           OUT STD_LOGIC_vector(3 DOWNTO 0); --�����У�KBCOL��
		disp_num:          OUT STD_LOGIC_vector(6 DOWNTO 0); --�������ʾ��AA~AG��
		disp_cat:          OUT STD_LOGIC_vector(7 DOWNTO 0); --�����λ����CAT��
		row:               OUT STD_LOGIC_vector(7 DOWNTO 0); --�����У�ROW��
		colr:              OUT STD_LOGIC_vector(7 DOWNTO 0); --�����С���ɫ��COLR��
		colg:              OUT STD_LOGIC_vector(7 DOWNTO 0)  --�����С���ɫ��COLG��
		);
END core;

ARCHITECTURE acore OF core IS
COMPONENT dvdr IS --��Ƶ��
	PORT(
		mclk:              IN STD_LOGIC;  --��Ƶ50MHz
		rst:               IN STD_LOGIC;
		clk1:              OUT STD_LOGIC; --��Ƶ1
		clk2:              OUT STD_LOGIC; --��Ƶ2
		clk3:              OUT STD_LOGIC  --��Ƶ3
		);
END COMPONENT;

COMPONENT pic IS --15��״̬��Ϸ����
	PORT(
		clk1:              IN STD_LOGIC;  --Ƶ��2.5KHz
		clk2:              IN STD_LOGIC;  --Ƶ��2KHz
		rst:               IN STD_LOGIC;
		fail:              IN STD_LOGIC;
		ISxns:             IN STD_LOGIC;  --��Ϸʤ��
		ISready:           OUT STD_LOGIC; --��ʼ��Ϸ
		
		cnt:               IN STD_LOGIC_VECTOR(1 DOWNTO 0);  --״̬������
		max_path:          OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --�����
		col1:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END COMPONENT;	

COMPONENT dzn IS --�����߼�
	PORT(
		clk:               IN STD_LOGIC; --Ƶ��500Hz
		rst:               IN STD_LOGIC;
		ISxns:             IN STD_LOGIC; --ʤ��
		next_state:        IN STD_LOGIC;
		key:               IN STD_LOGIC;
		ISready:           IN STD_LOGIC;
		out_fail:          OUT STD_LOGIC;
		ISwin:             OUT STD_LOGIC;
	
		keyin:             IN STD_LOGIC_VECTOR(3 DOWNTO 0);  --��������
		path_max:          IN STD_LOGIC_VECTOR(6 DOWNTO 0);  --�����
		incol0:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol1:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol2:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		incol3:            IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		path:              OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --����
		pathe_max:         OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --�����
		col0:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col2:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col3:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col4:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		col5:              OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg1:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		colg2:             OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
END COMPONENT;

COMPONENT xns IS --��ף��ʧ�ܶ���
	PORT(
		clk:               IN STD_LOGIC;  --Ƶ��500Hz
        rst:               IN STD_LOGIC;
        win:               IN STD_LOGIC;  --ʤ��
		fail:              IN STD_LOGIC;  --ʧ��
        out_xns:           OUT STD_LOGIC; --ʤ��
        
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

COMPONENT key IS --��������
	PORT(
		clk:               IN STD_LOGIC; --Ƶ��500Hz
		rst:               IN STD_LOGIC;
		ISbutton:          OUT STD_LOGIC;
		
		keyin:             IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		keycol:            OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		key_place:         OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT disp IS --����ܼ���������
	PORT( 
		clk:               IN STD_LOGIC; --Ƶ��50MHz
     	rst:               IN STD_LOGIC;
     	ISxns:             IN STD_LOGIC; --ʤ��
     	ISfail:            IN STD_LOGIC; --ʧ��
     	
     	wintimes:          IN STD_LOGIC_VECTOR(1 DOWNTO 0);  --ʤ������
     	pathnum:           IN STD_LOGIC_VECTOR(6 DOWNTO 0);  --����
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
		disp_out:          OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --�������ʾ
		colg_out:          OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --��������̣�
		col_out:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --��������죩
		row_out:           OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --��ɨ��
		cat:               OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  --�����λ����0��Ч��
		);
END COMPONENT;

COMPONENT extr IS --���Ӳ���
	PORT(
		clk:               IN STD_LOGIC; --Ƶ��50MHz
		rst:               IN STD_LOGIC;
		ISxns:             IN STD_LOGIC; --ʤ��
		ISfail:            IN STD_LOGIC; --ʧ��
		beep:              OUT STD_LOGIC --������
		);
END COMPONENT;

	SIGNAL clk1:           STD_LOGIC; --��Ƶʱ��
	SIGNAL clk2:           STD_LOGIC; --��Ƶʱ��
	SIGNAL clk3:           STD_LOGIC; --��Ƶʱ��
	SIGNAL ISxns_temp:     STD_LOGIC; --��ף��־
	SIGNAL ISfail_temp:    STD_LOGIC; --ʧ�ܱ�־
	SIGNAL ISwin_temp:     STD_LOGIC; --ʤ����־
	SIGNAL ISkey_temp:     STD_LOGIC; --������־
	SIGNAL ISready_temp:   STD_LOGIC; --��ʼ��Ϸ��־
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
	SIGNAL maxpath:        STD_LOGIC_vector(6 DOWNTO 0); --�����
	SIGNAL button_place:   STD_LOGIC_vector(3 DOWNTO 0); --��������
	SIGNAL wintimes_temp:  STD_LOGIC_vector(1 DOWNTO 0); --ʤ������
	SIGNAL key_col_temp:   STD_LOGIC_vector(3 DOWNTO 0); --����������
	SIGNAL path_temp:      STD_LOGIC_vector(6 DOWNTO 0); --����
	SIGNAL maxpath_out:    STD_LOGIC_vector(6 DOWNTO 0); --�����
	SIGNAL disp_num_out:   STD_LOGIC_vector(6 DOWNTO 0); --�������ʾ
	SIGNAL colr_out:       STD_LOGIC_vector(7 DOWNTO 0); --�����У���ɫ��
	SIGNAL colg_out:       STD_LOGIC_vector(7 DOWNTO 0); --�����У���ɫ��
	SIGNAL row_out:        STD_LOGIC_vector(7 DOWNTO 0); --������
	SIGNAL disp_cat_out:   STD_LOGIC_vector(7 DOWNTO 0); --�����λ��
	
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