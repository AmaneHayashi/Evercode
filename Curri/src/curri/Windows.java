package curri;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.regex.Pattern;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextArea;
import javax.swing.SwingConstants;

public class Windows extends JFrame implements ActionListener, Parameters {

	private static final long serialVersionUID = 6913793519621015181L;

	private JPanel jpUp, jpCenter, jpDown, jpFinal;
	private JTextArea jt;
	private JButton jb1, jb2;
	private JRadioButton jr1, jr2;
	private ButtonGroup bg;
	int i = 0;

	public Windows() {
		FontClass.loadIndyFont();
		ColorClass.loadIndyColor();

		jpUp = new JPanel(new GridLayout(1, 2, 5, 5));
		jpCenter = new JPanel(new GridLayout(2, 2, 5, 5));
		jpDown = new JPanel(new BorderLayout(5, 5));
		jpFinal = new JPanel(new GridLayout(1, 2, 60, 15));

		jr1 = new JRadioButton("空教室查询");
		jr2 = new JRadioButton("教室课表查询");
		bg = new ButtonGroup();
		bg.add(jr1);
		bg.add(jr2);
		jr1.setHorizontalAlignment(SwingConstants.CENTER);
		jr2.setHorizontalAlignment(SwingConstants.CENTER);
		jr1.addActionListener(this);
		jr2.addActionListener(this);
		jpUp.add(jr1);
		jpUp.add(jr2);

		jb1 = new JButton("查询");
		jb1.addActionListener(this);
		jb1.setEnabled(false);
		jb2 = new JButton("退出");
		jb2.addActionListener(this);

		jpFinal.add(jb1);
		jpFinal.add(jb2);

		jt = new JTextArea();
		jt.setLineWrap(true);
		jt.setRows(15);
		jt.setEnabled(false);
		
		jpDown.add(jt, BorderLayout.NORTH);
		jpDown.add(jpFinal, BorderLayout.SOUTH);
		
		add(jpUp, BorderLayout.NORTH);
	//	add(jpCenter, BorderLayout.CENTER);
		add(jpDown, BorderLayout.SOUTH);

		setTitle("Classroom Helper");
		setBounds(100, 100, 580, 640);
		setResizable(false);
		setVisible(true);
	//	pack();
		setDefaultCloseOperation(EXIT_ON_CLOSE);
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		if (e.getSource().equals(jr1)) {
			setJpCenter(jrs1, hint1);
			jt.setText(tip1);
		} else if (e.getSource().equals(jr2)) {
			setJpCenter(jrs2, hint2);
			jt.setText(tip2);
		} else if (e.getSource().equals(jb1)) {
			String s[] = new String[jpCenter.getComponentCount()];
			for (int i = 0; i < jpCenter.getComponentCount(); i++) {
				s[i] = MyCombinedTextField.getTextField(i, jpCenter).getText().trim();
				if (s[i].isEmpty()) {
					JOptionPane.showMessageDialog(null, "请确保所有信息填写完整！");
					return;
				}
			}
			if (!isMismatch(s)) {
				JOptionPane.showMessageDialog(null, "请确保所有信息格式正确！");
				return;
			}
			String value = "";// 输出结果
			int REQ_WEEK = Integer.parseInt(s[0]);
			int REQ_WKD = Integer.parseInt(s[1]);
			int REQ_PLACE = 0;
			String REQ_SSN = "";// 节数（a,b）

			if (!(REQ_WKD >= 1 && REQ_WKD <= 7)) {
				JOptionPane.showMessageDialog(null, "星期数必须在1~7之间！");
				return;
			} else if (!(REQ_WEEK >= 1 && REQ_WEEK <= 16)) {
				JOptionPane.showMessageDialog(null, "上课周数必须在1~16之间！");
				return;
			}

			if (jr1.isSelected()) {
				int SSN_HEADER = Integer.parseInt(s[2]);
				int SSN_TAILER = Integer.parseInt(s[3]);
				int result[] = null;// 总值
				if (SSN_HEADER >= SSN_TAILER)
					JOptionPane.showMessageDialog(null, "起始节次必须小于终止节次！");
				else if (!(SSN_HEADER >= 1 && SSN_TAILER <= 11))
					JOptionPane.showMessageDialog(null, "上课节次必须在1~11之间！");
				else {
					if (SSN_TAILER - SSN_HEADER > 1) {
						for (int i = SSN_HEADER; i <= SSN_TAILER; i++)
							REQ_SSN += "" + i + ",";
						REQ_SSN = REQ_SSN.substring(0, REQ_SSN.length() - 1);
					} else
						REQ_SSN = "" + SSN_HEADER + "," + "" + SSN_TAILER;
					try {
						result = new ExcelTools(REQ_WKD, REQ_SSN, REQ_WEEK, 0).filterCurri();
					} catch (IOException e1) {
						e1.printStackTrace();
					}
					for (int i = 0; i < result.length; i++)
						if (result[i] > 0)
							value += (result[i] + " ");
					jt.setText("当前的空教室有（仅含教三楼）：\n" + value);
				}
			} else if (jr2.isSelected()) {
				REQ_PLACE = Integer.parseInt(s[3]);
				String[] rep = ExcelTools.str2array(s[2], "~");
				String result = null;// 总值
				if (rep.length != 2)
					JOptionPane.showMessageDialog(null, "输入的节数必须为a~b的格式！");
				else if (!isMismatch(rep)) {
					JOptionPane.showMessageDialog(null, "输入的节数必须为数字！");
				} else {
					int rep1 = Integer.parseInt(rep[1]);
					int rep0 = Integer.parseInt(rep[0]);
					if (rep1 - rep0 != 1 || rep1 <= rep0)
						JOptionPane.showMessageDialog(null, "输入的节数不规范！");
					else if (!(rep0 >= 1 && rep1 <= 11))
						JOptionPane.showMessageDialog(null, "输入的节数必须在1~11之间！");
					else {
						REQ_SSN = rep[0] + "," + rep[1];
						try {
							result = new ExcelTools(REQ_WKD, REQ_SSN, REQ_WEEK, REQ_PLACE).searchCurri();
							if (result.isEmpty())
								jt.setText("当前输入的教室编号不存在，请检查输入的教室号。");
							else
								jt.setText(result);
						} catch (IOException e1) {
							e1.printStackTrace();
						}
					}
				}
			}
		} else if (e.getSource().equals(jb2)) {
			System.exit(0);
		}
	}

	public boolean isMismatch(String[] s) {
		for (int i = 0; i < s.length; i++) {
			if (jr1.isSelected() && !Pattern.compile("[0-9]*").matcher(s[i]).matches())
				return false;
			else if (jr2.isSelected()) {
				if (i != 2 && !Pattern.compile("[0-9]*").matcher(s[i]).matches()) {
					return false;
				}
			}
		}
		return true;
	}

	public void setJpCenter(String[] jrs, String[] hints) {	
		jpCenter.removeAll();	
		for (int i = 0; i < jrs.length; i++) {
			jpCenter.add(new MyCombinedTextField(jrs[i], 9));
			MyCombinedTextField.getTextField(i, jpCenter).setText("");
			new MyTextHintListener(MyCombinedTextField.getTextField(i, jpCenter), hints[i], Color.GRAY);
		}
		add(jpCenter, BorderLayout.CENTER);	
		jb1.setEnabled(true);
	}
}