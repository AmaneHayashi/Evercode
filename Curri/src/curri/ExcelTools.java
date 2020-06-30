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

	private int REQ_WKD;// �涨��������
	private String REQ_SSN;// �涨�Ľڴ�
	private String REQ_WEEK;// �涨������
	private int REQ_PLACE;//ѡ���Ľ���
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
		// ����ָ�����ļ�����������Excel�Ӷ�����Workbook����
		HSSFWorkbook wb0 = new HSSFWorkbook(is);
		// ��ȡExcel�ĵ��еĵ�һ����
		HSSFSheet sht0 = wb0.getSheetAt(0);
		// ��Sheet�е�ÿһ�н��е���
		for (Row r : sht0) {
			// �����ǰ�е��кţ���0��ʼ��δ�ﵽ2�������У������ѭ��
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
		String value = "��" + REQ_WEEK + "�ܣ�����" + toChinese(REQ_WKD) + "����" + REQ_SSN +"�ڣ�����¥" + REQ_PLACE + "���ҵ�ʹ�������\n";
		if (temp.isEmpty()) 
			value += "δ��ռ�á�";
		else 
			value += "��ǰ�γ̣�" + temp.get(0).getName() + "\nѡ��������" + temp.get(0).getNum();			
		return value;
	}

	public static String[] str2array(String str, String spliter) {
		return str.split(spliter);
	}
	
	private static String toChinese(int i) {
	    return new StringBuffer().append(sk[i - 1]).toString();
	}
}