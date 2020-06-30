package curri;

import java.awt.Component;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class MyCombinedTextField extends JPanel {
	
	private static final long serialVersionUID = -7211391056754459731L;
	private String str;
	private JLabel jl;
	private JTextField jt;

	public MyCombinedTextField(String myStr, int i) {
		this.str = myStr;
		jl = new JLabel(str);
		jt = new JTextField(i);
		add(jl);
		add(jt);
	}
	
	public JLabel getLabel() {
		return jl;
	}
	
	public JTextField getTextField() {
		return jt;
	}
	
	public static JLabel getLabel(int label, JPanel jl) {
		JPanel jp1 = (JPanel) jl.getComponent(label);
		for (Component comp : jp1.getComponents()) {
			if ((comp instanceof JLabel)) {
				return (JLabel) comp;
			}
		}
		return null;
	}

	public static JTextField getTextField(int label, JPanel jl) {
		JPanel jp1 = (JPanel) jl.getComponent(label);
		for (Component comp : jp1.getComponents()) {
			if (!(comp instanceof JLabel)) {
				return (JTextField) comp;
			}
		}
		return null;
	}
}