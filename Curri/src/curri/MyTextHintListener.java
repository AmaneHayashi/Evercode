package curri;

import java.awt.Color;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;

import javax.swing.JTextField;

public class MyTextHintListener implements FocusListener {

	private JTextField jt;
	private String hintText;
	private Color hintColor;

	public MyTextHintListener(JTextField jt, String hintText, Color hintColor) {
		this.jt = jt;
		this.hintText = hintText;
		this.hintColor = hintColor;
		jt.addFocusListener(this);
		jt.requestFocus();
		jt.transferFocus();
	}

	@Override
	public void focusLost(FocusEvent e) {
		if (jt.getText().isEmpty()) {
			jt.setText(hintText);
			jt.setForeground(hintColor);
		}
	}

	@Override
	public void focusGained(FocusEvent e) {
		if (jt.getForeground() == hintColor) {
			jt.setText("");
			jt.setForeground(Color.black);
		}
	}
}
