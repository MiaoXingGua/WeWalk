package com.basha.activity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.widget.Toast;

public class BaseAcitvity  extends Activity{

	
	private ProgressDialog progressDialog;

	public void createWiatDialog(String str) {
		progressDialog = new ProgressDialog(this, R.style.MyDialog);

		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		// progressDialog.setTitle("Loading...");
		progressDialog.setMessage(str);
		// progressDialog.setIcon(null);
		// progressDialog.setCancelable(false);
		progressDialog.show();

	}

	public void cancleWaitDialog() {
		if (progressDialog != null && progressDialog.isShowing())
			progressDialog.cancel();
	}
	
	public void showToast(String msgstr){
		Toast.makeText(getApplicationContext(), msgstr, Toast.LENGTH_SHORT).show();
	}
}
