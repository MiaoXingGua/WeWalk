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
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class MyFollowingActivity extends BaseAcitvity implements OnClickListener{
	private ImageButton leftbtn;
	private TextView title_textview;
	private ListView follow_listview;
	private String page;  //跳转的页面follow\message\
	private madpter adpter;
	private AQuery aq;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.following);
		 page = getIntent().getStringExtra("page");
		initactionbar();
		setView();
		setListen();
		updateInterface();
	}
	
	private void setView(){
		follow_listview = (ListView)findViewById(R.id.follow_listview);
		 adpter = new madpter();
		follow_listview.setAdapter(adpter);
		
		aq = new AQuery(this);
		
	}
	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("粉丝");
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
				AVObject avuser =  adpter.getItem(arg2);
				((mapplication)getApplication()).setSchAvobject(avuser);
				Intent perinfointent = new Intent(MyFollowingActivity.this,
						PerInfoActivity.class);
				perinfointent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivity(perinfointent);
			}
		});
	}
	private void updateInterface(){
		createWiatDialog("加载页面");
		ALUserEngine.defauleEngine().myFollows(new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				cancleWaitDialog();
			
 				       if(avexception == null){
 				    	   if(object != null){
 				    		  List<AVObject> results = (List<AVObject>) object;
 				    		  if(results == null || results.size() == 0){
                                showToast("您没有粉丝");
                                return;
 				    		  }
 				    		  adpter.setData(results);
 				    		 adpter.notifyDataSetChanged();
 				    	   }
 				       }else{
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
	
	class madpter extends BaseAdapter{
		private List<AVObject> list = null;

		@Override
		public int getCount() {
			return list.size();
		}

		 public madpter(){
			 list = new ArrayList<AVObject>();
		 }
		@Override
		public AVObject getItem(int position) {
			return list.get(position);
		}
		
		public void setData(List<AVObject> list){
			this.list = list;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			boolean flag = list.get(position)instanceof AVUser;
			Log.i("MyTag", "------getview------"+flag);
			AVUser avuser = (AVUser) list.get(position);
			String headpicurl_small = avuser.getString("smallHeadViewURL");
			String nickname = avuser.getString("nickname");
			Log.i("MyTag", "------getview------headpicurl_small："+headpicurl_small);
			Log.i("MyTag", "------getview------nickname："+nickname);
			Log.i("MyTag", "------getview------object："+avuser.getObjectId());

			View view = LayoutInflater.from(MyFollowingActivity.this).inflate(R.layout.listview_follow_item, null);
			TextView msgnum_btn = (TextView)view.findViewById(R.id.msgnum_btn);
			ImageView head_imageview = (ImageView)view.findViewById(R.id.head_imageview);
			TextView nickname_textview = (TextView)view.findViewById(R.id.nickname_textview);
              if("message".equals(page)){
            	  msgnum_btn.setVisibility(View.VISIBLE);
              }
  
				aq.id(head_imageview).image(headpicurl_small, true, false, 0, 0,
						new BitmapAjaxCallback() {
							@Override
							protected void callback(String url, ImageView iv,
									Bitmap bm, AjaxStatus status) {
								super.callback(url, iv, bm, status);
								Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
										MyFollowingActivity.this,
										bm,
										(int) getResources().getDimension(
												R.dimen.followpage_item_heardpic_h), 5,
										"#ffffff");
								iv.setImageBitmap(mbitmap);
							}
						});
				nickname_textview.setText(nickname);
				
			return view;
		}
		
	}

}
