package com.basha.activity;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxStatus;
import com.androidquery.callback.BitmapAjaxCallback;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.basha.activity.R.layout;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALPhotoEngine;
import com.basha.serveRequest.ALUserEngine;
import com.basha.util.BitmapUtils;
import com.basha.util.DensityUtil;
import com.dodowaterfall.widget.ScaleImageView;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.provider.ContactsContract.Data;
import android.util.DisplayMetrics;
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
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ListView;

public class PerInfoActivity extends BaseAcitvity implements OnClickListener {

	private ListView listview_permsg;
	private ImageButton leftbtn;
	private TextView title_textview;
	private ImageButton heardpic_btn;
	private Bitmap heardbitmap;
	private View top_layout;
	private AQuery aq;
	private mAdpter adpter;
	private Button sendmsg_btn;
	private Button follow_btn;
	private AVUser muser; // 页面用户

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.perinfo);
		setView();
		initactionbar();
		aq = new AQuery(this);
		updateUserInterface();
	}

	private void setView() {
		listview_permsg = (ListView) findViewById(R.id.listview_permsg);
		top_layout = (View) LayoutInflater.from(this).inflate(
				R.layout.perinfo_toplayout, null);
		sendmsg_btn = (Button) top_layout.findViewById(R.id.sendmsg_btn); // 私信
		follow_btn = (Button) top_layout.findViewById(R.id.follow_btn); // 关注
		heardpic_btn = (ImageButton) top_layout.findViewById(R.id.heardpic_btn);
		listview_permsg.addHeaderView(top_layout);
		heardbitmap = (Bitmap) BitmapFactory.decodeResource(getResources(),
				R.drawable.perinfo_follow_pic);
		adpter = new mAdpter();
		listview_permsg.setAdapter(adpter);
		listview_permsg.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {/*
				AVObject avobject = adpter.getItem(arg2 - 1);
				((mapplication) getApplication()).setSchAvobject(avobject);
				Intent intent = new Intent(PerInfoActivity.this,
						PicInfoActivity.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivity(intent);

			*/}
		});
		heardpic_btn.setOnClickListener(this);
		follow_btn.setOnClickListener(this);
		sendmsg_btn.setOnClickListener(this);
	}

	private void updateUserInterface() {
		AVUser currentUser = AVUser.getCurrentUser();
		if (currentUser == null)
			showToast("您还没登陆");
		muser = (AVUser) ((mapplication) getApplication()).getSchAvobject();
		if (muser == null)
			return;
		if (muser.getObjectId().equals(currentUser.getObjectId())) {
			sendmsg_btn.setVisibility(View.GONE);
			follow_btn.setVisibility(View.GONE);
		} else {
			heardpic_btn.setEnabled(false);
		}

		String nickname = muser.getString("nickname");
		String headpicurl_small = muser.getString("smallHeadViewURL");

		aq.id(heardpic_btn).image(headpicurl_small, true, false, 0, 0,
				new BitmapAjaxCallback() {
					@Override
					protected void callback(String url, ImageView iv,
							Bitmap bm, AjaxStatus status) {
						super.callback(url, iv, bm, status);
						Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
								PerInfoActivity.this,
								bm,
								(int) getResources().getDimension(
										R.dimen.perinfo_toplayout_child2_h),
								DensityUtil.dip2px(getApplicationContext(),
										2.5f), "#ffffff");
						iv.setImageBitmap(mbitmap);
					}
				});
		title_textview.setText(nickname);

		ALPhotoEngine.defauleEngine().getPhotosForUser(muser, 0, null,
				new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						if (avexception == null) {
							if(object == null)
								return;
							List<AVObject> list = (List<AVObject>) object;
							if(list == null || list.size() == 0)
								return;
							List<List<AVObject>>  listdata = new ArrayList<List<AVObject>>();
							List<AVObject> avobjects = new ArrayList<AVObject>();
							Date tempdata = list.get(0).getCreatedAt();
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
							for (int i = 0; i < list.size(); i++) {
								AVObject avobject = list.get(i);
								if(sdf.format(tempdata).equals(sdf.format(avobject.getCreatedAt()))){
									avobjects.add(avobject);
								}else{
									listdata.add(avobjects);
									tempdata = avobject.getCreatedAt();
									avobjects = new ArrayList<AVObject>();
									avobjects.add(avobject);
								}
								
							}
							listdata.add(avobjects);
							Log.i("MyTag",
									"-----getPhotosForUser---" + list.size());
							adpter.addDate(listdata);
							adpter.notifyDataSetChanged();
						} else {
							avexception.printStackTrace();
						}

					}
				});
		ALUserEngine.defauleEngine().myFriends(new CallBack() {

			@Override
			public void done(Object object, AVException avexception) {
				cancleWaitDialog();

				if (avexception == null) {
					if (object != null) {
						List<AVObject> results = (List<AVObject>) object;
						if (results == null || results.size() == 0) {
							// showToast("没有关注的好友");
							return;
						}
						for (int i = 0; i < results.size(); i++) {
							AVObject avobject = results.get(i);
							if (avobject.getObjectId().equals(
									muser.getObjectId())) {
								follow_btn.setText("取消关注");
							}
						}
					}
				} else {
					avexception.printStackTrace();
				}
			}
		});

	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("Cherry Brown");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setOnClickListener(this);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
	}

	class mAdpter extends BaseAdapter {

		private List<List<AVObject>> avobjectlist = new ArrayList<List<AVObject>>();

		@Override
		public int getCount() {
			if (avobjectlist == null)
				return 0;
			// TODO Auto-generated method stub
			return avobjectlist.size();
		}

		@Override
		public List<AVObject> getItem(int arg0) {
			return avobjectlist.get(arg0);
		}

		@Override
		public long getItemId(int arg0) {
			// TODO Auto-generated method stub
			return 0;
		}

		public void addDate(List<List<AVObject>> list) {
			this.avobjectlist.addAll(list);
		}

		@Override
		public View getView(int arg0, View convertView, ViewGroup arg2) {
			ViewHolder holder;

			List<AVObject> avobjects = avobjectlist.get(arg0);
			if(avobjects.size() == 0)
				return new TextView(getApplicationContext());
			Date date = avobjects.get(0).getCreatedAt();
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			int day = cal.get(Calendar.DAY_OF_MONTH);
			int month = cal.get(Calendar.MONTH) + 1;
			int dayofweek = cal.get(Calendar.DAY_OF_WEEK);


			DisplayMetrics dm = new DisplayMetrics();
			getWindowManager().getDefaultDisplay().getMetrics(dm);
			int scrwidth = dm.widthPixels;

			if (convertView == null) {
				holder = new ViewHolder();
				convertView = LayoutInflater.from(PerInfoActivity.this)
						.inflate(R.layout.listview_permsg_item, null);
				// holder.imageview = (ImageView) convertView
				// .findViewById(R.id.imageview_pic);
				// holder.imageview.setScaleType(ScaleType.CENTER_CROP);
				// LayoutParams lap = new LayoutParams(scrwidth * 3 / 4 - 10,
				// scrwidth * 3 / 4 - 10);
				// holder.imageview.setLayoutParams(lap);

				int mwidth = (int) ((scrwidth - DensityUtil.dip2px(
						getApplicationContext(), 33) * 2.5) / 3.5);
				android.widget.TableRow.LayoutParams lap = new android.widget.TableRow.LayoutParams(
						mwidth, mwidth);
				android.widget.TableLayout.LayoutParams tablelayoutparmas = new android.widget.TableLayout.LayoutParams(
						DensityUtil.dip2px(getApplicationContext(), 2),
						DensityUtil.dip2px(getApplicationContext(), 2));
				holder.imagelayout = (TableLayout) convertView
						.findViewById(R.id.image_layout);
				for (int i = 0; i < (avobjects.size()+2)/3; i++) {
					TableRow tr = new TableRow(PerInfoActivity.this);
					for (int j = i*3; j < i*3+3  && j <avobjects.size(); j++) {
						ImageView iv = new ImageView(PerInfoActivity.this);
						iv.setScaleType(ScaleType.CENTER_CROP);
						iv.setImageResource(R.drawable.ic_launcher);
						lap.rightMargin = DensityUtil.dip2px(
								getApplicationContext(), 2);
						tr.addView(iv, lap);
						String imageurl = avobjects.get(i).getString("originalURL");
						aq.id(iv).image(imageurl, true, false, mwidth, 0);
					}
					holder.imagelayout.addView(tr, tablelayoutparmas);
				}

				holder.dayofmoth_textview = (TextView) convertView
						.findViewById(R.id.dayofmoth_textview); // 天数
				holder.dayofweek_textview = (TextView) convertView
						.findViewById(R.id.dayofweek_textview); // 星期数
				holder.moth_textview = (TextView) convertView
						.findViewById(R.id.moth_textview); // 月数
				convertView.setTag(holder);
			}

			holder = (ViewHolder) convertView.getTag();
			// aq.id(holder.imageview).image(imageurl, true, false);
//			aq.id(holder.imageview).image(
//					imageurl,
//					true,
//					false,
//					0,
//					0,
//					BitmapFactory.decodeResource(getResources(),
//							R.drawable.empty_photo), 0);
			holder.dayofmoth_textview.setText("" + day);
			holder.moth_textview.setText(month + "月");
			setWeek(holder.dayofweek_textview, dayofweek);
			return convertView;
		}

		class ViewHolder {
			TextView dayofmoth_textview; // 天数
			TextView dayofweek_textview;// 星期数
			TextView moth_textview;// 月数
			ImageView imageview; // 图片
			TableLayout imagelayout; // 放image布局
		}

		private void setWeek(TextView tv, int day) {
			switch (day) {
			case 1:
				tv.setText("星期日");
				break;
			case 2:
				tv.setText("星期一");

				break;
			case 3:
				tv.setText("星期二");

				break;
			case 4:
				tv.setText("星期三");

				break;
			case 5:
				tv.setText("星期四");

				break;
			case 6:
				tv.setText("星期五");

				break;
			case 7:
				tv.setText("星期六");
				break;
			default:
				break;
			}
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.left_imbt:
			this.finish();
			break;
		case R.id.heardpic_btn:
			Intent editinfointent = new Intent(this, PerInfoEditActivity.class);
			editinfointent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(editinfointent);
			break;
		case R.id.follow_btn:
			addFriend();
			break;
		case R.id.sendmsg_btn:
			((mapplication) getApplication()).setSchAvobject(muser);
			Intent chatintent = new Intent(this, ChatActivity.class);
			chatintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(chatintent);
			break;
		default:
			break;
		}
	}

	private void addFriend() {
		if ("取消关注".equals(follow_btn.getText())) {
			createWiatDialog("取消关注");
			ALUserEngine.defauleEngine().removeFriend(muser, new CallBack() {

				@Override
				public void done(Object object, AVException avexception) {
					cancleWaitDialog();
					if (avexception == null) {
						Toast.makeText(getApplicationContext(), "取消关注成功",
								Toast.LENGTH_SHORT).show();
						follow_btn.setText("+关注");
					} else {
						Toast.makeText(getApplicationContext(), "取消关注失败",
								Toast.LENGTH_SHORT).show();
						avexception.printStackTrace();
					}
				}
			});
		} else {
			createWiatDialog("添加关注");
			ALUserEngine.defauleEngine().addFriend(muser, new CallBack() {

				@Override
				public void done(Object object, AVException avexception) {
					cancleWaitDialog();
					if (avexception == null) {
						Toast.makeText(getApplicationContext(), "添加关注成功",
								Toast.LENGTH_SHORT).show();
						follow_btn.setText("取消关注");
					} else {
						Toast.makeText(getApplicationContext(), "添加关注失败",
								Toast.LENGTH_SHORT).show();
						avexception.printStackTrace();
					}
				}
			});
		}

	}
}
