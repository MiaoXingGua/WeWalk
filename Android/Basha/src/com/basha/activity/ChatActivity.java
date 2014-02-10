package com.basha.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxStatus;
import com.androidquery.callback.BitmapAjaxCallback;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALPhotoEngine;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALUserEngine;
import com.basha.util.BitmapUtils;
import com.basha.util.DensityUtil;

public class ChatActivity extends BaseAcitvity implements OnClickListener {

	private TextView title_textview;
	private ListView listview_permsg;
	private AVUser muser; // 聊天对象
	private AVUser curruser; // 当前用户
	private AQuery aq;
	private EditText content_edittext;
	private Button send_btn;
	private MyBaseAdpter adpter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.chat);
		initactionbar();
		setView();
		updateInterface();

	}

	private void setView() {
		listview_permsg = (ListView) findViewById(R.id.listview);
		content_edittext = (EditText) findViewById(R.id.content_edittext);
		send_btn = (Button) findViewById(R.id.send_btn);
		send_btn.setOnClickListener(this);
		aq = new AQuery(this);
		adpter = new MyBaseAdpter(this);
		listview_permsg.setAdapter(adpter);
	}

	private void initactionbar() {
		ImageButton leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("Cherry Brown");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setOnClickListener(this);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
	}

	private void updateInterface() {
		curruser = AVUser.getCurrentUser();
		muser = (AVUser) ((mapplication) getApplication()).getSchAvobject();
		if (muser == null)
			return;
		String nickname = muser.getString("nickname");
		title_textview.setText(nickname);
		
		ALUserEngine.defauleEngine().getUserMessage(muser, 0, null, new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
                    if(avexception == null){
                    	if(object == null)
                           return;
                    	List<AVObject> list = (List<AVObject>) object ;
                    	if(list == null || list.size() == 0)
                    		return;
                    	adpter.setData(list);
                    	adpter.notifyDataSetChanged();
                    	
                    }else{
                    	avexception.printStackTrace();
                    }
				 
				
			}
		});
		ALUserEngine.defauleEngine().updateUnreadState(muser, new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
                        Log.i("MyTag", avexception+"--------updateUnreadState-----------"+object);	
                        if(avexception != null)
                        	avexception.printStackTrace();
			}
		});

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.left_imbt:
			this.finish();
			break;
		case R.id.send_btn:
			sendComment();
			break;
		default:
			break;
		}
	}
   private String mmsg = "";
	private void sendComment() {
		String text = content_edittext.getText().toString();
		if (text.length() == 0) {
			showToast("请输入发送内容");
			return;
		}
		AVObject avobject = new AVObject();
		mmsg = text;
		avobject.add("content_text", "test string");
		Log.i("MyTag", "-----------------"+avobject.getString("content_text"));
		adpter.addItem(avobject);
		adpter.notifyDataSetChanged();
		createWiatDialog("在正发送");
		ALUserEngine.defauleEngine().postMessage(text, null, null, muser,
				new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						cancleWaitDialog();
						if (avexception == null) {
							showToast("发送成功");
							content_edittext.setText("");
						} else {
							avexception.printStackTrace();
							showToast("发送失败");
						}
					}
				});
	}

	class MyBaseAdpter extends BaseAdapter {
		private List<AVObject> list = null;
		private Context context;

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return list.size();
		}

		public MyBaseAdpter(Context context) {
			list = new ArrayList<AVObject>();
			this.context = context;
		}

		public void addItem(AVObject avobject) {
			list.add(avobject);
		}

		@Override
		public Object getItem(int position) {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}
    
		 public void setData(List<AVObject> list){
			 this.list = list;
		 }
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			AVObject avObject = list.get(position);

			AVUser fromavuser = avObject.getAVObject("fromUser");
			String fromuserid = null;
			if (fromavuser != null)
				fromuserid = fromavuser.getObjectId();
			AVObject contentavobject = avObject.getAVObject("content");
			String content = null;
			if (contentavobject != null) {
				content = contentavobject.getString("text");
			} else {
				content = mmsg;
			}
           String type =null;
           if(muser.getObjectId().equals(fromuserid)){
        	   type = "1";
           }else{
        	   type = "2";
           }
			
			String imag01url = muser.getString("smallHeadViewURL");
			String imag02url = curruser.getString("smallHeadViewURL");

			View view = LayoutInflater.from(context).inflate(
					R.layout.listview_chat_item, null);
			TextView textview01 = (TextView) view.findViewById(R.id.textview01);
			TextView textview02 = (TextView) view.findViewById(R.id.textview02);
			ImageButton image01 = (ImageButton) view.findViewById(R.id.image01);
			ImageButton image02 = (ImageButton) view.findViewById(R.id.image02);
			TextView tv;
			ImageButton imgbtn;
			String url;

			if ("1".equals(type)) {
				tv = textview01;
				imgbtn = image01;
				url = imag01url;
			} else {
				tv = textview02;
				imgbtn = image02;
				url = imag02url;

			}
			tv.setVisibility(View.VISIBLE);
			imgbtn.setVisibility(View.VISIBLE);
			tv.setText(content);
			aq.id(imgbtn).image(url, true, false, 0, 0,
					new BitmapAjaxCallback() {
						@Override
						protected void callback(String url, ImageView iv,
								Bitmap bm, AjaxStatus status) {
							super.callback(url, iv, bm, status);
							Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
									ChatActivity.this, bm, DensityUtil.dip2px(
											getApplicationContext(), 43), 5,
									"#ffffff");
							iv.setImageBitmap(mbitmap);
						}
					});
			return view;
		}

	}
}
