package curri;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.IntStream;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;

public class ExcelTools implements Parameters{

	private int REQ_WKD;// 规定的星期数
	private String REQ_SSN;// 规定的节次
	private String REQ_WEEK;// 规定的周数
	private int REQ_PLACE;//选定的教室
	private List<Curri> curri;
	
	public ExcelTools(int REQ_WKD, String REQ_SSN, int REQ_WEEK, int REQ_PLACE) throws IOException {
		this.REQ_WKD = REQ_WKD;
		this.REQ_SSN = REQ_SSN;
		this.REQ_WEEK = String.valueOf(REQ_WEEK);
		this.REQ_PLACE = REQ_PLACE;
		this.curri = loadCurri();
	}

	public List<Curri> loadCurri() throws IOException {
		List<Curri> temp = new ArrayList<Curri>();
	//	InputStream is = this.getClass().getResourceAsStream("/resources/curri.xls");
		FileInputStream is = new FileInputStream(new File("E:\\curri.xls"));
		// 根据指定的文件输入流导入Excel从而产生Workbook对象
		HSSFWorkbook wb0 = new HSSFWorkbook(is);
		// 获取Excel文档中的第一个表单
		HSSFSheet sht0 = wb0.getSheetAt(0);
		// 对Sheet中的每一行进行迭代
		for (Row r : sht0) {
			// 如果当前行的行号（从0开始）未达到2（第三行）则从新循环
			if (r.getRowNum() < 1) {
				continue;
			}
			Curri curri = new Curri();
			curri.setName(r.getCell(0).getStringCellValue());
			curri.setWkd((int) r.getCell(1).getNumericCellValue());
			curri.setSsn(r.getCell(2).getStringCellValue());
			curri.setWeek(r.getCell(3).getStringCellValue());
			curri.setPlace((int) r.getCell(4).getNumericCellValue());
			curri.setNum((int) r.getCell(5).getNumericCellValue());
			temp.add(curri);
		}
		is.close();
		wb0.close();
		return temp;
	}

	public int[] getPlaces(List<Curri> list) throws IOException {
		String[] temp = new String[list.size()];
		int j = 0;
		for (int i = 0; i < list.size(); i++) {
			int pl = list.get(i).getPlace();
			if (!Arrays.asList(temp).contains(String.valueOf(pl)))
				temp[j++] = String.valueOf(pl);
		}
		int[] temp0 = new int[j];
		for (int k = 0; k < j; k++) {
			temp0[k] = Integer.parseInt(temp[k]);
		}
		return new SortTools(temp0).sort();
	}

	public int[] filterCurri() throws IOException {
		int[] sum = getPlaces(curri);
		List<Curri> temp = new ArrayList<Curri>();
		for (int i = 0; i < curri.size(); i++) {
			Curri cur = curri.get(i);
			if (cur.getWkd() == REQ_WKD && (cur.getSsn().contains(REQ_SSN) || REQ_SSN.contains(cur.getSsn()))
					&& Arrays.asList(str2array(cur.getWeek(), ",")).contains(REQ_WEEK)) {
				temp.add(cur);
			}
		}
		if (temp.isEmpty()) {
			return sum;
		} else {
			int[] now = getPlaces(temp);
			for (int i = 0; i < now.length; i++) {
				for (int j = 0; j < sum.length && now[i] != 0; j++) {
					if (sum[j] == now[i])
						sum[j] = 0;
				}
			}
			return sum;
		}
	}

	public String searchCurri() throws IOException{
		int[] sum = getPlaces(curri);
		if(IntStream.of(sum).noneMatch(x -> x == REQ_PLACE))
			return "";
		List<Curri> temp = new ArrayList<Curri>();
		for (int i = 0; i < curri.size(); i++) {
			Curri cur = curri.get(i);
			if (cur.getWkd() == REQ_WKD && (cur.getSsn().contains(REQ_SSN))
					&& Arrays.asList(str2array(cur.getWeek(), ",")).contains(REQ_WEEK) 
					&& cur.getPlace() == REQ_PLACE ) {
				temp.add(cur);
			}
		}
		String value = "第" + REQ_WEEK + "周，星期" + toChinese(REQ_WKD) + "，第" + REQ_SSN +"节，教三楼" + REQ_PLACE + "教室的使用情况：\n";
		if (temp.isEmpty()) 
			value += "未被占用。";
		else 
			value += "当前课程：" + temp.get(0).getName() + "\n选课人数：" + temp.get(0).getNum();			
		return value;
	}

	public static String[] str2array(String str, String spliter) {
		return str.split(spliter);
	}
	
	private static String toChinese(int i) {
	    return new StringBuffer().append(sk[i - 1]).toString();
	}
}