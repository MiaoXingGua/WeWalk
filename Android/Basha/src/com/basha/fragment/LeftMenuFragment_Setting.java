package com.basha.fragment;

import java.io.File;
import java.io.FileOutputStream;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxStatus;
import com.androidquery.callback.BitmapAjaxCallback;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUser;
import com.basha.activity.CollectActivity;
import com.basha.activity.FollowingActivity;
import com.basha.activity.MyFollowingActivity;
import com.basha.activity.PerInfoActivity;
import com.basha.activity.R;
import com.basha.activity.SettingsActivity;
import com.basha.activity.SharePhotoActivity;
import com.basha.activity.UnreadMessageActivity;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALUserEngine;
import com.basha.util.BitmapUtils;
import com.basha.util.DensityUtil;

public class LeftMenuFragment_Setting extends Fragment implements
		OnClickListener {

	private ImageButton imv_pic;
	private Button msg_btn;
	private Button setting_btn;
	private Button Following_btn;
	private ImageButton takephote;
	private AQuery aq;
	private TextView nickname_textview;
	private Button collect_btn;
	private TextView msgnum_textview;
	private Button myfollowing_btn;

	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		return inflater.inflate(R.layout.slidingmenu_left_settings, null);
	}

	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		setView();
		aq = new AQuery(getActivity());
		updateUserInterface();
	}

	
	
	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}
	private void setView() {
		imv_pic = (ImageButton) getView().findViewById(R.id.imv_pic);
		imv_pic.setOnClickListener(this);

		msg_btn = (Button) getView().findViewById(R.id.msg_btn);
		collect_btn = (Button) getView().findViewById(R.id.collect_btn);
		Following_btn = (Button) getView().findViewById(R.id.Following_btn);
		myfollowing_btn = (Button) getView().findViewById(R.id.myfollowing_btn);
		setting_btn = (Button) getView().findViewById(R.id.setting_btn);
		takephote = (ImageButton) getView().findViewById(R.id.takephote);
		nickname_textview = (TextView) getView().findViewById(
				R.id.nickname_textview);
		msgnum_textview = (TextView) getView().findViewById(
				R.id.msgnum_textview);
		msgnum_textview.setBackgroundDrawable(new BitmapDrawable(BitmapUtils.getCircleNumBitmap(getActivity(), DensityUtil.dip2px(getActivity(), 20), DensityUtil.dip2px(getActivity(), 20), "#05b9d9", true)));
		msg_btn.setOnClickListener(this);
		Following_btn.setOnClickListener(this);
		setting_btn.setOnClickListener(this);
		takephote.setOnClickListener(this);
		collect_btn.setOnClickListener(this);
		myfollowing_btn.setOnClickListener(this);
	}

	private void updateUserInterface() {
		AVUser currentUser = AVUser.getCurrentUser();
		String nickname = currentUser.getString("nickname");
		String headpicurl_small = currentUser.getString("smallHeadViewURL");

		aq.id(imv_pic).image(headpicurl_small, true, false, 0, 0,
				new BitmapAjaxCallback() {
					@Override
					protected void callback(String url, ImageView iv,
							Bitmap bm, AjaxStatus status) {
						super.callback(url, iv, bm, status);
						Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
								getActivity(),
								bm,
								(int) getResources().getDimension(
										R.dimen.loadpage_padingtop), 0,
								"#ffffff");
						iv.setImageBitmap(mbitmap);
					}
				});
		nickname_textview.setText(nickname);
//		new Handler().post(new Runnable() {
//			
//			@Override
//			public void run() {
//				ALUserEngine.defauleEngine().getAllUnreadMessageCount(new CallBack() {
//					
//					@Override
//					public void done(Object object, AVException avexception) {
//						Log.i("MyTag", avexception+"--------getAllUnreadMessageCount--------"+object);
//						if(avexception == null){
//							if(object == null)
//								return;
//							try {
//								int i = (Integer)object;
//		                          if(i>=0){
//		                        	  msgnum_textview.setVisibility(View.VISIBLE);
//		                        	  msgnum_textview.setText(i+"");
//		                          }
//								
//							} catch (Exception e) {
//		                               e.printStackTrace();
//							}
//						}else{
//							avexception.printStackTrace();
//						}
//					}
//				});
//			}
//		});
		/*ALUserEngine.defauleEngine().getAllUnreadMessageCount(new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				Log.i("MyTag", avexception+"--------getAllUnreadMessageCount--------"+object);
				if(avexception == null){
					if(object == null)
						return;
					try {
						int i = (Integer)object;
                          if(i>=0){
                        	  msgnum_textview.setVisibility(View.VISIBLE);
                        	  msgnum_textview.setText(i+"");
                          }
						
					} catch (Exception e) {
                               e.printStackTrace();
					}
				}else{
					avexception.printStackTrace();
				}
			}
		});
*/
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.imv_pic:
			((mapplication)getActivity().getApplication()).setSchAvobject(AVUser.getCurrentUser());
			Intent perinfointent = new Intent(getActivity(),
					PerInfoActivity.class);
			perinfointent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(perinfointent);
			getActivity().overridePendingTransition(R.anim.slide_right_in,
					R.anim.slide_right_out);
			break;
		case R.id.msg_btn:
			Intent msgintent = new Intent(getActivity(),
					UnreadMessageActivity.class);
			msgintent.putExtra("page", "message");
			msgintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(msgintent);
			getActivity().overridePendingTransition(R.anim.slide_right_in,
					R.anim.slide_right_out);
			break;
		case R.id.collect_btn:
			Intent collectintent = new Intent(getActivity(),
					CollectActivity.class);
			collectintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(collectintent);
			getActivity().overridePendingTransition(R.anim.slide_right_in,
					R.anim.slide_right_out);
			break;
		case R.id.Following_btn:
			Intent followintent = new Intent(getActivity(),
					FollowingActivity.class);
			followintent.putExtra("page", "follow");
			followintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(followintent);
			break;
		case R.id.myfollowing_btn:
			Intent myfollowintent = new Intent(getActivity(),
					MyFollowingActivity.class);
			myfollowintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(myfollowintent);
			break;
		case R.id.setting_btn:
			Intent settintent = new Intent(getActivity(),
					SettingsActivity.class);
			settintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(settintent);
			getActivity().overridePendingTransition(R.anim.slide_right_in,
					R.anim.slide_right_out);
			break;
		case R.id.takephote:
			// Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
//			Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
//			intent.addCategory(Intent.CATEGORY_OPENABLE);
//			intent.setType("image/*");
//			intent.putExtra("crop", "true");
//			intent.putExtra("aspectX", 1);
//			intent.putExtra("aspectY", 1);
//			intent.putExtra("outputX", 80);
//			intent.putExtra("outputY", 80);
//			intent.putExtra("return-data", true);
//
//			startActivityForResult(intent, 0);
//
//			startActivityForResult(intent, 1);
			showDialog();
			break;
		default:
			break;
		}
	}

	// 提示对话框方法
	private void showDialog() {
		 String[] items = new String[] { "选择本地图片", "拍照" };
		new AlertDialog.Builder(getActivity())
				.setTitle("图片")
				.setItems(items, new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						if (which == 0) {
							Intent intent = new Intent(Intent.ACTION_PICK, null);
							intent.setDataAndType(
									MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
									"image/*");

							startActivityForResult(intent, 1);

						} else {
							// 调用系统的拍照功能
							Intent intent = new Intent(
									MediaStore.ACTION_IMAGE_CAPTURE);
							startActivityForResult(intent, 2);
						}
					}
				}).setNegativeButton("取消", null).show();
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == Activity.RESULT_OK) {
			if(data == null){
				Toast.makeText(getActivity(), "获取图片失败", Toast.LENGTH_SHORT).show();
				return;
			}
			String picturepath = null;
			switch (requestCode) {
			case 1:
				Uri uri = data.getData();
				Log.i("MyTag", "--------onActivityResult--------uri"+uri);
				String[] filePathColumn = { MediaStore.Images.Media.DATA };
				Cursor cursor = getActivity().getContentResolver().query(uri, filePathColumn,
						null, null, null);
				cursor.moveToFirst();
				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				Log.i("MyTag", "--------onActivityResult--------uri"+columnIndex);

				picturepath = cursor.getString(columnIndex);
				Log.i("MyTag", "--------onActivityResult--------picturepath"+picturepath);

				cursor.close();
				Intent intentb = new Intent(getActivity(), SharePhotoActivity.class);
				intentb.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				intentb.putExtra("imagepath", picturepath);
				startActivity(intentb);
				
				break;
			case 2:
				Bundle bundle = data.getExtras();
				Bitmap bitmap = (Bitmap) bundle.get("data");
				File file = saveMyBitmap(System.currentTimeMillis()+".jpg", bitmap);
				Intent intent = new Intent(getActivity(), SharePhotoActivity.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				if(file == null)
					return;
				intent.putExtra("imagepath", file.getAbsolutePath());
				startActivity(intent);
				break;

			default:
				break;
			}
		
		}
	}

	
	public File saveMyBitmap(String bitName, Bitmap mBitmap) {
		
		
		
		if (!android.os.Environment.MEDIA_MOUNTED.equals(android.os.Environment
				.getExternalStorageState())) {
			 Toast.makeText(getActivity(), "没有检测到SDcard!" ,Toast.LENGTH_SHORT).show();
			return null;
		}
		File filedir = new File(android.os.Environment.getExternalStorageDirectory()+ "/basha/pic/");
		if(!filedir.exists())
		    filedir.mkdirs();
		File file = null;
		try {
			file = new File(android.os.Environment.getExternalStorageDirectory()
					+ "/basha/pic/" + bitName);
			if(file.exists()){
				file.delete();
			}
			filedir.createNewFile();
			FileOutputStream fOut = fOut = new FileOutputStream(file);
			mBitmap.compress(Bitmap.CompressFormat.JPEG, 70, fOut);
			fOut.flush();
			fOut.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return file;
	}
}
