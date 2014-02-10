package com.bash.adpter;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import com.avos.avoscloud.AVObject;
import com.basha.activity.R;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class CallistviewAdpter extends BaseAdapter {
	private Context context;
	private List<AVObject> avobjectlist = null;

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return avobjectlist.size();
	}

	public CallistviewAdpter(Context context) {
		this.context = context;
		avobjectlist = new ArrayList<AVObject>();
	}

	@Override
	public AVObject getItem(int position) {
		if (avobjectlist != null)
			return avobjectlist.get(position);
		// TODO Auto-generated method stub
		return null;
	}

	public void setData(List<AVObject> data) {
		this.avobjectlist = data;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	public void removeItem(AVObject avobject) {
		if (avobjectlist != null)
			avobjectlist.remove(avobject);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		AVObject avobject = avobjectlist.get(position);
		String content = avobject.getAVObject("content").getString("text");
		int type = avobject.getInt("type");
		SimpleDateFormat simpleDateFormat2 = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		String date = simpleDateFormat2.format(avobject.getDate("date"));
		View view = LayoutInflater.from(this.context).inflate(
				R.layout.cal_lv_item, null);
		TextView tv = (TextView) view.findViewById(R.id.content_textview);
		tv.setText(date + "\n" + content);

		ImageView imageview01 = (ImageView) view.findViewById(R.id.imageview01);
		ImageView imageview02 = (ImageView) view.findViewById(R.id.imageview02);
		setTypeImage(type, null, imageview02);
		// view.setTag(avobject);
		// ((Activity)context).unregisterForContextMenu(view);
		// ((Activity)context).registerForContextMenu(view);
		return view;
	}

	private void setTypeImage(int type, ImageView imageview01,
			ImageView imageview02) {
		switch (type) {
		case 1:
			imageview02.setBackgroundResource(R.drawable.allschedule_tyep1_pic);
			break;
		case 2:
			imageview02.setBackgroundResource(R.drawable.allschedule_tyep2_pic);
			break;
		case 3:
			imageview02.setBackgroundResource(R.drawable.allschedule_tyep3_pic);
			break;
		case 4:
			imageview02.setBackgroundResource(R.drawable.allschedule_tyep4_pic);
			break;
		default:
			break;
		}
	}
}
