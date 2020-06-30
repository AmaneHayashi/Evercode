package curri;

public class SortTools {
	
	private int a[];
	
	public SortTools(int a[]) {
		this.a = a;
	}
	
	public int[] sort() {
		int q = 0, r = a.length, t = 0;
		int b[] = new int[r], temp[] = new int[r];
		for (int m = 0; m < r; m++)
			for (int n = 0; n < r && n != m; n++)
				b[(a[m] >= a[n]) ? m : n]++;
		for (int p = 0; (b[p] == q ? q++ : q == r ? r + 1 : q) <= r; p += (p < r - 1) ? 1 : -p) {
			if(b[p] == q - 1) {
				temp[t++] = a[p];
			}
		}
		return temp;
	}
}