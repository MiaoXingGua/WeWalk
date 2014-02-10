package com.basha.activity;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.androidquery.AQuery;
import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.FunctionCallback;
import com.avos.avoscloud.SaveCallback;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALUserEngine;
import com.basha.util.BitmapUtils;
import com.basha.util.DensityUtil;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Toast;

public class PerHeardNickNameActivity extends BaseAcitvity implements
		OnClickListener {
	private ImageButton heardpic_imbt;
	private EditText nickname_edittext;
	private Button ok_btn;
	private String piclocalpath = null;
	private static final int PHOTO_REQUEST_TAKEPHOTO = 1;// 拍照
	private static final int PHOTO_REQUEST_GALLERY = 2;// 从相册中选择
	private static final int PHOTO_REQUEST_CUT = 3;// 结果
	private static final int MESSAGE_UPLOAD_PERINFO = 1;// 结果
	File tempFile = new File(getPhotoFileName());
	private AQuery ap;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.perheardnickname);
		setView();

	}

	private void setView() {

		heardpic_imbt = (ImageButton) findViewById(R.id.heardpic_imbt);
		nickname_edittext = (EditText) findViewById(R.id.nickname_edittext);
		ok_btn = (Button) findViewById(R.id.ok_btn);
		ok_btn.setOnClickListener(this);
		heardpic_imbt.setOnClickListener(this);
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

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.ok_btn:
			uploadPerinfo();
			break;
		case R.id.heardpic_imbt:
			if (!android.os.Environment.MEDIA_MOUNTED
					.equals(android.os.Environment.getExternalStorageState())) {
				Toast.makeText(this, "没有检测到SDcard!", Toast.LENGTH_SHORT).show();
			} else {
				showDialog();

			}

			break;
		default:
			break;
		}

	}

	private void uploadPerinfo() {
		final String nickname = nickname_edittext.getText().toString();
		if (nickname.length() == 0) {
			Toast.makeText(this, "请填写昵称", Toast.LENGTH_SHORT).show();
			return;
		}

		if (piclocalpath == null) {
			Toast.makeText(this, "请选取头像", Toast.LENGTH_SHORT).show();
			return;
		}
		createWiatDialog("正在上传...");

		final AVUser currentUser = AVUser.getCurrentUser();

		new Thread(new Runnable() {

			@Override
			public void run() {
				if (currentUser != null) {
					// 允许用户使用应用
					try {
						AVFile file = AVFile.withAbsoluteLocalPath(
								currentUser.getUsername(), piclocalpath);
						ALUserEngine.defauleEngine().updateUserInfo(file, null,
								nickname, null, null, new CallBack() {

									@Override
									public void done(Object object,
											AVException avexception) {
										Message msg = null;
										if (avexception == null) {
											msg = mhandler.obtainMessage(
													MESSAGE_UPLOAD_PERINFO,
													"更新资料成功");
											PerHeardNickNameActivity.this.finish();
										} else {
											msg = mhandler.obtainMessage(
													MESSAGE_UPLOAD_PERINFO,
													"更新资料失败");
											avexception.printStackTrace();

										}
										mhandler.sendMessage(msg);
									}

								});
					} catch (Exception e) {
						Message msg = mhandler.obtainMessage(
								MESSAGE_UPLOAD_PERINFO,
								"更新资料失败");
						mhandler.sendMessage(msg);

						e.printStackTrace();
					}
				} else {
					// 缓存用户对象为空时， 可打开用户注册界面…
				}
			}
		}).start();
	}

	// 提示对话框方法
	private void showDialog() {
		new AlertDialog.Builder(this)
				.setTitle("头像设置")
				.setPositiveButton("拍照", new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						dialog.dismiss();
						// 调用系统的拍照功能
						Intent intent = new Intent(
								MediaStore.ACTION_IMAGE_CAPTURE);

						// // 指定调用相机拍照后照片的储存路径
						// intent.putExtra(MediaStore.EXTRA_OUTPUT,
						// Uri.fromFile(tempFile));
						startActivityForResult(intent, PHOTO_REQUEST_TAKEPHOTO);
					}
				})
				.setNegativeButton("相册", new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {
						// TODO Auto-generated method stub
						dialog.dismiss();
						Intent intent = new Intent(Intent.ACTION_PICK, null);
						intent.setDataAndType(
								MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
								"image/*");
						startActivityForResult(intent, PHOTO_REQUEST_GALLERY);
					}
				}).show();
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
				File taekphotofile = saveMyBitmap(System.currentTimeMillis()+".jpg", bitmap);
				startPhotoZoom(Uri.fromFile(taekphotofile), DensityUtil.dip2px(this, 100));
			}
			break;

		case PHOTO_REQUEST_GALLERY:
			if (data != null) {
				Uri uri = data.getData();
				String[] filePathColumn = { MediaStore.Images.Media.DATA };
				Cursor cursor = getContentResolver().query(uri, filePathColumn,
						null, null, null);
				cursor.moveToFirst();
				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				String picturePath = cursor.getString(columnIndex);
				cursor.close();
				tempFile = new File(picturePath);
				startPhotoZoom(data.getData(),  DensityUtil.dip2px(this, 100));
			}

			break;

		case PHOTO_REQUEST_CUT:
			if (data != null)
				setPicToView(data);
			break;
		}
		super.onActivityResult(requestCode, resultCode, data);

	}

	private void startPhotoZoom(Uri uri, int size) {
		Intent intent = new Intent("com.android.camera.action.CROP");
		intent.setDataAndType(uri, "image/*");
		// crop为true是设置在开启的intent中设置显示的view可以剪裁
		intent.putExtra("crop", "true");

		// aspectX aspectY 是宽高的比例
		intent.putExtra("aspectX", 1);
		intent.putExtra("aspectY", 1);

		// outputX,outputY 是剪裁图片的宽高
		intent.putExtra("outputX", size);
		intent.putExtra("outputY", size);
		intent.putExtra("return-data", true);

		startActivityForResult(intent, PHOTO_REQUEST_CUT);
	}

	// 将进行剪裁后的图片显示到UI界面上
	private void setPicToView(Intent picdata) {
		Bundle bundle = picdata.getExtras();
		if (bundle != null) {
			Bitmap photo = (Bitmap) bundle.get("data");
			// Bitmap photo = bundle.getParcelable("data");
			File fille = saveMyBitmap(System.currentTimeMillis()+".jpg", photo);
			piclocalpath = fille.getAbsolutePath();
			Bitmap mbitmap = BitmapUtils.getCircleStrokbitmap(getApplicationContext(), photo, DensityUtil.dip2px(this, 93), DensityUtil.dip2px(this, 3), "#7fb80e");
			heardpic_imbt.setImageBitmap(mbitmap);
		}
	}

	public File saveMyBitmap(String bitName, Bitmap mBitmap) {
		File f = null;
		try {
			f = new File(Environment.getExternalStorageDirectory()
					+ "/basha/pic/" + bitName);
			if(f.exists()){
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

	// 使用系统当前日期加以调整作为照片的名称
	private String getPhotoFileName() {
		if (!android.os.Environment.MEDIA_MOUNTED.equals(android.os.Environment
				.getExternalStorageState())) {
			// Toast.makeText(this, "没有检测到SDcard!" ,Toast.LENGTH_SHORT).show();
			return "";
		}

		File dirfile = new File(Environment.getExternalStorageDirectory()
				+ "/basha/pic/");
		if (!dirfile.exists()) {
			dirfile.mkdirs();
		}
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"'IMG'_yyyyMMdd_HHmmss");
		return dirfile.getAbsolutePath() + "/" + dateFormat.format(date)
				+ ".jpg";
	}
}
