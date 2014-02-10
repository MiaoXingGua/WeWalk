package com.basha.activity;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxStatus;
import com.androidquery.callback.BitmapAjaxCallback;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALUserEngine;
import com.basha.util.BitmapUtils;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class UnreadMessageActivity extends BaseAcitvity implements
		OnClickListener {
	private ImageButton leftbtn;
	private TextView title_textview;
	private ListView follow_listview;
	private String page; // 跳转的页面follow\message\
	private madpter adpter;
	private AQuery aq;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.following);
		initactionbar();
		setView();
		updateInterface();
		setListen();
	}

	private void setView() {
		follow_listview = (ListView) findViewById(R.id.follow_listview);
		adpter = new madpter();
		follow_listview.setAdapter(adpter);

		aq = new AQuery(this);

	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("私信");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setOnClickListener(this);
		leftbtn.setImageResource(R.drawable.actionbar_back_pic);

	}
	
	private void setListen(){
		follow_listview.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
                  Map map =  adpter.getItem(arg2);
				AVUser fromavuser = (AVUser) map.get("user");
				((mapplication)getApplication()).setSchAvobject(fromavuser);
				Intent perinfointent = new Intent(UnreadMessageActivity.this,
						ChatActivity.class);
				perinfointent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivity(perinfointent);
			}
		});
	}

	private void updateInterface() {
		createWiatDialog("加载页面");
		ALUserEngine.defauleEngine().getAllUnreadMessageCountAboutUser(
				new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						cancleWaitDialog();

						if (avexception == null) {
							if (object != null) {
								ArrayList<Map> results = (ArrayList<Map>) object;
								if (results == null || results.size() == 0) {
									showToast("没有消息");
									return;
								}
								
								adpter.setData(results);
								adpter.notifyDataSetChanged();
							}
						} else {
							avexception.printStackTrace();
						}
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

	class madpter extends BaseAdapter {
		private ArrayList<Map> list = null;

		@Override
		public int getCount() {
			return list.size();
		}

		public madpter() {
			list = new ArrayList<Map>();
		}

		@Override
		public Map getItem(int position) {
			return list.get(position);
		}

		public void setData(ArrayList<Map> list) {
			this.list = list;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			Map map = (Map) list.get(position);
		      AVUser fromavuser = (AVUser) map.get("user");
		      
		      int count = (Integer) map.get("count");
			String headpicurl_small = fromavuser.getString("smallHeadViewURL");
			String nickname = fromavuser.getString("nickname");
			View view = LayoutInflater.from(UnreadMessageActivity.this)
					.inflate(R.layout.listview_follow_item, null);
			TextView msgnum_btn = (TextView) view.findViewById(R.id.msgnum_btn);
			ImageView head_imageview = (ImageView) view
					.findViewById(R.id.head_imageview);
			TextView nickname_textview = (TextView) view
					.findViewById(R.id.nickname_textview);
				msgnum_btn.setVisibility(View.VISIBLE);
			aq.id(head_imageview).image(headpicurl_small, true, false, 0, 0,
					new BitmapAjaxCallback() {
						@Override
						protected void callback(String url, ImageView iv,
								Bitmap bm, AjaxStatus status) {
							super.callback(url, iv, bm, status);
							Bitmap mbitmap = BitmapUtils
									.getCircleStrokbitmap(
											UnreadMessageActivity.this,
											bm,
											(int) getResources()
													.getDimension(
															R.dimen.followpage_item_heardpic_h),
											5, "#ffffff");
							iv.setImageBitmap(mbitmap);
						}
					});
			nickname_textview.setText(nickname);
			msgnum_btn.setText(count+"");
			return view;
		}

	}

}
