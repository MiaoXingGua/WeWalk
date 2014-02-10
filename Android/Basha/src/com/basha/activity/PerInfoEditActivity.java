package com.basha.activity;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxStatus;
import com.androidquery.callback.BitmapAjaxCallback;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVUser;
import com.basha.serveRequest.ALUserEngine;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.util.BitmapUtils;
import com.basha.util.DensityUtil;
import com.basha.util.Util;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class PerInfoEditActivity extends BaseAcitvity implements
		OnClickListener {

	private ImageButton leftbtn;
	private ImageView head_imageview;
	private ImageView backimage_imageview;
	private EditText nickname_edittext;
	private AQuery aq;
	private static final int PHOTO_REQUEST_TAKEPHOTO = 1;// 拍照
	private static final int PHOTO_REQUEST_GALLERY = 2;// 从相册中选择
	private static final int PHOTO_REQUEST_CUT = 3;// 结果
	private static final int MESSAGE_UPLOAD_PERINFO = 1;// 结果

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.perinfoedit);
		initactionbar();
		setView();
		initView();
	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		TextView title_textview = (TextView) findViewById(R.id.title_textview);
		title_textview.setText("更新资料");
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setOnClickListener(this);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
	}

	private void initView() {
		AVUser currentUser = AVUser.getCurrentUser();
		String nickname = currentUser.getString("nickname");
		String headpicurl_small = currentUser.getString("smallHeadViewURL");
		String backgroundViewURL = currentUser.getString("backgroundViewURL");
		aq.id(head_imageview).image(headpicurl_small, true, false, 0, 0,
				new BitmapAjaxCallback() {
					@Override
					protected void callback(String url, ImageView iv,
							Bitmap bm, AjaxStatus status) {
						super.callback(url, iv, bm, status);
						Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
								getApplicationContext(),
								bm,
								DensityUtil.dip2px(getApplicationContext(), 40),
								5, "#7fb80e");
						iv.setImageBitmap(mbitmap);
					}
				});

		aq.id(backimage_imageview).image(backgroundViewURL, true, false);
		nickname_edittext.setText(nickname);

	}

	private void setView() {
		LinearLayout layout1 = (LinearLayout) findViewById(R.id.layout1);
		LinearLayout layout2 = (LinearLayout) findViewById(R.id.layout2);
		LinearLayout layout3 = (LinearLayout) findViewById(R.id.layout3);
		head_imageview = (ImageView) findViewById(R.id.head_imageview);
		backimage_imageview = (ImageView) findViewById(R.id.backimage_imageview);
		nickname_edittext = (EditText) findViewById(R.id.nickname_edittext);

		layout1.setOnClickListener(this);
		layout2.setOnClickListener(this);
		layout3.setOnClickListener(this);

		aq = new AQuery(this);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.left_imbt:
			this.finish();
			break;
		case R.id.layout1:
			isheard = true;
			showDialog();
			break;
		case R.id.layout2:
			if (nickname_edittext.isEnabled())
				nickname_edittext.setEnabled(false);
			else
				nickname_edittext.setEnabled(true);
			break;
		case R.id.layout3:
			isheard = false;
			showDialog();
			break;
		default:
			break;
		}
	}

	private Handler mhandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case MESSAGE_UPLOAD_PERINFO:
				cancleWaitDialog();
				String str = (String) msg.obj;
				Toast.makeText(getApplicationContext(), str, Toast.LENGTH_SHORT)
						.show();
				break;

			default:
				break;
			}
		}
	};

	private void uploadPerinfo() {
		final String nickname = nickname_edittext.getText().toString();
		if (nickname.length() == 0) {
			Toast.makeText(this, "请填写昵称", Toast.LENGTH_SHORT).show();
			return;
		}

		createWiatDialog("更新信息");
		AVFile heardfile = null;
		AVFile backgroundfile = null;
		try {
			if (heardimagepath != null) {
				heardfile.withAbsoluteLocalPath(
						System.currentTimeMillis()
								+ heardimagepath.substring(heardimagepath
										.lastIndexOf(".")), heardimagepath);
			}
			if (backgroudimagepath != null) {
				heardfile.withAbsoluteLocalPath(
						System.currentTimeMillis()
								+ backgroudimagepath
										.substring(backgroudimagepath
												.lastIndexOf(".")),
						backgroudimagepath);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		ALUserEngine.defauleEngine().updateUserInfo(heardfile, backgroundfile,
				nickname, null, null, new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						cancleWaitDialog();
						Message msg = null;
						if (avexception == null) {
							msg = mhandler.obtainMessage(
									MESSAGE_UPLOAD_PERINFO, "更新资料成功");
							PerInfoEditActivity.this.finish();
						} else {
							msg = mhandler.obtainMessage(
									MESSAGE_UPLOAD_PERINFO, "更新资料失败");
							avexception.printStackTrace();

						}
						mhandler.sendMessage(msg);
					}

				});
	}

	private boolean isheard = true;

	private String heardimagepath = null;
	private String backgroudimagepath = null;

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

							startActivityForResult(intent,
									PHOTO_REQUEST_GALLERY);

						} else {
							// 调用系统的拍照功能
							Intent intent = new Intent(
									MediaStore.ACTION_IMAGE_CAPTURE);
							startActivityForResult(intent,
									PHOTO_REQUEST_TAKEPHOTO);
						}
					}
				}).setNegativeButton("取消", null).show();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub

		switch (requestCode) {
		case PHOTO_REQUEST_TAKEPHOTO:
			if (data != null) {
				Bundle bundle = data.getExtras();
				// 拍照取消
				if (bundle == null)
					return;
				Bitmap bitmap = (Bitmap) bundle.get("data");
				File taekphotofile = saveMyBitmap(System.currentTimeMillis()
						+ ".jpg", bitmap);
				startPhotoZoom(Uri.fromFile(taekphotofile));
			}
			break;

		case PHOTO_REQUEST_GALLERY:
			Log.i("MyTag", "------选择图片data---"+data);
			if (data != null) {
				Uri uri = data.getData();
				String[] filePathColumn = { MediaStore.Images.Media.DATA };
				Cursor cursor = getContentResolver().query(uri, filePathColumn,
						null, null, null);
				cursor.moveToFirst();
				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				String picturePath = cursor.getString(columnIndex);
				cursor.close();
				Log.i("MyTag", "------选择图片data--picturePath-"+picturePath);

				startPhotoZoom(data.getData());
			}

			break;

		case PHOTO_REQUEST_CUT:
			if (data != null)
				setPicToView(data);
			break;
		}
		super.onActivityResult(requestCode, resultCode, data);

	}

	private void startPhotoZoom(Uri uri) {
		Intent intent = new Intent("com.android.camera.action.CROP");
		intent.setDataAndType(uri, "image/*");
		// crop为true是设置在开启的intent中设置显示的view可以剪裁
		intent.putExtra("crop", "true");

		// aspectX aspectY 是宽高的比例
		intent.putExtra("aspectX", 1);
		intent.putExtra("aspectY", 1);

		// outputX,outputY 是剪裁图片的宽高
		int width = 0, height = 0;
		if (isheard) {
			width = DensityUtil.dip2px(this, 100);
			height = DensityUtil.dip2px(this, 100);
		} else {
			/*width = Util.getScreenWidht(this);
			height = (int) getResources().getDimension(
					R.dimen.perinfo_toplayout_h);
			width = height;*/
			
			width = DensityUtil.dip2px(this, 100);
			height = DensityUtil.dip2px(this, 100);
		}
		intent.putExtra("outputX", width);
		intent.putExtra("outputY", height);
		intent.putExtra("return-data", true);

		startActivityForResult(intent, PHOTO_REQUEST_CUT);
	}

	// 将进行剪裁后的图片显示到UI界面上
	private void setPicToView(Intent picdata) {
		Bundle bundle = picdata.getExtras();
		if (bundle != null) {
			Bitmap photo = (Bitmap) bundle.get("data");
			// Bitmap photo = bundle.getParcelable("data");
			File fille = saveMyBitmap(System.currentTimeMillis() + ".jpg",
					photo);
			if (isheard) {
				heardimagepath = fille.getAbsolutePath();
				Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(
						getApplicationContext(), photo,
						DensityUtil.dip2px(this, 40),
						DensityUtil.dip2px(this, 3), "#7fb80e");
				head_imageview.setImageBitmap(mbitmap);
			} else {
				backgroudimagepath = fille.getAbsolutePath();
				backimage_imageview.setImageBitmap(photo);
			}
		}
	}

	public File saveMyBitmap(String bitName, Bitmap mBitmap) {
		if (!android.os.Environment.MEDIA_MOUNTED.equals(android.os.Environment
				.getExternalStorageState())) {
			Toast.makeText(this, "没有检测到SDcard!", Toast.LENGTH_SHORT).show();
			return null;
		}
		File dirfile = new File(Environment.getExternalStorageDirectory()
				+ "/basha/pic/");
		if (!dirfile.exists()) {
			dirfile.mkdirs();
		}

		File f = null;
		try {
			f = new File(Environment.getExternalStorageDirectory()
					+ "/basha/pic/" + bitName);
			if (f.exists()) {
				f.delete();
			}
			f.createNewFile();
			FileOutputStream fOut = fOut = new FileOutputStream(f);
			mBitmap.compress(Bitmap.CompressFormat.PNG, 100, fOut);
			fOut.flush();
			fOut.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return f;
	}

}
