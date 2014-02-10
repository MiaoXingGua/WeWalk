package com.basha.activity;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import me.maxwin.view.XListView;
import me.maxwin.view.XListView.IXListViewListener;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxStatus;
import com.androidquery.callback.BitmapAjaxCallback;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALPhotoEngine;
import com.basha.util.BitmapUtils;
import com.basha.util.DensityUtil;
import com.basha.util.Util;
import com.huewu.pla.*;
import com.huewu.pla.lib.internal.PLA_AbsListView;

public class CopyOfPicInfoActivity extends BaseAcitvity implements
		View.OnClickListener {

	private ListView listview_permsg;
	private ImageButton leftbtn;
	private TextView title_textview;
	private ImageView heardpic_btn;
	private View top_layout;
	private AQuery aq;
	private mAdpter adpter;
	private ImageButton love_btn;
	private EditText content_edittext;
	private Button send_btn;
	private AVObject avobject = null; //当前图片对象
	private TextView comments_textview;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.picinfo);
		setView();
		initactionbar();
		aq = new AQuery(this);
		updateUserInterface();
	}

	private void setView() {
		listview_permsg = (ListView) findViewById(R.id.listview);
		top_layout = (View) LayoutInflater.from(this).inflate(
				R.layout.picinfo_toplayout, null);
		heardpic_btn = (ImageView) top_layout
				.findViewById(R.id.bigimg_imageview);
		int heght = (int) (Util.getScreenHeight(this) * 6 / 10);
		AbsListView.LayoutParams lap = new AbsListView.LayoutParams(
				PLA_AbsListView.LayoutParams.FILL_PARENT, heght);
		top_layout.setLayoutParams(lap);
		listview_permsg.addHeaderView(top_layout);
		adpter = new mAdpter();
		listview_permsg.setAdapter(adpter);

		love_btn = (ImageButton) top_layout.findViewById(R.id.love_imbtn);
		love_btn.setOnClickListener(this);
		
		content_edittext = (EditText)findViewById(R.id.content_edittext);
		send_btn = (Button)findViewById(R.id.send_btn);
		send_btn.setOnClickListener(this);


	}

	private void updateUserInterface() {
		 avobject  = ((mapplication) getApplication()).getSchAvobject();
		if (avobject.getAVUser("user") == null) {
			return;
		}
		String username = ((AVUser) avobject.getAVUser("user"))
				.getString("nickname");
		String userheadimagurl = ((AVUser) avobject.getAVUser("user"))
				.getString("smallHeadViewURL");
		String imageurl = avobject.getString("originalURL");
		String  piccontent = avobject.getAVObject("content").getString("text");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		String picdate = sdf.format(avobject.getCreatedAt());
		int hot = avobject.getInt("hot");

		ImageView heardiamgeview = (ImageView) top_layout
				.findViewById(R.id.userhead_imageview);
		TextView user_textview = (TextView) top_layout
				.findViewById(R.id.user_textview);
		TextView piccontent_textview = (TextView) top_layout
				.findViewById(R.id.piccontent_textview);
		TextView picdata_textview = (TextView) top_layout
				.findViewById(R.id.picdata_textview);
		TextView hot_textview = (TextView) top_layout
				.findViewById(R.id.hot_textview);
		comments_textview = (TextView) top_layout
				.findViewById(R.id.comments_textview);
		user_textview.setText(username);
		hot_textview.setText(hot + "");
		piccontent_textview.setText(piccontent);
		picdata_textview.setText(picdate);
		
		
        setImageListener(heardiamgeview, (AVUser) avobject.getAVUser("user"));
		aq.id(heardiamgeview).image(userheadimagurl, true, false, 0, R.drawable.empty_photo,
				new BitmapAjaxCallback() {
					@Override
					protected void callback(String url, ImageView iv,
							Bitmap bm, AjaxStatus status) {
						super.callback(url, iv, bm, status);
						Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
								CopyOfPicInfoActivity.this,
								bm,
								(int) getResources().getDimension(
										R.dimen.perinfo_toplayout_child2_h), DensityUtil.dip2px(getApplicationContext(), 3),
								"#ffffff");
						iv.setImageBitmap(mbitmap);
					}
				});
		aq.id(heardpic_btn).image(imageurl, true, false,Util.getScreenWidht(this),0,BitmapFactory.decodeResource(getResources(), R.drawable.empty_photo),0);
		ALPhotoEngine.defauleEngine().getCommentListFromPhoto(avobject, 0,
				null, new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						Log.i("MyTag", avexception
								+ "--------getCommentListFromPhoto---" + object);
						if (avexception != null) {
							avexception.printStackTrace();
							return;
						}
						if (object == null) {
							return;
						}
						List<AVObject> list = (List<AVObject>) object;
						adpter.addDate(list);
						adpter.notifyDataSetChanged();
						comments_textview.setText(list.size() + "");
					}
				});

		ALPhotoEngine.defauleEngine().getFaviconUserListFromPhoto(avobject,
				new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						Log.i("MyTag",
								avexception
										+ "---getFaviconUserListFromPhoto--获取照片的收藏者-----"
										+ object);
						if (avexception == null) {
							if (object != null) {
								// 判断图片用户是否收藏过
								List<AVUser> list = (List<AVUser>) object;
								AVUser curruser = AVUser.getCurrentUser();
								if (curruser == null)
									return;
								for (int i = 0; i < list.size(); i++) {
									if (curruser.getObjectId().equals(
											list.get(i).getObjectId())) {
										love_btn.setImageResource(R.drawable.red_love);
										love_btn.setTag("2");
										return;
									}
								}
								love_btn.setTag("1");
							}
							return;
						}
						avexception.printStackTrace();
					}
				});

	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		title_textview = (TextView) findViewById(R.id.title_textview);
		// title_textview.setText("Cherry Brown");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setOnClickListener(this);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
	}

	private void sendComment(){
		String text = content_edittext.getText().toString();
		if(text.length() == 0){
			showToast("请输入评论内容");
			return;
		}
		createWiatDialog("在正发送");
		if(AVUser.getCurrentUser() == null){
			showToast("您还没有登录，不能发表评论");
             return;			
		}

		ALPhotoEngine.defauleEngine().commentPhoto(avobject, text, null, new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				cancleWaitDialog();
				if(avexception == null){
					showToast("发送成功");
					content_edittext.setText("");
					ALPhotoEngine.defauleEngine().getCommentListFromPhoto(avobject, 0,
							null, new CallBack() {

								@Override
								public void done(Object object, AVException avexception) {
									Log.i("MyTag", avexception
											+ "--------getCommentListFromPhoto---" + object);
									if (avexception != null) {
										avexception.printStackTrace();
										return;
									}
									if (object == null) {
										return;
									}
									List<AVObject> list = (List<AVObject>) object;
									adpter.setData(list);
									adpter.notifyDataSetChanged();
									comments_textview.setText(list.size() + "");
								}
							});
				}else{
					avexception.printStackTrace();
				}
				
			}
		});
	}
	
	class mAdpter extends BaseAdapter {

		private List<AVObject> avobjectlist = new ArrayList<AVObject>();

		@Override
		public int getCount() {
			if (avobjectlist == null)
				return 0;
			return avobjectlist.size();
		}

		@Override
		public AVObject getItem(int arg0) {
			return avobjectlist.get(arg0);
		}

		@Override
		public long getItemId(int arg0) {
			// TODO Auto-generated method stub
			return 0;
		}

		public void addDate(List<AVObject> list) {
			this.avobjectlist.addAll(list);
		}
		
		public void setData(List<AVObject> list){
			this.avobjectlist = list;
		}

		@Override
		public View getView(int arg0, View arg1, ViewGroup arg2) {
			AVObject avobject = avobjectlist.get(arg0);
			String imagurl = avobject.getAVObject("user").getString(
					"smallHeadViewURL");
			String username = ((AVUser) avobject.getAVObject("user"))
					.getString("nickname");
			String text = avobject.getAVObject("content").getString("text");
			Date date = avobject.getCreatedAt();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");

			View view = LayoutInflater.from(CopyOfPicInfoActivity.this).inflate(
					R.layout.listview_picinfo_item, null);
			ImageView imageview = (ImageView) view
					.findViewById(R.id.bigimg_imageview);
			TextView name_textview = (TextView) view
					.findViewById(R.id.name_textview);
			TextView time_textview = (TextView) view
					.findViewById(R.id.time_textview);
			TextView content_textview = (TextView) view
					.findViewById(R.id.content_textview);
			aq.id(imageview).image(imagurl, true, false);
			aq.id(imageview).image(imagurl, true, false, 0, 0,
					new BitmapAjaxCallback() {
						@Override
						protected void callback(String url, ImageView iv,
								Bitmap bm, AjaxStatus status) {
							super.callback(url, iv, bm, status);
							Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
									CopyOfPicInfoActivity.this,
									bm,
									(int) getResources().getDimension(
											R.dimen.perinfo_toplayout_child2_h), DensityUtil.dip2px(getApplicationContext(), 3),
									"#ffffff");
							iv.setImageBitmap(mbitmap);
							
						}
					});
			name_textview.setText(username + ":");
			content_textview.setText(text);
			time_textview.setText(sdf.format(date));
			// ImageView piciv = (ImageView)
			// view.findViewById(R.id.imageview_pic);
			// piciv.setScaleType(ScaleType.CENTER_CROP);
			setImageListener(imageview,(AVUser)avobject.getAVObject("user"));
//			imageview.setTag((AVUser)avobject.getAVObject("user"));
			return view;
		}
		


	}

	private void setImageListener(ImageView imageview, final AVUser avuser){
		imageview.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				((mapplication)getApplication()).setSchAvobject(avuser);
				Intent perinfointent = new Intent(CopyOfPicInfoActivity.this,
						PerInfoActivity.class);
				perinfointent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivity(perinfointent);
			}
		});
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.left_imbt:
			this.finish();
			break;
		case R.id.love_imbtn:
			collectImage();
			break;
		case R.id.send_btn:
			sendComment();
		default:
			break;
		}
	}

	private void collectImage() {
		AVObject avobject = ((mapplication) getApplication()).getSchAvobject();
		String tag = (String) love_btn.getTag();
		if ("2".equals(tag)) {
			ALPhotoEngine.defauleEngine().unfaviconPhoto(avobject,
					new CallBack() {

						@Override
						public void done(Object object, AVException avexception) {
							if (avexception == null) {
								Toast.makeText(getApplicationContext(),
										"取消收藏成功", Toast.LENGTH_SHORT).show();
								love_btn.setTag("1");
								love_btn.setImageResource(R.drawable.left_slidem_setting_love);
							} else {
								Toast.makeText(getApplicationContext(),
										"取消收藏失败", Toast.LENGTH_SHORT).show();
								avexception.printStackTrace();
							}
						}
					});
		} else {
			ALPhotoEngine.defauleEngine().faviconPhoto(avobject,
					new CallBack() {

						@Override
						public void done(Object object, AVException avexception) {
							if (avexception == null) {
								Toast.makeText(getApplicationContext(),
										"收藏成功", Toast.LENGTH_SHORT).show();
								love_btn.setTag("2");
								love_btn.setImageResource(R.drawable.red_love);
							} else {
								Toast.makeText(getApplicationContext(),
										"收藏失败", Toast.LENGTH_SHORT).show();
								avexception.printStackTrace();
							}
						}
					});
		}
	}

}
