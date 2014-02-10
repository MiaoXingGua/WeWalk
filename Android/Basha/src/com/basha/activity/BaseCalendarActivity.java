package com.basha.activity;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.GestureDetector;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.ContextMenu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewFlipper;

import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.FunctionCallback;
import com.bash.adpter.CalendarGridViewAdapter;
import com.bash.adpter.CallistviewAdpter;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALUserEngine;
import com.basha.util.NumberHelper;
import com.basha.view.CalendarGridView;

public class BaseCalendarActivity extends BaseAcitvity implements
		OnTouchListener, OnClickListener {

	// 用于判断手势
	private static final int SWIPE_MIN_DISTANCE = 120;
	private static final int SWIPE_MAX_OFF_PATH = 250;
	private static final int SWIPE_THRESHOLD_VELOCITY = 200;

	private static final int calLayoutID = 55; // 日历布局ID

	// 动画
	private Animation slideLeftIn;
	private Animation slideLeftOut;
	private Animation slideRightIn;
	private Animation slideRightOut;
	GestureDetector mGesture = null;

	@Override
	// 获取手势action;
	public boolean onTouch(View v, MotionEvent event) {
		mGesture.onTouchEvent(event);

		return super.onTouchEvent(event);

	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		this.mGesture.onTouchEvent(event);
		return false;

	}

	AnimationListener animationListener = new AnimationListener() {
		@Override
		public void onAnimationStart(Animation animation) {
		}

		@Override
		public void onAnimationRepeat(Animation animation) {
		}

		@Override
		public void onAnimationEnd(Animation animation) {
			// 当动画完成后调用
			CreateGirdView();
			Log.i("MyTag", "--------onAnimationEnd--------");
		}
	};

	// SimpleOnGestureListener 是Android SDK提供的一个listener类来侦测各种不同的手势;
	class GestureListener extends SimpleOnGestureListener {
		@Override
		// 在onFling方法中, 判断是不是一个合理的swipe动作;
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
				float velocityY) {
			try {
				if (e1.getX() - e2.getX() > SWIPE_MIN_DISTANCE
						&& Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
					mViewFlipper.setInAnimation(slideLeftIn);
					mViewFlipper.setOutAnimation(slideLeftOut);
					mViewFlipper.showNext();
					setNextViewItem();
					return true;

				} else if (e2.getX() - e1.getX() > SWIPE_MIN_DISTANCE
						&& Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
					// 这里的viewFlipper是含有多个view的一个container, 可以很方便的调用prev/next
					// //view;

					mViewFlipper.setInAnimation(slideRightIn);
					mViewFlipper.setOutAnimation(slideRightOut);
					mViewFlipper.showPrevious();
					setPrevViewItem();

					return true;

				}
			} catch (Exception e) {
				// nothing
			}
			return false;
		}

		private SharedPreferences shp = getSharedPreferences("count",
				Context.MODE_PRIVATE);

		@Override
		public boolean onSingleTapUp(MotionEvent e) {
			Log.i("MyTag", "----onSingleTapUp---");
			// ListView lv = getListView();
			// 得到当前选中的是第几个单元格
			int pos = gView2.pointToPosition((int) e.getX(), (int) e.getY());
			RelativeLayout txtDay = (RelativeLayout) gView2
					.findViewById(pos + 5000);
			if (txtDay != null) {
				if (txtDay.getTag() != null) {
					Map map = (Map) txtDay.getTag();
					Date date = (Date) map.get("date");
					String typeid = (String) map.get("type");
					calSelected.setTime(date);
					// 更新底部选中天
					gAdapter.setSelectedDate(calSelected);
					gAdapter.notifyDataSetChanged();

					gAdapter1.setSelectedDate(calSelected);
					gAdapter1.notifyDataSetChanged();

					gAdapter3.setSelectedDate(calSelected);
					gAdapter3.notifyDataSetChanged();

					oneDayScheduleList(date);

				}
			}

			Log.i("TEST", "onSingleTapUp -  pos=" + pos);

			return false;
		}
	}

	// 基本变量
	private Context mContext = BaseCalendarActivity.this;
	private GridView gView1;// 上一个月
	private GridView gView2;// 当前月
	private GridView gView3;// 下一个月

	boolean bIsSelection = false;// 是否是选择事件发生
	private Calendar calStartDate = Calendar.getInstance();// 当前显示的日历
	private Calendar calSelected = Calendar.getInstance(); // 选择的日历
	private Calendar calToday = Calendar.getInstance(); // 今日
	private CalendarGridViewAdapter gAdapter;
	private CalendarGridViewAdapter gAdapter1;
	private CalendarGridViewAdapter gAdapter3;

	private int iMonthViewCurrentMonth = 0; // 当前视图月
	private int iMonthViewCurrentYear = 0; // 当前视图年
	private int iFirstDayOfWeek = Calendar.MONDAY;

	/** 底部菜单文字 **/
	String[] menu_toolbar_name_array;
	private ViewFlipper mViewFlipper;
	private ImageButton imbt_up;
	private ImageButton imbt_next;
	private TextView tv_daily; // 顶部日期显示
	private ListView cal_listview;
	private ImageButton leftbtn;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.calendar);
		mViewFlipper = (ViewFlipper) findViewById(R.id.vf_clendtxt);
		imbt_up = (ImageButton) findViewById(R.id.imbt_upmoth); // 上一月按钮
		imbt_next = (ImageButton) findViewById(R.id.imbt_nextmoth);// 下一月按钮
		tv_daily = (TextView) findViewById(R.id.tv_cq_dairly);// 当日日期
		cal_listview = (ListView) findViewById(R.id.callv);
		initactionbar();
		calStartDate = getCalendarStartDate();
		CreateGirdView();
		UpdateStartDateForMonth();
		setListen();
		// 添加Animation实现不同动画效果
		slideLeftIn = AnimationUtils.loadAnimation(this, R.anim.slide_left_in);
		slideLeftOut = AnimationUtils
				.loadAnimation(this, R.anim.slide_left_out);
		slideRightIn = AnimationUtils
				.loadAnimation(this, R.anim.slide_right_in);
		slideRightOut = AnimationUtils.loadAnimation(this,
				R.anim.slide_right_out);

		slideLeftIn.setAnimationListener(animationListener);
		slideLeftOut.setAnimationListener(animationListener);
		slideRightIn.setAnimationListener(animationListener);
		slideRightOut.setAnimationListener(animationListener);

		mGesture = new GestureDetector(this, new GestureListener());
		initCalListView();
		getMyScheduleList();
		registerForContextMenu(cal_listview);
	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		TextView title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("日程");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setOnClickListener(this);
		leftbtn.setImageResource(R.drawable.actionbar_back_pic);
		leftbtn.setPadding(0, 0, 30, 0);

	}

	private void setListen() {
		imbt_up.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// setPrevViewItem();
				// CreateGirdView();
				// UpdateStartDateForMonth();

				mViewFlipper.setInAnimation(slideRightIn);
				mViewFlipper.setOutAnimation(slideRightOut);
				mViewFlipper.showPrevious();
				setPrevViewItem();
			}
		});
		imbt_next.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// setNextViewItem();
				// CreateGirdView();
				// UpdateStartDateForMonth();

				mViewFlipper.setInAnimation(slideLeftIn);
				mViewFlipper.setOutAnimation(slideLeftOut);
				mViewFlipper.showNext();
				setNextViewItem();
			}
		});
		tv_daily.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				setToDayViewItem();
				CreateGirdView();
				UpdateStartDateForMonth();
			}
		});
	}

	private void CreateGirdView() {
		Calendar tempSelected1 = Calendar.getInstance(); // 临时
		Calendar tempSelected2 = Calendar.getInstance(); // 临时
		Calendar tempSelected3 = Calendar.getInstance(); // 临时
		tempSelected1.setTime(calStartDate.getTime());
		tempSelected2.setTime(calStartDate.getTime());
		tempSelected3.setTime(calStartDate.getTime());

		gView1 = new CalendarGridView(mContext);
		tempSelected1.add(Calendar.MONTH, -1);
		gAdapter1 = new CalendarGridViewAdapter(this, tempSelected1);
		gView1.setAdapter(gAdapter1);// 设置菜单Adapter
		gView1.setId(calLayoutID);

		gView2 = new CalendarGridView(mContext);
		gAdapter = new CalendarGridViewAdapter(this, tempSelected2);
		gView2.setAdapter(gAdapter);// 设置菜单Adapter
		gView2.setId(calLayoutID);

		gView3 = new CalendarGridView(mContext);
		tempSelected3.add(Calendar.MONTH, 1);
		gAdapter3 = new CalendarGridViewAdapter(this, tempSelected3);
		gView3.setAdapter(gAdapter3);// 设置菜单Adapter
		gView3.setId(calLayoutID);

		gView2.setOnTouchListener(this);
		gView1.setOnTouchListener(this);
		gView3.setOnTouchListener(this);

		if (mViewFlipper.getChildCount() != 0) {
			mViewFlipper.removeAllViews();
		}

		mViewFlipper.addView(gView2);
		mViewFlipper.addView(gView3);
		mViewFlipper.addView(gView1);

		String s = calStartDate.get(Calendar.YEAR)
				+ "-"
				+ NumberHelper.LeftPad_Tow_Zero(calStartDate
						.get(Calendar.MONTH) + 1);

		tv_daily.setText(s);
		setSchedule2Adpter();

	}

	// 上一个月
	private void setPrevViewItem() {
		iMonthViewCurrentMonth--;// 当前选择月--
		// 如果当前月为负数的话显示上一年
		if (iMonthViewCurrentMonth == -1) {
			iMonthViewCurrentMonth = 11;
			iMonthViewCurrentYear--;
		}
		calStartDate.set(Calendar.DAY_OF_MONTH, 1); // 设置日为当月1日
		calStartDate.set(Calendar.MONTH, iMonthViewCurrentMonth); // 设置月
		calStartDate.set(Calendar.YEAR, iMonthViewCurrentYear); // 设置年

	}

	// 当月
	private void setToDayViewItem() {

		calSelected.setTimeInMillis(calToday.getTimeInMillis());
		calSelected.setFirstDayOfWeek(iFirstDayOfWeek);
		calStartDate.setTimeInMillis(calToday.getTimeInMillis());
		calStartDate.setFirstDayOfWeek(iFirstDayOfWeek);

	}

	// 下一个月
	private void setNextViewItem() {
		iMonthViewCurrentMonth++;
		if (iMonthViewCurrentMonth == 12) {
			iMonthViewCurrentMonth = 0;
			iMonthViewCurrentYear++;
		}
		calStartDate.set(Calendar.DAY_OF_MONTH, 1);
		calStartDate.set(Calendar.MONTH, iMonthViewCurrentMonth);
		calStartDate.set(Calendar.YEAR, iMonthViewCurrentYear);

	}

	// 根据改变的日期更新日历
	// 填充日历控件用
	private void UpdateStartDateForMonth() {
		Log.i("MyTag", "--------UpdateStartDateForMonth------");
		// 设置成当月第一天
		calStartDate.set(Calendar.DATE, 1);
		// 得到当前日历显示的月
		iMonthViewCurrentMonth = calStartDate.get(Calendar.MONTH);
		// 得到当前日历显示的年
		iMonthViewCurrentYear = calStartDate.get(Calendar.YEAR);

		String s = calStartDate.get(Calendar.YEAR)
				+ "-"
				+ NumberHelper.LeftPad_Tow_Zero(calStartDate
						.get(Calendar.MONTH) + 1);
		tv_daily.setText(s);

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

	}

	private Calendar getCalendarStartDate() {
		calToday.setTimeInMillis(System.currentTimeMillis());
		calToday.setFirstDayOfWeek(iFirstDayOfWeek);

		if (calSelected.getTimeInMillis() == 0) {
			calStartDate.setTimeInMillis(System.currentTimeMillis());
			calStartDate.setFirstDayOfWeek(iFirstDayOfWeek);
		} else {
			calStartDate.setTimeInMillis(calSelected.getTimeInMillis());
			calStartDate.setFirstDayOfWeek(iFirstDayOfWeek);
		}

		return calStartDate;
	}

	private Handler mhandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 1:
				Toast.makeText(BaseCalendarActivity.this, "请求服务器失败,无法获取当月考勤！",
						Toast.LENGTH_SHORT).show();
				break;
			case 2:
				Map map = (Map) msg.obj;
				if (map == null)
					break;
				String code = (String) map.get("code");
				String content = (String) map.get("content");

				if ("1".equals(code)) {
					try {
						JSONObject json = new JSONObject(content);
						JSONArray jsonarr = json.getJSONArray("attendance");
						ArrayList<Map> list = new ArrayList<Map>();
						for (int i = 0; i < jsonarr.length(); i++) {
							Map<String, String> itemmap = new HashMap<String, String>();
							itemmap.put("time", jsonarr.getJSONObject(i)
									.getString("attendaceday"));
							itemmap.put("typeid", jsonarr.getJSONObject(i)
									.getString("typeid"));
							list.add(itemmap);
						}
						if (list.size() > 0) {
							gAdapter.setAttendance(list);
							gAdapter.notifyDataSetChanged();
						}

					} catch (Exception e) {
						e.printStackTrace();
					}

				} else {
					Toast.makeText(BaseCalendarActivity.this, "获取当月考勤失败！",
							Toast.LENGTH_SHORT).show();
				}
				break;
			case 3:

				break;

			default:
				break;
			}
		};
	};
	private ProgressDialog progressDialog;
	private CallistviewAdpter callistadpter;

	private void initCalListView() {
		callistadpter = new CallistviewAdpter(this);
		cal_listview.setAdapter(callistadpter);

		cal_listview.setOnItemLongClickListener(new OnItemLongClickListener() {

			@Override
			public boolean onItemLongClick(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				cal_listview.setTag(callistadpter.getItem(arg2));
				return false;
			}
		});
		cal_listview.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				
				((mapplication) getApplication()).setSchAvobject(callistadpter
						.getItem(arg2));

				Intent editScheduleIntent = new Intent(BaseCalendarActivity.this, MainPage.class);
				editScheduleIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				editScheduleIntent.putExtra("action", "showScheul");
				startActivity(editScheduleIntent);
				BaseCalendarActivity.this.finish();

			}
		});
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.left_imbt:
			this.finish();
			break;

		default:
			break;
		}
	}

	private List<AVObject> myScheduleList = null; // 全部日程
	private List<Calendar> datelist = null; // 全部日程时间

	/**
	 * 获取全部日程
	 */

	private void getMyScheduleList() {
		createWiatDialog("正在加载...");
		ALUserEngine.defauleEngine().getMyScheduleList(new CallBack() {

			@Override
			public void done(Object object, AVException avexception) {
				cancleWaitDialog();
				if (avexception == null) {
					if (object == null) {
						Log.e("MyTag", "--获取全部日程失败--");
						return;
					}
					Log.i("MyTag", "--获取全部日程成功--" + object);
					if (object instanceof List) {
						myScheduleList = (List<AVObject>) object;
						iteratesScheduleList();
					}

				} else {
					Log.e("MyTag", "--获取全部日程失败--");
					avexception.printStackTrace();
				}
			}
		});
	}

	private void setSchedule2Adpter() {
		if (datelist == null)
			return;
		gAdapter1.setNormalAttendance(datelist);
		gAdapter3.setNormalAttendance(datelist);
		gAdapter.setNormalAttendance(datelist);
		gAdapter.notifyDataSetChanged();
		gAdapter1.notifyDataSetChanged();
		gAdapter3.notifyDataSetChanged();
	}

	private void iteratesScheduleList() {
		if (myScheduleList == null)
			return;
		datelist = new ArrayList<Calendar>();
		for (int i = 0; i < myScheduleList.size(); i++) {
			AVObject avobject = myScheduleList.get(i);
			Date date = avobject.getDate("date");
			// Date date = avobject.getDate("date");
			// Date date = avobject.getCreatedAt();
			Log.i("MyTag", avobject.getString("place") + "-------获取date----"
					+ date);
			Calendar calCalendar = Calendar.getInstance();
			calCalendar.setTime(date);
			datelist.add(calCalendar);
		}
		setSchedule2Adpter();
		oneDayScheduleList(new Date());
	}

	private void oneDayScheduleList(Date mdate) {
		if (myScheduleList == null)
			return;
		List<AVObject> listdate = new ArrayList<AVObject>();
		for (int i = 0; i < myScheduleList.size(); i++) {
			AVObject avobject = myScheduleList.get(i);
			Date date = avobject.getDate("date");
			if (equalsDate(mdate, date)) {
				listdate.add(avobject);
			}
		}
		callistadpter.setData(listdate);
		callistadpter.notifyDataSetChanged();
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

	@Override
	public void onCreateContextMenu(ContextMenu menu, View v,
			ContextMenuInfo menuInfo) {
		menu.add(0, 1, 0, "编辑");
		menu.add(0, 2, 0, "删除");
	}

	@Override
	public boolean onContextItemSelected(MenuItem item) {
		final AVObject avobject = (AVObject) cal_listview.getTag();
		if (avobject == null)
			return super.onContextItemSelected(item);
		switch (item.getItemId()) {
		case 1:
			 ((mapplication)getApplication()).setSchAvobject(avobject);
			
			 Intent editScheduleIntent = new Intent(this,
			 AddScheduleActivity.class);
			 editScheduleIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			 editScheduleIntent.putExtra("action", "editschle");
			 startActivity(editScheduleIntent);

			break;
		case 2:
			ALUserEngine.defauleEngine().deleteSchedule(avobject,
					new CallBack() {

						@Override
						public void done(Object object, AVException avexception) {
							if (avexception == null) {
								Toast.makeText(getApplicationContext(), "删除成功",
										Toast.LENGTH_SHORT).show();
								myScheduleList.remove(avobject);
								callistadpter.removeItem(avobject);
								callistadpter.notifyDataSetChanged();
							} else {
								Toast.makeText(getApplicationContext(), "删除失败",
										Toast.LENGTH_SHORT).show();
								avexception.printStackTrace();
							}
						}
					});
		default:
			break;
		}
		return super.onContextItemSelected(item);
	}
}
