package com.bash.adpter;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Bitmap.Config;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.basha.activity.R;
import com.basha.util.DensityUtil;
import com.basha.util.Util;

public class CalendarGridViewAdapter extends BaseAdapter {

	private Calendar calStartDate = Calendar.getInstance();// 当前显示的日历
	private Calendar calSelected = Calendar.getInstance(); // 当前选择的日
	private List<Calendar> noramlatten = new ArrayList<Calendar>(); // normal日期
	private List<Calendar> unnoramlatten = new ArrayList<Calendar>(); // unnormal日期
	private Map<String, String> attendantype = new HashMap<String, String>();

	public void setSelectedDate(Calendar cal) {
		calSelected = cal;
	}

    
	public void setNormalAttendance(List<Calendar> date) {
		noramlatten = date;
	}

	public void setUnNormalAttendance(List<Calendar> date) {
		unnoramlatten = date;
	}
   
	public void setAttendance(List map){
	}
	
	
	private Calendar calToday = Calendar.getInstance(); // 今日
	private int iMonthViewCurrentMonth = 0; // 当前视图月

	// 根据改变的日期更新日历
	// 填充日历控件用
	private void UpdateStartDateForMonth() {
		calStartDate.set(Calendar.DATE, 1); // 设置成当月第一天
		iMonthViewCurrentMonth = calStartDate.get(Calendar.MONTH);// 得到当前日历显示的月

		// 星期一是2 星期天是1 填充剩余天数
		int iDay = 0;
		int iFirstDayOfWeek = Calendar.MONDAY;
		int iStartDay = iFirstDayOfWeek;
		if (iStartDay == Calendar.MONDAY) {
			iDay = calStartDate.get(Calendar.DAY_OF_WEEK) - Calendar.MONDAY;
			if (iDay < 0)
				iDay = 6;
		}
		if (iStartDay == Calendar.SUNDAY) {
			iDay = calStartDate.get(Calendar.DAY_OF_WEEK) - Calendar.SUNDAY;
			if (iDay < 0)
				iDay = 6;
		}
		calStartDate.add(Calendar.DAY_OF_WEEK, -iDay);

		calStartDate.add(Calendar.DAY_OF_MONTH, -1);// 周日第一位

	}

	ArrayList<java.util.Date> titles;

	/**
	 * 获取页面显示数据
	 * @return
	 */
	private ArrayList<java.util.Date> getDates() {

		UpdateStartDateForMonth();

		ArrayList<java.util.Date> alArrayList = new ArrayList<java.util.Date>();
		// 遍历数组
		for (int i = 1; i <= 42; i++) {
			alArrayList.add(calStartDate.getTime());
			calStartDate.add(Calendar.DAY_OF_MONTH, 1);
		}

		return alArrayList;
	}

	private Activity activity;
	Resources resources;

	// construct
	public CalendarGridViewAdapter(Activity a, Calendar cal) {
		calStartDate = cal;
		activity = a;
		resources = activity.getResources();
		titles = getDates();
	}

	public CalendarGridViewAdapter(Activity a) {
		activity = a;
		resources = activity.getResources();
	}

	@Override
	public int getCount() {
		return titles.size();
	}

	@Override
	public Object getItem(int position) {
		return titles.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {

		RelativeLayout iv = new RelativeLayout(activity);
		ImageView imagview = new ImageView(activity); // 标识图标
		TextView textview = new TextView(activity);
		iv.setId(position + 5000);
		textview.setGravity(Gravity.CENTER);
		textview.setTextSize(16);

		int ivwidth = (int) activity.getResources().getDimension(
				R.dimen.allschepage_childe3layout_cell_h);// 标识图片宽高。
		android.widget.RelativeLayout.LayoutParams ivlp = new android.widget.RelativeLayout.LayoutParams(
				ivwidth, ivwidth);
		ivlp.addRule(RelativeLayout.CENTER_IN_PARENT);
		iv.addView(imagview, ivlp);
		iv.addView(textview, ivlp);

		Map map = new HashMap(); // 保存日期天\以及如果是考勤日期 保存类型
		map.put("type", "");

		// iv.setBackgroundColor(resources.getColor(R.color.white));

		Date myDate = (Date) getItem(position);
		Calendar calCalendar = Calendar.getInstance();
		calCalendar.setTime(myDate);

		final int iMonth = calCalendar.get(Calendar.MONTH);
		final int iDay = calCalendar.get(Calendar.DAY_OF_WEEK);

//		if (iDay == 7) { // 周六
//			// imagview.setBackgroundResource(R.drawable.calblue_rectangle);
//			imagview.setImageBitmap(drawCellImage(true, false, false, ivwidth));
//
//		} else if (iDay == 1) { // 周日
//			// imagview.setBackgroundResource(R.drawable.caldrak_rectangle);
//			imagview.setImageBitmap(drawCellImage(false, true, false, ivwidth));
//		} else {
//
//		}

		if (equalsDate(calToday.getTime(), myDate)) {
			// 当前日期
			imagview.setImageBitmap(drawCellImage(false, false, true, ivwidth));
		}

		// 判断是否是当前月
		if (iMonth == iMonthViewCurrentMonth) {

			textview.setTextColor(resources.getColor(R.color.caltxt1));

			// 遍历正常考勤
			if (noramlatten != null) {

				for (int i = 0; i < noramlatten.size(); i++) {
					Calendar normalattcal = noramlatten.get(i);
					if(equalsDate(normalattcal.getTime(), myDate) ){
						if(equalsDate(normalattcal.getTime(), calToday.getTime()) )
							imagview.setImageBitmap(drawCellImage(false, true, true, ivwidth));
						else if(normalattcal.getTime().getTime() > calToday.getTime().getTime())
							imagview.setImageBitmap(drawCellImage(false, true, false, ivwidth));
						else
							imagview.setImageBitmap(drawCellImage(true, false, false, ivwidth));


					}
					
				}
			}

//			// 遍历异常考勤
//			if (unnoramlatten != null) {
//				for (int i = 0; i < unnoramlatten.size(); i++) {
//					Calendar unnormalattcal = unnoramlatten.get(i);
//					if (equalsDate(unnormalattcal.getTime(), myDate)) {
//						imagview.setImageResource(R.drawable.ic_launcher);
//						imagview.setScaleType(ScaleType.CENTER);
//						map.put("type", attendantype.get(Util
//								.CleandtoyyyyMMdd(unnormalattcal)));
//
//					} else {
//						// imagview.setImageBitmap(null);
//					}
//				}
//			}

		} else {
			// iv.setBackgroundColor(Color.WHITE);
			textview.setTextColor(resources.getColor(R.color.caltxt2));
		}
		// 设置背景颜色
		if (equalsDate(calSelected.getTime(), myDate) &&!equalsDate(calToday.getTime(), myDate)) {
			// 选择的
			imagview.setBackgroundColor(resources.getColor(R.color.selection));
			// iv.setBackgroundColor(resources.getColor(R.color.selection));
		}

		int day = myDate.getDate(); // 日期
		textview.setText(String.valueOf(day));
		textview.setId(position + 500);
		map.put("date", myDate);
		iv.setTag(map);

		// iv.addView(txtToDay, lp1);
		// 日期结束
		// iv.setOnClickListener(view_listener);

		return iv;
	}

	interface mycallback {
		void process(String mstr);
	}

	@Override
	public void notifyDataSetChanged() {
		super.notifyDataSetChanged();
	}

	private Boolean equalsDate(Date date1, Date date2) {

		if (date1.getYear() == date2.getYear()
				&& date1.getMonth() == date2.getMonth()
				&& date1.getDate() == date2.getDate()) {
			return true;
		} else {
			return false;
		}

	}

	private Bitmap drawCellImage(boolean greyline, boolean bluelien,
			boolean redcrcly, int width) {
		Bitmap output = Bitmap.createBitmap(width, width, Config.ARGB_8888);
		Canvas canvas = new Canvas(output);
		final Paint paint = new Paint();
		paint.setStrokeWidth(3);
		paint.setAntiAlias(true);
		paint.setStyle(Paint.Style.FILL);
		paint.setColor(Color.TRANSPARENT);
		canvas.drawCircle(width / 2, width / 2, width / 2, paint);

		if (redcrcly) {
			paint.setColor(Color.RED);
			canvas.drawCircle(width / 2, width / 2, width / 2, paint);
		}
		if (greyline) {
			paint.setColor(Color.GRAY);
			canvas.drawRect(0, width * 4 / 5, width, width, paint);
		}

		if (bluelien) {
			paint.setColor(Color.BLUE);
			canvas.drawRect(0, width * 4 / 5, width, width, paint);

		}
		return output;

	}

}
