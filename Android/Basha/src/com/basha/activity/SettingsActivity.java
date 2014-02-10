package com.basha.activity;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALUserEngine;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.util.DensityUtil;
import com.basha.util.Util;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

public class SettingsActivity extends Activity implements OnClickListener {
	private ImageButton leftbtn;
	private TextView title_textview;
	private LinearLayout addcity_layout;
	private TextView readset_layout;
	private LinearLayout clearcahch_layout;
	private TextView otherset_layout;
	private LinearLayout comment_layout;
	private LinearLayout mark_layout;
	private LinearLayout about_layout;
	private LinearLayout logout_layout;
	private ListView city_listview;
	private SharedPreferences shp;
	private MyAdpter adpter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.settings);
		initactionbar();
		setView();
	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("设置");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
		leftbtn.setOnClickListener(this);
		leftbtn.setPadding(0, 0, 20, 0);

	}

	private void setView() {
		addcity_layout = (LinearLayout) findViewById(R.id.addcity_layout);
		readset_layout = (TextView) findViewById(R.id.readset_layout);
		clearcahch_layout = (LinearLayout) findViewById(R.id.clearcahch_layout);
		otherset_layout = (TextView) findViewById(R.id.otherset_layout);
		comment_layout = (LinearLayout) findViewById(R.id.comment_layout);
		mark_layout = (LinearLayout) findViewById(R.id.mark_layout);
		about_layout = (LinearLayout) findViewById(R.id.about_layout);
		logout_layout = (LinearLayout) findViewById(R.id.logout_layout);
		city_listview = (ListView) findViewById(R.id.city_listview);

		addcity_layout.setOnClickListener(this);
		readset_layout.setOnClickListener(this);
		clearcahch_layout.setOnClickListener(this);
		otherset_layout.setOnClickListener(this);
		comment_layout.setOnClickListener(this);
		mark_layout.setOnClickListener(this);
		about_layout.setOnClickListener(this);
		logout_layout.setOnClickListener(this);

		shp = getSharedPreferences("basha", MODE_PRIVATE);

		adpter = new MyAdpter(this);
		city_listview.setAdapter(adpter);

		city_listview.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				adpter.setSelectIndex(arg2);
				adpter.notifyDataSetChanged();
			}
		});

		city_listview.setOnItemLongClickListener(new OnItemLongClickListener(
				) {

					@Override
					public boolean onItemLongClick(AdapterView<?> arg0,
							View arg1, int arg2, long arg3) {
						city_listview.setTag(arg2);
 						return false;
					}
		});
		String citysjsonarr = shp.getString("setting_citys", "");

		try {
			JSONArray jsonarr = new JSONArray(citysjsonarr);
			int index = shp.getInt("setting_citys_select", 0);
			adpter.setData(jsonarr);
			adpter.setSelectIndex(index);
			adpter.notifyDataSetChanged();
			setListViewHeightBasedOnChildren(city_listview);
		} catch (JSONException e) {
			e.printStackTrace();
		}
      
		registerForContextMenu(city_listview);
	}

	public static void setListViewHeightBasedOnChildren(ListView listView) {  
         ListAdapter listAdapter = listView.getAdapter();   
        if (listAdapter == null) {  
            // pre-condition  
            return;  
        }  
  
        int totalHeight = 0;  
        for (int i = 0; i < listAdapter.getCount(); i++) {  
            View listItem = listAdapter.getView(i, null, listView);  
            listItem.measure(0, 0);  
            totalHeight += listItem.getMeasuredHeight();  
        }  
  
        ViewGroup.LayoutParams params = listView.getLayoutParams();  
        params.height = totalHeight + (listView.getDividerHeight() * (listAdapter.getCount() - 1));  
        listView.setLayoutParams(params);  
    }  
	@Override
	public void onCreateContextMenu(ContextMenu menu, View v,
			ContextMenuInfo menuInfo) {
		menu.add(0, 1, 0, "删除");
		menu.add(0, 2, 0, "取消");
	}

	@Override
	public boolean onContextItemSelected(MenuItem item) {
		 int index = (Integer)city_listview.getTag();
		switch (item.getItemId()) {
		case 1:
			adpter.removeIndex(index);
			adpter.notifyDataSetChanged();
			break;
		case 2:
			break;
		default:
			break;
		}
		return super.onContextItemSelected(item);
	}
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.left_imbt:
			this.finish();
			break;
		case R.id.addcity_layout:
			Intent intent = new Intent(this, CitySelcetActivtiy.class);
			intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivityForResult(intent, 1);
			break;
		case R.id.logout_layout:
			showDialog();
			break;
		default:
			break;
		}
	}
     private void showDialog(){
    	 new AlertDialog.Builder(this).setMessage("是否注销登录").setPositiveButton("确认", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				ALUserEngine.defauleEngine().logOut();
			   Toast.makeText(getApplicationContext(), "注销成功", Toast.LENGTH_SHORT).show();
			}
		}).setNegativeButton("取消", null).create().show();
     }
	
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (data != null) {
			String cityname = data.getStringExtra("cityname");
			String districtname = data.getStringExtra("districtname");
			String text = data.getStringExtra("text");

			String citysjsonarr = shp.getString("setting_citys", "");
			JSONArray jsonarr;

			try {
				jsonarr = new JSONArray(citysjsonarr);
			} catch (JSONException e) {
				jsonarr = new JSONArray();
				e.printStackTrace();
			}
			if (!jsonarr.toString().contains(districtname)){
			 try {
				 JSONObject jsonobject = new JSONObject();
				 jsonobject.put("cityname", cityname);
				jsonobject.put("districtname", districtname);
				jsonarr.put(jsonobject);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				
			}
			shp.edit().putString("setting_citys", jsonarr.toString()).commit();
			adpter.setSelectIndex(jsonarr.length() - 1);
			adpter.setData(jsonarr);
			adpter.notifyDataSetChanged();
			setListViewHeightBasedOnChildren(city_listview);

		}
	}

	class MyAdpter extends BaseAdapter {
		private JSONArray jsonarr;
		private Context context;
		private int selectindex = 0;

		@Override
		public int getCount() {
			return jsonarr.length();
		}

		@Override
		public JSONObject getItem(int position) {
			JSONObject ojbect = null;
			try {
				ojbect = jsonarr.getJSONObject(position);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return ojbect;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		public void setData(JSONArray jsonarr) {
			this.jsonarr = jsonarr;
			selectindex = shp.getInt("setting_citys_select", 0);
		}

		public void setSelectIndex(int index) {
			shp.edit().putInt("setting_citys_select", index).commit();
			this.selectindex = index;
		}

		public MyAdpter(Context context) {
			this.context = context;
			jsonarr = new JSONArray();
		}
          public void removeIndex(int index){
        	  JSONArray mjsonarr = new JSONArray();
        	  for (int i = 0; i < jsonarr.length(); i++) {
				if(i != index){
					try {
						mjsonarr.put(jsonarr.get(i));
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			}
        	  this.jsonarr = mjsonarr;
        	  shp.edit().putString("setting_citys", jsonarr.toString()).commit();
        	  if(index == selectindex){
        		  setSelectIndex(0);
        	  }else if(index < selectindex){
        		  selectindex = selectindex - 1;
        		  setSelectIndex(selectindex);
        	  }
          }
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View view = LayoutInflater.from(context).inflate(
					R.layout.listview_item_setting_city, null);
			String text = "";
			try {
				JSONObject jsonobject = jsonarr.getJSONObject(position);
				text = jsonobject.getString("districtname");
			} catch (JSONException e) {
				e.printStackTrace();
			}
			ImageView iv = (ImageView) view
					.findViewById(R.id.city_setting_rightiv);
			iv.setVisibility(View.INVISIBLE);
			TextView textview = (TextView) view
					.findViewById(R.id.city_textview);
			textview.setText(text);
			if (position == selectindex)
				iv.setVisibility(View.VISIBLE);

			return view;
		}

	}

}
