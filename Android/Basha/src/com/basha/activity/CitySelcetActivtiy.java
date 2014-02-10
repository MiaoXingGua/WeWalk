package com.basha.activity;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.bash.sqlite.AssetsDatabaseManager;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AbsListView.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

public class CitySelcetActivtiy extends Activity implements OnClickListener {
	private EditText city_edittext;
	private Button search_btn;
	private ListView citylistview;
	private mAdpert adpter;
	private GridView cityGridView;
	private mAdpert hotapter;
	private ImageButton leftbtn;
	private SharedPreferences shp;
	private static final int RESULT_OK = 1;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.cityselcet);
		setView();
		setListener();
		initactionbar();
	}
	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		TextView title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("添加");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
		Rightbtn.setImageResource(R.drawable.actionbar_btn_y);
		leftbtn.setOnClickListener(this);
		leftbtn.setPadding(0, 0, 20, 0);

	}
	private void setView() {
		shp = getSharedPreferences("basha", MODE_PRIVATE);

		city_edittext = (EditText) findViewById(R.id.city_edittext);
		search_btn = (Button) findViewById(R.id.search_btn);
		citylistview = (ListView) findViewById(R.id.citylistview);
		cityGridView = (GridView) findViewById(R.id.cityGridView);
		search_btn.setOnClickListener(this);
		city_edittext.setOnClickListener(this);
		adpter = new mAdpert();
		citylistview.setAdapter(adpter);
		
		 hotapter = new mAdpert();
		hotapter.setData(Arrays.asList(getResources().getStringArray(R.array.hotcity_arry)));
		cityGridView.setAdapter(hotapter);
		
		city_edittext.addTextChangedListener(new TextWatcher() {
			
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				adpter.setData(searchCity(s.toString()));
				adpter.notifyDataSetChanged();
			}
			
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
				
			}
			
			@Override
			public void afterTextChanged(Editable s) {
				
			}
		});
		
	}
	
	private void setListener(){
		citylistview.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
			    String str = ((TextView)arg1).getText().toString();
			    String cityname = str.substring(str.lastIndexOf(" - ")+3);
			    String districtname = str.substring(0, str.lastIndexOf(" - "));
				Intent intent = new Intent();
				intent.putExtra("cityname", cityname);
				intent.putExtra("districtname", districtname);
				intent.putExtra("text", str);
				setResult(RESULT_OK, intent);
				CitySelcetActivtiy.this.finish();
			}
		});
		cityGridView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				Intent intent = new Intent();
				intent.putExtra("cityname", ((TextView)arg1).getText().toString());
				intent.putExtra("districtname", ((TextView)arg1).getText().toString());
				intent.putExtra("text", ((TextView)arg1).getText().toString());
				setResult(RESULT_OK, intent);
				CitySelcetActivtiy.this.finish();

			}
		});
	}
	

	private ArrayList searchCity(String str) {
		ArrayList<String> citylist = new ArrayList<String>();

		// 初始化，只需要调用一次
		AssetsDatabaseManager.initManager(getApplication());
		// 获取管理对象，因为数据库需要通过管理对象才能够获取
		AssetsDatabaseManager mg = AssetsDatabaseManager.getManager();
		// 通过管理对象获取数据库
		SQLiteDatabase db = mg.getDatabase("citylist.db");
		Cursor result = db
				.query("City",
						null,
						"cityName like ? or districtName like ? or districtSpell1 like ? or districtSpell2 like ?",
						new String[] { "%" + str + "%", "%" + str + "%",
								"%" + str + "%", "%" + str + "%" }, null, null,
						null);

		Log.i("MyTag", "------查询城市数据库:" + result.getCount());

		// 对数据库进行操作
		// db1.execSQL("insert into tb([ID],[content]) values(null, 'db1');");
		result.moveToFirst();
		for (int i = 0; i < result.getCount(); i++) {
			String districtname = result.getString(3);
			String cityname = result.getString(2);
			citylist.add(districtname + " - " + cityname);
			result.moveToNext();
		}
		result.close();
//		db.close();
		return citylist;
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.search_btn:
			citylistview.setVisibility(View.GONE);
			cityGridView.setVisibility(View.VISIBLE);
			search_btn.setVisibility(View.GONE);
			city_edittext.setText("");
			break;
		case R.id.city_edittext:
			if(citylistview.isShown())
				return;
			citylistview.setVisibility(View.VISIBLE);
			cityGridView.setVisibility(View.GONE);
			search_btn.setVisibility(View.VISIBLE);
			break;
		case R.id.left_imbt:
			this.finish();
			break;
			
		default:
			break;
		}
	}

	class mAdpert extends BaseAdapter {
		private List<String> list;
		private List<String> hotCitylist;
		String citysjsonarr = shp.getString("setting_citys", "");

     
		@Override
		public int getCount() {
			if(list == null)
				return 0;
			return this.list.size();
		}
      
	    public void setData(List list){
	    	this.list = list;
	    }
	    
	    public void setHotCityData(List list){
	    	this.hotCitylist = list;
	    }
	    
		@Override
		public Object getItem(int arg0) {
			return null;
		}

		@Override
		public long getItemId(int arg0) {
			return 0;
		}
//
//		@Override
//		public View getView(int position, View convertView, ViewGroup parent) {
////			LayoutParams lap = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
//			Holder holder;
//			if (null == convertView) {
//				holder = new Holder();
//				convertView = new TextView(CitySelcetActivtiy.this);
//				holder.textView = (TextView) convertView;
//				convertView.setTag(holder);
//			} else {
//				holder = (Holder) convertView.getTag();
//			}
//			holder.textView.setText(list.get(position));
//			((TextView)convertView).setPadding(30, 30, 30, 30);
//			((TextView)convertView).setTextSize(18);
//			if(hotCitylist != null && hotCitylist.contains(list.get(position)))
//			{
//				((TextView)convertView).setTextSize(20);
//				((TextView)convertView).setTextColor(Color.parseColor("#f47920"));
//			}
//			return convertView;
//		}
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
//			LayoutParams lap = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
			TextView textview = new TextView(CitySelcetActivtiy.this);
			textview.setText(list.get(position));
			textview.setPadding(30, 30, 30, 30);
			textview.setTextSize(18);
			if(hotCitylist != null && hotCitylist.contains(list.get(position)) || citysjsonarr.contains(list.get(position)))
			{
				textview.setTextSize(20);
				textview.setTextColor(Color.parseColor("#f47920"));
			}
			
			return textview;
		}

	}

	class Holder {
		public TextView textView;

	}
}
