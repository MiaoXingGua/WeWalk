package com.basha.fragment;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.LogInCallback;
import com.avos.avoscloud.SignUpCallback;
import com.basha.activity.PerHeardNickNameActivity;
import com.basha.activity.R;
import com.basha.minterface.FragmentCallBack;

import android.app.Activity;
import android.app.ProgressDialog;
import android.support.v4.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class LeftMenuFragment_register extends Fragment implements
		OnClickListener {

	private LinearLayout layout_register; // 注册布局
	private LinearLayout layout_load; // 登录布局
	private Button btn_tips;// 底部切换页面按钮
	private TextView textview_tips; // 底部提示信息
	private Animation anim_botomein; // 底部进入动画
	private Animation anim_botomeout;// 顶部出去动画
	private Button btn_reg; // 注册按钮
	private Button btn_load;// 登录按钮
	private EditText username_edittext;
	private EditText password_edittext;
	private EditText reqpassword_edittext;
	private EditText loadusername_edittext;
	private EditText loadpassword_edittext;

	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		return inflater.inflate(R.layout.slidingmenu_left_register, null);
	}

	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		setView();
		getCurrentUser();
	}

	
	 @Override
	public void onResume() {
		 super.onResume();
           Log.i("MyTag", "----LeftMenuFragment_register onResume---------");
	 }
	/**
	 * 初始化控件
	 */
	private void setView() {
		layout_register = (LinearLayout) getView().findViewById(
				R.id.layout_register); // 注册布局
		layout_load = (LinearLayout) getView().findViewById(R.id.layout_load); // 登录布局
		btn_tips = (Button) getView().findViewById(R.id.btn_tips); // 底部切换页面按钮
		btn_tips.setOnClickListener(this);

		textview_tips = (TextView) getView().findViewById(R.id.textview_tips); // 底部提示信息

		anim_botomein = AnimationUtils.loadAnimation(getActivity(),
				R.anim.slide_botome_in); // 底部进入动画
		anim_botomeout = AnimationUtils.loadAnimation(getActivity(),
				R.anim.slide_botome_out);// 顶部出去动画

		btn_load = (Button) getView().findViewById(R.id.btn_load); // 登录按钮
		btn_reg = (Button) getView().findViewById(R.id.btn_register); // 注册按钮
		btn_load.setOnClickListener(this);
		btn_reg.setOnClickListener(this);

		username_edittext = (EditText) getView().findViewById(
				R.id.username_edittext);
		password_edittext = (EditText) getView().findViewById(
				R.id.password_edittext);
		reqpassword_edittext = (EditText) getView().findViewById(
				R.id.reqpassword_edittext);

		loadusername_edittext = (EditText) getView().findViewById(
				R.id.loadusername_edittext);
		loadpassword_edittext = (EditText) getView().findViewById(
				R.id.loadpassword_edittext);

	}

	FragmentCallBack mCallback;

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		try {
			mCallback = (FragmentCallBack) activity;
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_tips:
			// 如果为登录界面，切换到注册界面

			changeLoadState(layout_load.isShown());
			break;
		case R.id.btn_load:
			load();
			break;
		case R.id.btn_register:
			register();
			break;
		default:
			break;
		}
	}

	private void changeLoadState(boolean bool) {
		if (bool) {
			layout_load.setVisibility(View.GONE);
			layout_load.startAnimation(anim_botomeout);
			layout_register.setVisibility(View.VISIBLE);
			layout_register.startAnimation(anim_botomein);
			textview_tips.setText("已有账号？点击这里登录");
		} else {
			// 注册界面，切换到登陆界面
			layout_register.setVisibility(View.GONE);
			layout_load.setVisibility(View.VISIBLE);
			layout_load.startAnimation(anim_botomein);
			layout_register.startAnimation(anim_botomeout);
			textview_tips.setText("还没有账号？点击这里注册");
		}
	}

	private Handler mhandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 1:

				break;
			case 2:
				break;
			default:
				break;
			}
		};
	};
	private ProgressDialog progressDialog;

	private void createWiatDialog(String str) {
		progressDialog = new ProgressDialog(getActivity(), R.style.MyDialog);

		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		// progressDialog.setTitle("Loading...");
		progressDialog.setMessage(str);
		// progressDialog.setIcon(null);
		// progressDialog.setCancelable(false);
		progressDialog.show();

	}

	private void cancleWaitDialog() {
		if (progressDialog != null && progressDialog.isShowing())
			progressDialog.cancel();
	}

	private void getCurrentUser() {
		AVUser currentUser = AVUser.getCurrentUser();
		if (currentUser != null) {
			// 允许用户使用应用
			mCallback.callback("Leftmenufragement", null);
		} else {
			changeLoadState(true);
			// 缓存用户对象为空时， 可打开用户注册界面…
		}
	}

	private void register() {
		String username = username_edittext.getText().toString().trim();
		String password = password_edittext.getText().toString().trim();
		String reqpassword = reqpassword_edittext.getText().toString().trim();
		if (username.length() == 0) {
			Toast.makeText(getActivity(), "请输入用户名", Toast.LENGTH_SHORT).show();
			return;
		}
		if (password.length() == 0) {
			Toast.makeText(getActivity(), "请输入密码", Toast.LENGTH_SHORT).show();
			return;
		}
		if (reqpassword.length() == 0) {
			Toast.makeText(getActivity(), "请输入确认密码", Toast.LENGTH_SHORT).show();
			return;
		}
		if (!reqpassword.equals(password)) {
			Toast.makeText(getActivity(), "两次输入密码不一致，请重新输入", Toast.LENGTH_SHORT)
					.show();
			return;
		}

		createWiatDialog("注册中...请稍等");
		AVUser user = new AVUser();
		user.setUsername(username);
		user.setPassword(password);
		// user.setEmail("steve@company.com");
		//
		// // 其他属性可以像其他AVObject对象一样使用put方法添加
		// user.put("phone", "213-253-0000");

		user.signUpInBackground(new SignUpCallback() {
			public void done(AVException e) {
				cancleWaitDialog();
				if (e == null) {
					// success
					// mCallback.onLoad();
					Intent intent = new Intent(getActivity(),
							PerHeardNickNameActivity.class);
					intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
					startActivity(intent);
					Toast.makeText(getActivity(), "注册成功", Toast.LENGTH_SHORT)
							.show();
				} else {
					// failed
					e.printStackTrace();
					Toast.makeText(getActivity(), "对不起,注册失败",
							Toast.LENGTH_SHORT).show();
				}
			}
		});

	}

	private void load() {
		String username = loadusername_edittext.getText().toString().trim();
		String password = loadpassword_edittext.getText().toString().trim();
		if (username.length() == 0) {
			Toast.makeText(getActivity(), "请输入用户名", Toast.LENGTH_SHORT).show();
			return;
		}
		if (password.length() == 0) {
			Toast.makeText(getActivity(), "请输入密码", Toast.LENGTH_SHORT).show();
			return;
		}
		createWiatDialog("登录中...请稍等");
		AVUser.logInInBackground(username, password, new LogInCallback() {
			public void done(AVUser user, AVException e) {
				cancleWaitDialog();
				if (user != null) {
					// 登录成功
					mCallback.callback("Leftmenufragement", null);
					Toast.makeText(getActivity(), "登录成功", Toast.LENGTH_SHORT)
							.show();
				} else {
					// 登录失败
					e.printStackTrace();
					Toast.makeText(getActivity(), "对不起,登录失败,用户名或密码错误",
							Toast.LENGTH_SHORT).show();
				}
			}
		});

	}

}
