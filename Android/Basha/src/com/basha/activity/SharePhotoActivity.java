package com.basha.activity;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.androidquery.AQuery;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVQuery;
import com.avos.avoscloud.FindCallback;
import com.avos.avoscloud.SaveCallback;
import com.basha.application.mapplication;
import com.basha.bean.Weather;
import com.basha.serveRequest.ALPhotoEngine;
import com.basha.util.DensityUtil;
import com.basha.util.Util;

import android.R.integer;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.ContextMenu;
import android.view.MenuItem;
import android.view.View;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.LinearLayout.LayoutParams;
import com.basha.serveRequest.ALEngineConfig.CallBack;

public class SharePhotoActivity extends BaseAcitvity implements OnClickListener {
	private LinearLayout pohotslayout;
	private ImageButton addimgbtn;
	private LayoutParams lap;
	private ImageButton leftbtn;
	private TextView title_textview;
	private TextView right_tv;
	private List<String> filepaths = new ArrayList<String>(); // 共享图片本地路径
	private EditText text_edittext;
	private AQuery aq;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.sharephoto);
		String imagepath = getIntent().getStringExtra("imagepath");
		aq = new AQuery(this);
		setView();
		initactionbar();
		addImage(imagepath);

	}

	private void setView() {
		pohotslayout = (LinearLayout) findViewById(R.id.pohotslayout);
		int screnwidht = Util.getScreenWidht(this);
		int mwidth = (screnwidht - DensityUtil.dip2px(this, 50)) / 3;
		addimgbtn = new ImageButton(this);
		addimgbtn.setId(1000);
		lap = new LayoutParams(mwidth, (int) (mwidth * 1.5));
		lap.leftMargin = DensityUtil.dip2px(this, 2);
		pohotslayout.addView(addimgbtn, lap);
		addimgbtn.setBackgroundResource(R.drawable.ic_launcher);
		addimgbtn.setOnClickListener(this);
		
		text_edittext = (EditText)findViewById(R.id.text_edittext);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == Activity.RESULT_OK) {
			if (data == null) {
				Toast.makeText(this, "获取图片失败", Toast.LENGTH_SHORT).show();
				return;
			}
			String picturepath = null;
			switch (requestCode) {
			case 1:
				Uri uri = data.getData();
				String[] filePathColumn = { MediaStore.Images.Media.DATA };
				Cursor cursor = this.getContentResolver().query(uri,
						filePathColumn, null, null, null);
				cursor.moveToFirst();
				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				picturepath = cursor.getString(columnIndex);
				cursor.close();
				addImage(picturepath);
				break;
			case 2:
				Bundle bundle = data.getExtras();
				Bitmap bitmap = (Bitmap) bundle.get("data");
				File file = saveMyBitmap(System.currentTimeMillis() + ".jpg",
						bitmap);
				bitmap.recycle();
				if (file == null) {
					Toast.makeText(getApplicationContext(), "获取图片失败",
							Toast.LENGTH_SHORT).show();
					return;
				}
				addImage(file.getAbsolutePath());
				break;

			default:
				break;
			}

		}
	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		title_textview = (TextView) findViewById(R.id.title_textview);
		right_tv = (TextView) findViewById(R.id.right_tv);
		right_tv.setVisibility(View.VISIBLE);
		title_textview.setVisibility(View.GONE);
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setOnClickListener(this);
		right_tv.setOnClickListener(this);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
		Rightbtn.setBackgroundColor(Color.TRANSPARENT);

	}

	private void addImage(Bitmap bitmap,String path) {
		if (bitmap == null)
			return;
		ImageButton mbt = new ImageButton(this);
//		mbt.setImageBitmap(bitmap);
		mbt.setPadding(5, 5, 5, 5);
		mbt.setBackgroundResource(R.drawable.sharepohote_imgbj);
		mbt.setScaleType(ScaleType.CENTER_CROP);
		aq.id(mbt).image(new File(path), Util.getScreenWidht(this)/3);
		filepaths.add(path);
		ImageButton[] views = new ImageButton[pohotslayout.getChildCount()];
		registerForContextMenu(mbt);
		mbt.setTag(path);
		for (int i = 0; i < pohotslayout.getChildCount(); i++) {
			views[i] = (ImageButton) pohotslayout.getChildAt(i);
		}
		pohotslayout.removeAllViews();
		pohotslayout.addView(mbt, lap);
		for (int i = 0; i < views.length; i++) {
			pohotslayout.addView(views[i], lap);
			if (i == 2){
				views[i].setVisibility(View.GONE);		
				return;
			}
		
		}
	}
	
	private View contextmenuview ;

	@Override
	public void onCreateContextMenu(ContextMenu menu, View v,
			ContextMenuInfo menuInfo) {
		menu.add(0, 1, 0, "删除");
		menu.add(0, 2, 0, "取消");
		contextmenuview = v;
	}

 	@Override
	public boolean onContextItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case 1:
			pohotslayout.removeView(contextmenuview);
			filepaths.remove(contextmenuview.getTag());
			if(pohotslayout.getChildCount()<= 3)
				addimgbtn.setVisibility(View.VISIBLE);
			break;
		case 2:

			break;
		default:
			break;
		}
		return super.onContextItemSelected(item);
	}

	private void addImage(String path) {
		if (path == null)
			return;
//		Bitmap bitmap = BitmapFactory.decodeFile(path);
		ImageButton mbt = new ImageButton(this);
//		mbt.setImageBitmap(bitmap);
		mbt.setPadding(5, 5, 5, 5);
		mbt.setBackgroundResource(R.drawable.sharepohote_imgbj);
		mbt.setScaleType(ScaleType.CENTER_CROP);
		aq.id(mbt).image(new File(path), Util.getScreenWidht(this)/3);

		filepaths.add(path);
		ImageButton[] views = new ImageButton[pohotslayout.getChildCount()];
		registerForContextMenu(mbt);
		mbt.setTag(path);
		for (int i = 0; i < pohotslayout.getChildCount(); i++) {
			views[i] = (ImageButton) pohotslayout.getChildAt(i);
		}
		pohotslayout.removeAllViews();
		pohotslayout.addView(mbt, lap);
		for (int i = 0; i < views.length; i++) {
			pohotslayout.addView(views[i], lap);
			if (i == 2){
				views[i].setVisibility(View.GONE);		
				return;
			}
		
		}
	}

	public File saveMyBitmap(String bitName, Bitmap mBitmap) {
		if (!android.os.Environment.MEDIA_MOUNTED.equals(android.os.Environment
				.getExternalStorageState())) {
			Toast.makeText(this, "没有检测到SDcard!", Toast.LENGTH_SHORT).show();
			return null;
		}
		File filedir = new File(
				android.os.Environment.getExternalStorageDirectory()
						+ "/basha/pic/");
		if (!filedir.exists())
			filedir.mkdirs();
		File file = null;
		try {
			file = new File(
					android.os.Environment.getExternalStorageDirectory()
							+ "/basha/pic/" + bitName);
			if (file.exists()) {
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

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case 1000:
			showDialog();
			break;
		case R.id.right_tv:
			uploadPicsText();
            break;
		case R.id.left_imbt:
			this.finish();
			break;
		default:
			break;
		}
	}

	// 提示对话框方法
	private void showDialog() {
		String[] items = new String[] { "选择本地图片", "拍照" };
		new AlertDialog.Builder(this).setTitle("图片")
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

	private void uploadPicsText() {
        		
		List<AVFile> avfilelist = new ArrayList<AVFile>();
		if(filepaths == null || filepaths.size() == 0){
			Toast.makeText(getApplicationContext(), "请选择图片再上传",
					Toast.LENGTH_SHORT).show();
			return;
		}
		String text = text_edittext.getText().toString();
		if(TextUtils.isEmpty(text))
			text = null;
		for (int i = 0; i < filepaths.size(); i++) {
			try {
				String name = System.currentTimeMillis() +  filepaths.get(i).substring(filepaths.get(i).lastIndexOf("."));
				AVFile file = AVFile.withAbsoluteLocalPath(name, filepaths.get(i));
				avfilelist.add(file);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		mapplication application = (mapplication) getApplication();
		String cityname = application.getNowDistrictnamename();
		List<Weather> weatherlist = application.getCityWeathers(cityname);
		if(weatherlist == null || weatherlist.size() == 0){
			Toast.makeText(getApplicationContext(), "没有获取到天气信息，无法上传图片",
					Toast.LENGTH_SHORT).show();
			return;
		}
		Weather  weat = weatherlist.get(0);
		float temp = Float.parseFloat(weat.getTemp());
		int weatcode = Integer.parseInt(weat.getCode());
		createWiatDialog("发布中...");
		ALPhotoEngine.defauleEngine().postPhoto(avfilelist, temp, weatcode,
				text, null, false, false, 2.1f, 2.1f, new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						cancleWaitDialog();
						if (avexception == null) {
							Message msgsucc = mhandler.obtainMessage(1, "分享成功");
                               mhandler.sendMessage(msgsucc);
							return;
						}
						Message msgfaile = mhandler.obtainMessage(3, "分享失败");
                        mhandler.sendMessage(msgfaile);
                        if(avexception!=null)
						avexception.printStackTrace();
					}
				});
	}

	private Handler mhandler = new Handler(){
		public void handleMessage(android.os.Message msg) {
		       switch (msg.what) {
			case 3:
				String text = (String) msg.obj;
				Toast.makeText(getApplicationContext(), text,
						Toast.LENGTH_SHORT).show();
				break;
			case 1: //success
				 filepaths.clear();
                 pohotslayout.removeAllViews();
                 text_edittext.setText("");
                 SharePhotoActivity.this.finish();
                 break;
			default:
				break;
			}	
		 	
		};
	};
}
