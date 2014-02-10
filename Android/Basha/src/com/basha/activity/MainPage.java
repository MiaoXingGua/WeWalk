package com.basha.activity;

import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.View.OnClickListener;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.widget.LinearLayout.LayoutParams;
import android.widget.TextView;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxStatus;
import com.androidquery.callback.BitmapAjaxCallback;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.basha.Service.LocationService;
import com.basha.activity.BaseCalendarActivity.GestureListener;
import com.basha.application.mapplication;
import com.basha.bean.Weather;
import com.basha.fragment.LeftMenuFragment_Setting;
import com.basha.fragment.LeftMenuFragment_register;
import com.basha.minterface.FragmentCallBack;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALPhotoEngine;
import com.basha.serveRequest.ALUserEngine;
import com.basha.serveRequest.ALWeatherEngine;
import com.basha.test.MyHandler;
import com.basha.util.BitmapUtils;
import com.basha.util.DensityUtil;
import com.basha.util.Util;
import com.huewu.pla.sample.PullToRefreshSampleFragment;
import com.jeremyfeinstein.slidingmenu.lib.SlidingMenu;
import com.jeremyfeinstein.slidingmenu.lib.SlidingMenu.OnOpenListener;

public class MainPage extends FragmentActivity implements OnClickListener,
		FragmentCallBack {
	private SlidingMenu slidingMenu;
	private ViewPager mainviewpage; // 主界面滑动viewpage
	private Button bt1;
	private Button bt2;
	private Button bt3;
	private Button bt4;
	private Button bt5;
	private BitmapDrawable bluecircle_bj = null; // 蓝色圆圈背景图
	private BitmapDrawable redcircle_bj = null;// 红色圆圈背景图
	private LinearLayout mainpage_itembottom1;
	private LinearLayout node_layout;
	private Bitmap blackcry;
	private Bitmap bluecry;
	private TextView cityname_textView;
	private ImageButton leftbtn;
	private TextView pm_textview;
	private GestureDetector mGesture;
	private TextView textview_brand;
	private AQuery aq;
	private ImageView model_imageview;
	private TextView textview_recommend;
	private TextView textview_streetshot;
	private TextView textview_demonstrate;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mainpage);
		setView();
		initSlidingMenu();
//		init();
	}
 
	private void init(){
		Intent serviceintent = new Intent(this,LocationService.class);
		startService(serviceintent);
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		Log.i("MyTag", "----MainPage----onResume-------");
		updateInterface();
		  AVUser avuser = AVUser.getCurrentUser();
		  if(avuser == null){
			  getSupportFragmentManager().beginTransaction()
				.replace(R.id.leftmenu, new LeftMenuFragment_register())
				.commit(); 
		  }/*else{
			  getSupportFragmentManager().beginTransaction()
				.replace(R.id.leftmenu, new j.s())
				.commit(); 
		  }*/
		
	}

	/**
	 * 如果从页面跳转，定向到该日期显示
	 */
	private void showSched() {
		String action = getIntent().getStringExtra("action");
		// 不是页面跳转
		if (!"showScheul".equals(action))
			return;

		// 跳转到指定日期查看日程
		Date nowdate = application.getNowdate();
		AVObject avobject = application.getSchAvobject();
		Date date = avobject.getDate("date");
		Calendar nowcal = Calendar.getInstance();
		Calendar cal = Calendar.getInstance();
		nowcal.setTime(nowdate);
		cal.setTime(date);

		// 遍历5天对比
		for (int i = 0; i < 5; i++) {
			if (compCalWithDay(cal, nowcal)) {
				if (i == 0) {
					onClick(bt1);
				} else if (i == 1) {
					onClick(bt2);
				} else if (i == 2) {
					onClick(bt3);

				} else if (i == 3) {
					onClick(bt4);

				} else if (i == 4) {
					onClick(bt5);

				}
			}
			nowcal.add(Calendar.DAY_OF_MONTH, 1);

		}

	}

	private void setView() {
		application = (mapplication) getApplication();
		aq = new AQuery(this);
		mGesture = new GestureDetector(this, new GestureListener());

		bt1 = (Button) findViewById(R.id.bt1); // 第一个日期
		bt2 = (Button) findViewById(R.id.bt2); // 第二个日期
		bt3 = (Button) findViewById(R.id.bt3); // 第三个日期
		bt4 = (Button) findViewById(R.id.bt4);// 第四个日期
		bt5 = (Button) findViewById(R.id.bt5);// 第五个日期

		bt1.setOnClickListener(this);
		bt2.setOnClickListener(this);
		bt3.setOnClickListener(this);
		bt4.setOnClickListener(this);
		bt5.setOnClickListener(this);

		leftbtn = (ImageButton) findViewById(R.id.left_imbt); // actionbar左边按钮
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt); // actionbar右边按钮
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt); // actionbar按钮1
		leftbtn.setOnClickListener(this);
		Rightbtn.setOnClickListener(this);
		onebtn.setOnClickListener(this);

		cityname_textView = (TextView) findViewById(R.id.cityname_textView); // 主页面城市名
		pm_textview = (TextView) findViewById(R.id.pm_textview); // 主页面pm污染view
		textview_brand = (TextView)findViewById(R.id.textview_brand); //品牌名称
		model_imageview = (ImageView)findViewById(R.id.model_imageview); //模特图片
		textview_recommend = (TextView)findViewById(R.id.textview_recommend); //穿衣建议
		textview_streetshot = (TextView)findViewById(R.id.textview_streetshot); //街拍
		textview_demonstrate = (TextView)findViewById(R.id.textview_demonstrate); //示范
		mainviewpage = (ViewPager) findViewById(R.id.mainviewpage);
		mainviewpage.setOnPageChangeListener(new OnPageChangeListener() {
			@Override
			public void onPageSelected(int arg0) {
				changenodeimage(arg0);
			}

			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {

			}

			@Override
			public void onPageScrollStateChanged(int arg0) {

			}
		});

		// 监听界面初始化，测量按钮生成背景图片
		ViewTreeObserver vto2 = bt1.getViewTreeObserver();
		vto2.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
			@Override
			public void onGlobalLayout() {
				bt1.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				bluecircle_bj = new BitmapDrawable(BitmapUtils
						.getCircleNumBitmap(
								MainPage.this,
								Util.getScreenWidht(MainPage.this) / 5,
								(int) getResources().getDimension(
										R.dimen.mainpage_caldate_child2_h),
								"#B7FFDC", false));
				redcircle_bj = new BitmapDrawable(BitmapUtils
						.getCircleNumBitmap(
								MainPage.this,
								Util.getScreenWidht(MainPage.this) / 5,
								(int) getResources().getDimension(
										R.dimen.mainpage_caldate_child2_h),
								"#d71345", false));

				bt1.setBackgroundDrawable(bluecircle_bj);
				bt2.setBackgroundDrawable(bluecircle_bj);
				bt3.setBackgroundDrawable(bluecircle_bj);
				bt4.setBackgroundDrawable(bluecircle_bj);
				bt5.setBackgroundDrawable(bluecircle_bj);

			}
		});

		mainpage_itembottom1 = (LinearLayout) findViewById(R.id.includebottom1); // 主界面
																					// item1
		node_layout = (LinearLayout) findViewById(R.id.node_layout); // 主界面viewpage下小圆点
		int width = DensityUtil.dip2px(getApplicationContext(), 15);
		blackcry = BitmapUtils.getCircleNumBitmap(this, width, width,
				"#313131", true); // 黑色圆点
		bluecry = BitmapUtils.getCircleNumBitmap(this, width, width, "#426ab3",
				true); // 蓝色圆点

		ImageButton allsch_imbtn = (ImageButton) findViewById(R.id.allsch_imbtn); // 全部日程
		ImageButton addsch_imbtn = (ImageButton) findViewById(R.id.addsch_imbtn); // 添加日程
		allsch_imbtn.setOnClickListener(this);
		addsch_imbtn.setOnClickListener(this);
		textview_streetshot.setOnClickListener(this);
		textview_demonstrate.setOnClickListener(this);
		

	}

	// 根据viewpage滑动更新示意小圆点
	private void changenodeimage(int index) {
		for (int i = 0; i < node_layout.getChildCount(); i++) {
			ImageView iv = (ImageView) node_layout.getChildAt(i);
			iv.setImageBitmap(blackcry);
			if (i == index)
				iv.setImageBitmap(bluecry);
		}
	}

	private void initSlidingMenu() {
		// 设置抽屉菜单
		slidingMenu = new SlidingMenu(this);
		slidingMenu.setMode(SlidingMenu.LEFT_RIGHT);
		slidingMenu.setTouchModeAbove(SlidingMenu.TOUCHMODE_MARGIN); // 触摸边界拖出菜单
		slidingMenu.setMenu(R.layout.fragment_leftmenu);

		slidingMenu.setSecondaryMenu(R.layout.slidingmenu_right);
		slidingMenu.setBehindOffsetRes(R.dimen.slidingmenu_offset);
		// 将抽屉菜单与主页面关联起来
		slidingMenu.attachToActivity(this, SlidingMenu.SLIDING_CONTENT);
		getSupportFragmentManager().beginTransaction()
				.replace(R.id.leftmenu, new LeftMenuFragment_register())
				.commit();
		getSupportFragmentManager().beginTransaction()
				.replace(R.id.slidmenuright, new PullToRefreshSampleFragment())
				.commit();

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.left_imbt:
			if (mainviewpage.isShown()) {
				setclabtnimage(null);
				leftbtn.setImageResource(R.drawable.main_bar_btn_left);
				mainpage_itembottom1.setVisibility(View.VISIBLE);
				mainviewpage.setVisibility(View.GONE);
				node_layout.setVisibility(View.GONE);
			} else {
				node_layout.setVisibility(View.GONE);
				slidingMenu.showMenu();
			}
			break;
		case R.id.right_imbt:
			node_layout.setVisibility(View.GONE);
			slidingMenu.showSecondaryMenu();

			break;
		case R.id.bt1:
			if (initFutureSchle(0))
				setclabtnimage(bt1);
			break;
		case R.id.bt2:
			if (initFutureSchle(1))
				setclabtnimage(bt2);
			break;
		case R.id.bt3:
			if (initFutureSchle(2))
				setclabtnimage(bt3);
			break;
		case R.id.bt4:
			if (initFutureSchle(3))
				setclabtnimage(bt4);
			break;
		case R.id.bt5:
			if (initFutureSchle(4))
				setclabtnimage(bt5);
			break;
		case R.id.allsch_imbtn:
			Intent allschintent = new Intent(this, BaseCalendarActivity.class);
			allschintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(allschintent);
			overridePendingTransition(R.anim.slide_left_in,
					R.anim.slide_left_out);

			break;
		case R.id.addsch_imbtn:
			Intent addschintent = new Intent(this, AddScheduleActivity.class);
			addschintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(addschintent);
			overridePendingTransition(R.anim.slide_left_in,
					R.anim.slide_left_out);
			break;
		case R.id.textview_demonstrate:
			if(application.getShifanphotoAvobject() != null){
				AVObject photo = application.getShifanphotoAvobject();
				textview_brand.setText(photo.getString("brand"));
				String photourl = photo.getString("originalURL");
				aq.id(model_imageview).image(photourl, true, false, 0,
						R.drawable.empty_photo, new BitmapAjaxCallback() {
					@Override
					protected void callback(String url, ImageView iv,
							Bitmap bm, AjaxStatus status) {
						super.callback(url, iv, bm, status);
						iv.setImageBitmap(bm);
					}
				});
				try {
					JSONArray colljsoarr = photo.getJSONArray("collocation");

					StringBuffer sb = new StringBuffer("穿搭建议\n");
					for (int i = 0; i < colljsoarr.length(); i++) {
						Map<String,String> map = (Map<String,String>)colljsoarr.get(i);
						if(!TextUtils.isEmpty(map.get("裤子"))){
							sb.append(map.get("裤子")+"+");
						}else if(!TextUtils.isEmpty(map.get("鞋子"))){
							sb.append(map.get("鞋子")+"+");
						}else if(!TextUtils.isEmpty(map.get("外套"))){
							sb.append(map.get("外套")+"+");
						}
					}
					sb.delete(sb.length() - 1, sb.length());
					textview_recommend.setText(sb);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else{
				Toast.makeText(this, "正在加载...请稍候", Toast.LENGTH_SHORT).show();
			}
			break;
		case R.id.textview_streetshot:
			if(application.getJiepaphotoAvobject() != null){
				textview_recommend.setText("");
				textview_brand.setText("");
				AVObject photo = application.getJiepaphotoAvobject();
				String photourl = photo.getString("originalURL");
				aq.id(model_imageview).image(photourl, true, false, 0,
						R.drawable.empty_photo, new BitmapAjaxCallback() {
					@Override
					protected void callback(String url, ImageView iv,
							Bitmap bm, AjaxStatus status) {
						super.callback(url, iv, bm, status);
						iv.setImageBitmap(bm);
					}
				});
			}else{
				Toast.makeText(this, "正在加载...请稍候", Toast.LENGTH_SHORT).show();
			}
			
			break;
		default:
			break;
		}
	}

	/**
	 * 选中时间按钮，改变所有时间背景图
	 * 
	 * @param btn
	 *            选中按钮
	 */
	private void setclabtnimage(Button btn) {
		node_layout.setVisibility(View.VISIBLE);
		leftbtn.setImageResource(R.drawable.main_bar_home);

		mainpage_itembottom1.setVisibility(View.GONE);
		mainviewpage.setVisibility(View.VISIBLE);
		node_layout.setVisibility(View.VISIBLE);

		bt1.setBackgroundDrawable(bluecircle_bj);
		bt2.setBackgroundDrawable(bluecircle_bj);
		bt3.setBackgroundDrawable(bluecircle_bj);
		bt4.setBackgroundDrawable(bluecircle_bj);
		bt5.setBackgroundDrawable(bluecircle_bj);

		if (btn != null)
			btn.setBackgroundDrawable(redcircle_bj);

	}

	class MyPagerAdapter extends android.support.v4.view.PagerAdapter {

		private List<View> views;

		public MyPagerAdapter(List<View> views) {
			this.views = views;
		}

		@Override
		public int getCount() {
			return views.size();
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}

		@Override
		public void destroyItem(View container, int position, Object object) {
			// 将指定的view从viewPager中移除
			((ViewPager) container).removeView(views.get(position));
		}

		@Override
		public Object instantiateItem(View container, int position) {
			// 将view添加到viewPager中
			((ViewPager) container).addView(views.get(position));
			return views.get(position);
		}

		public View getItemAtPosition(int position) {
			return views.get(position);
		}
	}

	/**
	 * 左侧执行登录操作，登录成功回调。
	 */
	@Override
	public void callback(String fragementname, String action) {
		// 注册、登录成功回调
		if ("Leftmenufragement".equals(fragementname)){
			getSupportFragmentManager().beginTransaction()
			.replace(R.id.leftmenu, new LeftMenuFragment_Setting())
			.commit();
			updateInterface();
		}

		// 右侧slidmenu界面回调
		if ("rightmenuFragment".equals(fragementname))
			slidingMenu.showContent();
	}

	private void parxml2list(String cityname, String xml) {
		// 解析对象工厂-->reader对象 读取对象，处理xml
		try {

			SAXParserFactory sf = SAXParserFactory.newInstance();
			SAXParser parse = sf.newSAXParser();
			XMLReader reader = parse.getXMLReader();
			MyHandler h = new MyHandler();
			reader.setContentHandler(h);
			reader.parse(new InputSource(new StringReader(xml)));
			List<Weather> list = h.getWeathers();
			application.addtCityWeathers2map(cityname, list);
			Log.i("MyTag", "-获取天气集合---number:" + list.size());

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private ProgressDialog progressDialog;

	public void createWiatDialog(String str) {
		progressDialog = new ProgressDialog(this, R.style.MyDialog);

		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		// progressDialog.setTitle("Loading...");
		progressDialog.setMessage(str);
		// progressDialog.setIcon(null);
		// progressDialog.setCancelable(false);
		progressDialog.show();

	}

	/**
	 * 根据当前城市，初始化界面天气以及5个日期
	 * 
	 * @param cityname
	 */
	private void initWetherPage(String cityname) {
		List<Weather> Wetherlist = application.getCityWeathers(cityname);
		Log.i("MyTag", "------获取当前城市天气列表------");
		if (Wetherlist == null || Wetherlist.size() == 0)
			return;
		Log.i("MyTag", "------获取当前城市天气列表------" + Wetherlist.size());

		Weather wether = Wetherlist.get(0);
		TextView wether0_textview = (TextView) findViewById(R.id.wether0_textview);
		TextView date0_textview = (TextView) findViewById(R.id.date0_textview);
		TextView lowhightemp_textview = (TextView) findViewById(R.id.lowhightemp_textview); // 主页面最高最低温度view
		wether0_textview.setText(wether.getTemp());
		Date date = application.getNowdate();
		if(Wetherlist.size()>1)
		{
			String lowtemp = Wetherlist.get(1).getLowtemp();
			String hightemp = Wetherlist.get(1).getHightemp();
			lowhightemp_textview.setText("温度:"+lowtemp+"~"+hightemp);
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		date0_textview.setText(sdf.format(date));
		SimpleDateFormat daysdf = new SimpleDateFormat("dd");
		int day1 = Integer.parseInt(daysdf.format(date));
		bt1.setText(day1 + "");
		bt2.setText((day1 + 1) + "");
		bt3.setText((day1 + 2) + "");
		bt4.setText((day1 + 3) + "");
		bt5.setText((day1 + 4) + "");

	}

	private Handler mhandler = new Handler() {
		private int count = 0;

		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 1:
				count++;
				if (count == 3) {
					cancleWaitDialog();
				}
				break;

			default:
				break;
			}

		};
	};

	public void cancleWaitDialog() {
		if (progressDialog != null && progressDialog.isShowing())
			progressDialog.cancel();
	}

	interface Callback {
		void dosomething();
	}

	/**
	 * 根据参数获取天气
	 * 
	 * @param cityname
	 * @param woid
	 * @param callback
	 */

	private void getCityWeathers(final String cityname, final String woid,
			final Callback callback) {
		if (!TextUtils.isEmpty(cityname)) {
			if (application.getCityWeathers(cityname) != null) {
				callback.dosomething();
				return;
			}
			ALWeatherEngine.defauleEngine().mgetWeather(cityname,
					new com.basha.serveRequest.ALEngineConfig.CallBack() {

						@Override
						public void done(Object object, AVException avexception) {
							Log.i("MyTag", "-------获取天气---Object:" + object
									+ " avexception:" + avexception);
							if (object == null) {

							} else {
								parxml2list(cityname, (String) object);
								callback.dosomething();
							}
							if (avexception != null) {
								avexception.printStackTrace();
							}
						}
					});

			return;
		}

		if (!TextUtils.isEmpty(woid)) {
			if (application.getCityWeathers(woid) != null) {
				callback.dosomething();
				return;
			}
			ALWeatherEngine.defauleEngine().getWeather(woid,
					new com.basha.serveRequest.ALEngineConfig.CallBack() {

						@Override
						public void done(Object object, AVException avexception) {
							Log.i("MyTag", "-------获取天气---Object:" + object
									+ " avexception:" + avexception);
							if (object == null) {

							} else {
								parxml2list(woid, (String) object);
								callback.dosomething();
							}
							if (avexception != null) {
								avexception.printStackTrace();
							}
						}
					});
			return;
		}
	}

	/**
	 * 请求当前日期，当前城市天气，所有日程，pm值
	 */
	private void updateInterface() {
		// createWiatDialog("初始化...");

		final String districtname = application.getNowDistrictnamename(); // 当前设置地区名
		final String cityName = application.getNowCityname(); // 当前设置省会名
		cityname_textView.setText(districtname);

		initWetherPage(districtname);

		getCityWeathers(districtname, null, new Callback() {

			@Override
			public void dosomething() {
				initWetherPage(districtname);
				List<Weather> Wetherlist = application.getCityWeathers(districtname);
				if (Wetherlist == null || Wetherlist.size() == 0)
					return;
				Weather wether = Wetherlist.get(0);
				//示范
				ALPhotoEngine.defauleEngine().getPhotoForWeather(Float.parseFloat(wether.getTemp()), Integer.parseInt(wether.getCode()),true,0,0, new CallBack() {
					
					@Override
					public void done(Object object, AVException avexception) {
						Log.i("MyTag", avexception+"----示范照片---"+object);
						if(avexception == null){
							if(object != null){
								AVObject photo = (AVObject) object;
								application.setShifanphotoAvobject(photo);
								textview_brand.setText(photo.getString("brand"));
								Log.i("MyTag", avexception+"----示范照片品牌---"+photo.getString("brand"));

								String photourl = photo.getString("originalURL");

								aq.id(model_imageview).image(photourl, true, false, 0,
										R.drawable.empty_photo, new BitmapAjaxCallback() {
									@Override
									protected void callback(String url, ImageView iv,
											Bitmap bm, AjaxStatus status) {
										super.callback(url, iv, bm, status);
										iv.setImageBitmap(bm);
									}
								});


								
								try {
									JSONArray colljsoarr = photo.getJSONArray("collocation");

									StringBuffer sb = new StringBuffer("穿搭建议\n");
									for (int i = 0; i < colljsoarr.length(); i++) {
										Map<String,String> map = (Map<String,String>)colljsoarr.get(i);
										if(!TextUtils.isEmpty(map.get("裤子"))){
											sb.append(map.get("裤子")+"+");
										}else if(!TextUtils.isEmpty(map.get("鞋子"))){
											sb.append(map.get("鞋子")+"+");
										}else if(!TextUtils.isEmpty(map.get("外套"))){
											sb.append(map.get("外套")+"+");
										}
									}
									sb.delete(sb.length() - 1, sb.length());
									textview_recommend.setText(sb);
								} catch (Exception e) {
									e.printStackTrace();
								}
							}
						}else{
							avexception.printStackTrace();
						}
					}
				});
				
				//街拍
					ALPhotoEngine.defauleEngine().getPhotoForWeather(Float.parseFloat(wether.getTemp()), Integer.parseInt(wether.getCode()),false,0,0, new CallBack() {
						
						@Override
						public void done(Object object, AVException avexception) {
							Log.i("MyTag", avexception+"----街拍照片---"+object);

							if(avexception == null){
								if(object != null){
									AVObject photo = (AVObject) object;
									application.setJiepaphotoAvobject(photo);
									
								}
							}else{
								avexception.printStackTrace();
							}
						}
					});
			}
		});

		
		if (application.getNowdate() != null) {
			ALWeatherEngine.defauleEngine().currentDate(
					new com.basha.serveRequest.ALEngineConfig.CallBack() {

						@Override
						public void done(Object object, AVException avexception) {
							Log.i("MyTag", "-------获取当前日期---Object:" + object
									+ " avexception:" + avexception);

							if (object != null) {
								Long timesce = ((Long) object);
								Calendar cal = Calendar.getInstance();
								cal.setTimeZone(TimeZone
										.getTimeZone("GMT+08:00"));
								cal.setTimeInMillis(timesce);
								application.setNowdate(cal.getTime());
								initWetherPage(districtname);
							}

							if (avexception != null) {
								avexception.printStackTrace();
							}
						}
					});
		}

		// createWiatDialog("正在加载...");
		ALUserEngine.defauleEngine().getMyScheduleList(
				new com.basha.serveRequest.ALEngineConfig.CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						Log.i("MyTag", "-------获取所有日程---Object:" + object
								+ " avexception:" + avexception);
						if (avexception == null) {
							setScheldList((List<AVObject>) object);
							showSched();
						} else {
							avexception.printStackTrace();
						}
					}
				});
		ALWeatherEngine.defauleEngine().getAQI(cityName, new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				Log.i("MyTag",avexception +"-------getPM25-----"+object);
				if(avexception == null){
					if(object != null){
						pm_textview.setText("空气质量指数:"+object);
					}
				}else{
					avexception.printStackTrace();
					pm_textview.setText("空气质量指数:");

				}
				
			}
		});
		

	}

	private List<AVObject> scheldList = null;

	private mapplication application;

	/**
	 * 根据当前日期，过滤5天内所有日程
	 * 
	 * @param list
	 */

	private void setScheldList(List<AVObject> list) {
		if (list == null || list.size() == 0){
			scheldList = new ArrayList<AVObject>();			
			return;
		}
		Log.i("MyTag", "----日程总数-" + list.size());
		Date date = application.getNowdate();
		Calendar cal = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		cal.setTime(date);
		cal2.setTime(date);
		cal.add(Calendar.DAY_OF_MONTH, -1);
		cal2.add(Calendar.DAY_OF_MONTH, 5);

		for (int i = 0; i < list.size(); i++) {
			AVObject avobject = list.get(i);
			Date schdate = avobject.getDate("date");
			Calendar schcal = Calendar.getInstance();
			schcal.setTime(schdate);
			if (schcal.after(cal) && schcal.before(cal2)) {

			} else {
				list.remove(i);
			}
		}
		scheldList = list;
		Log.i("MyTag", "-----5天内日程总数：" + list.size());
	}

	/**
	 * 根据日期查找该日内所有日程
	 * 
	 * @param day
	 */
	private boolean initFutureSchle(int day) {
		if(AVUser.getCurrentUser() == null){
			Toast.makeText(getApplicationContext(), "您还没有登录", Toast.LENGTH_SHORT).show();
			return false;
		}
		
		boolean flag = false;
		if(scheldList == null){
			Toast.makeText(getApplicationContext(), "正在加载日程，请稍等...", Toast.LENGTH_SHORT).show();
            return false;
		}
		if(scheldList.size() == 0){
			Toast.makeText(getApplicationContext(), "当日没有日程安排", Toast.LENGTH_SHORT).show();
			return false;
		}
		
		List<AVObject> avobjectlist = new ArrayList<AVObject>();
		Date ndate = application.getNowdate();
		Calendar ncal = Calendar.getInstance();
		ncal.setTime(ndate);
		ncal.add(Calendar.DAY_OF_MONTH, day);

		for (int i = 0; i < scheldList.size(); i++) {
			AVObject avobject = scheldList.get(i);
			Date date = avobject.getDate("date");
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			if (compCalWithDay(ncal, cal)) {
				avobjectlist.add(avobject);
				flag = true;
			}
		}
		
		if(avobjectlist.size() == 0){
			Toast.makeText(getApplicationContext(), "当日没有日程安排", Toast.LENGTH_SHORT).show();
			return false;
		}
		showViewPage(avobjectlist, day);

		return flag;
	}

	/**
	 * 根据点击的按钮选择显示viewpage
	 * 
	 * @param list
	 */
	private void showViewPage(List<AVObject> list, int day) {
		Log.i("MyTag", "----显示viewpage页面---日程:" + list.size());
		if(list == null || list.size() == 0)
			return;
		List<View> viewlist = new ArrayList<View>();
		int width = DensityUtil.dip2px(getApplicationContext(), 15);
		node_layout.removeAllViews();

		for (int i = 0; i < list.size(); i++) {
			View view = LayoutInflater.from(this).inflate(
					R.layout.main_viewpage_item, null);

			ImageView image_model = (ImageView) view
					.findViewById(R.id.imageview_model); // 模特图片view
			ImageView image01 = (ImageView) view.findViewById(R.id.image01); // 日程类型view
			ImageView image02 = (ImageView) view.findViewById(R.id.image02); // 天气图标view
			TextView textview01 = (TextView) view.findViewById(R.id.textview01); // 日程正文view
			final TextView textview02 = (TextView) view
					.findViewById(R.id.textview02); // 城市温度显示view
			TextView textview03 = (TextView) view.findViewById(R.id.textview03); // 衣服推荐内容
			TextView textview04 = (TextView) view.findViewById(R.id.textview04); // 衣服推荐name

			AVObject avobject = list.get(i); // 日程对象
			String text01 = avobject.getAVObject("content").getString("text"); // 日程内容
			int type = avobject.getInt("type"); // 日程类型

			final String woeid = avobject.getString("woeid"); // 日程对应城市woeid
			final String cityname = avobject.getString("place"); // 日程城市
			final Date date = avobject.getDate("date"); // 日程城市
			SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
			textview01.setText(sdf.format(date)+"\n"+text01 + "(" + cityname + ")");
			getCityWeathers(null, woeid, new Callback() {

				@Override
				public void dosomething() {
					List<Weather> weathers = application.getCityWeathers(woeid);
					if (weathers != null && weathers.size() != 0) {
						String temp = weathers.get(0).getTemp();
						textview02.setText(temp);
//						for (int j = 0; j < weathers.size(); j++) {
//							Weather  mweather = weathers.get(i);
//							Date date = mweather.getDate();dfd
//						}
					}
				}
			});

			viewlist.add(view);

			// 添加示意小圆点
			ImageView iv = new ImageView(this);
			LayoutParams lap = new LayoutParams(width, width);
			lap.rightMargin = width / 3;
			// iv.setLayoutParams(lap);
			iv.setBackgroundColor(Color.TRANSPARENT);
			iv.setImageBitmap(blackcry);
			if (i == 0)
				iv.setImageBitmap(bluecry);
			node_layout.addView(iv, lap);
		}

		MyPagerAdapter adpter = new MyPagerAdapter(viewlist);
		mainviewpage.setAdapter(adpter);
	}
     @Override
    protected void onDestroy() {
    	super.onDestroy();
    	Intent serviceintent = new Intent(this,LocationService.class);
//		stopService(serviceintent);
    }
	/**
	 * 比较日期为同一天
	 * 
	 * @param c1
	 *            日历天1
	 * @param c2日历天2
	 * @return
	 */
	public boolean compCalWithDay(Calendar c1, Calendar c2) {
		if (c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR)
				&& (c1.get(Calendar.MONTH) == c2.get(Calendar.MONTH))
				&& c1.get(Calendar.DAY_OF_MONTH) == c2
						.get(Calendar.DAY_OF_MONTH)) {
			return true;
		}
		return false;
	}

	
	// SimpleOnGestureListener 是Android SDK提供的一个listener类来侦测各种不同的手势;
	class GestureListener extends SimpleOnGestureListener {
		@Override
		// 在onFling方法中, 判断是不是一个合理的swipe动作;
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
				float velocityY) {
			Log.i("MyTag", Math.abs(velocityX)+"------onFling----"+(e1.getX() - e2.getX()));
			try {
				if (e1.getX() - e2.getX() > 200
						&& Math.abs(velocityX) > 100) {
				
					return false;

				} else if (e2.getX() - e1.getX() > 200
						&& Math.abs(velocityX) > 100) {
					if(slidingMenu.isSecondaryMenuShowing())
						slidingMenu.showContent();
					
					return false;

				}
			} catch (Exception e) {
				// nothing
			}
			return false;
		}

	}
	
//	
//	@Override
//	// 获取手势action;
//	public boolean onTouch(View v, MotionEvent event) {
//		mGesture.onTouchEvent(event);
//		return super.onTouchEvent(event);
//
//	}
	


	@Override
	public boolean onTouchEvent(MotionEvent event) {
		this.mGesture.onTouchEvent(event);
		return super.onTouchEvent(event);

	}
	
	 @Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		return super.dispatchKeyEvent(event);
	}

}