package curri;

public interface Parameters {
	double value = 0.15;
	String[] jrs1 = new String[] { "周    数：", "星    期：", "起始节：", "终止节：" };
	String[] jrs2 = new String[] { "周    数：", "星    期：", "节    数：", "教室号：" };
	String[] hint1 = new String[] {"输入示例：5", "输入示例：3", "输入示例：5", "输入示例：6"};
	String[] hint2 = new String[] {"输入示例：5", "输入示例：3", "输入示例：5~6", "输入示例：335"};
	String tip = "%s查询（仅含教三楼）\n请依次输入：\n周数（示例：5，则为第5周）\n  [注：教学周为1~16周]\n\n星期（示例：3，则为星期三\n  [注：有效星期数为1~7]\n\n%s";
	String tip1 = String.format(tip, "空教室", "起始节与终止节（示例：起始节5,终止节6，则为第5~6节）\n  [注：有效节次为1~11节]");
	String tip2 = String.format(tip, "教室课程",
			"节数（示例：5~6，则为第5~6节）\n  [注：有效节次为1~11节，填入节次必须为一次课的时间（2节）]" + "\n\n教室号（示例：335，则为教三335教室）\n  [注：输入的教室号必须真实存在]");
	String[] sk = {"一", "二", "三", "四", "五", "六", "日"};
}