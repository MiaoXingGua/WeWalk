package com.huewu.pla.sample;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import me.maxwin.view.XListView;
import me.maxwin.view.XListView.IXListViewListener;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.basha.activity.CollectActivity;
import com.basha.activity.PicInfoActivity;
import com.basha.activity.R;
import com.basha.application.mapplication;
import com.basha.minterface.FragmentCallBack;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALPhotoEngine;
import com.basha.util.Util;
import com.dodowaterfall.widget.ScaleImageView;
import com.huewu.pla.lib.internal.PLA_AdapterView;
import com.huewu.pla.lib.internal.PLA_AdapterView.OnItemClickListener;

public class PullToRefreshSampleFragment extends Fragment implements
		IXListViewListener, OnClickListener {
	private XListView mAdapterView = null;
	private StaggeredAdapter mAdapter = null;
	private ImageButton leftbtn;
	private FragmentCallBack mCallback;
	private int type = 1; // 0.官方 1.最新街拍 2.最热街拍 3.附近街拍
	private float latitude = 0; // 查询经纬度信息
	private float longitude = 0; // 查询经纬度信息
	private Date lessThenDate = null; // 查询最后一条记录时间
	private Button newpic_btn;
	private Button nearby_btn;
	private Button hotpic_btn;
	private AQuery aq;
	private boolean loadflag = true;
	private GestureDetector mGesture;

	// /**
	// * 添加内容
	// *
	// * @param pageindex
	// * @param type
	// * 1为下拉刷新 2为加载更多
	// */
	// private void AddItemToContainer(int pageindex, int type) {
	// if (task.getStatus() != Status.RUNNING) {
	// String url = "http://www.duitang.com/album/1733789/masn/p/" + pageindex +
	// "/24/";
	// Log.d("MainActivity", "current url:" + url);
	// ContentTask task = new ContentTask(getActivity(), type);
	// task.execute(url);
	//
	// }
	// }
	private void loadImages(final int mType) {
		if (loadflag == false)
			return;
		loadflag = false;
		Log.i("MyTag", "---------loadimages--");
		ALPhotoEngine.defauleEngine().searchAllPhoto(type, 10, lessThenDate,
				latitude, longitude, new CallBack() {

					@Override
					public void done(Object object, AVException avexception) {
						Log.i("MyTag", avexception
								+ "-------------searchAllPhoto--------"
								+ object);
						loadflag = true;
						if (avexception != null) {
							avexception.printStackTrace();
							Toast.makeText(getActivity(), "请求数据失败",
									Toast.LENGTH_SHORT).show();
							return;
						}
						if (object != null) {
							List<AVObject> list = (List<AVObject>) object;
							if (list.size() == 0) {
								Toast.makeText(getActivity(), "没有更多了",
										Toast.LENGTH_SHORT).show();
							}

							Log.i("MyTag",
									avexception
											+ "-------------searchAllPhoto---list.size()-----"
											+ list.size());
							if (mType == 1) {
								mAdapter.addItemLast(list);
								mAdapter.notifyDataSetChanged();
								mAdapterView.stopRefresh();

							} else if (mType == 2) {
								mAdapterView.stopLoadMore();
								mAdapter.addItemLast(list);
								if (list.size() > 0) {
									AVObject avobject = list.get(list.size() - 1);
									lessThenDate = avobject.getCreatedAt();
								}
								mAdapter.notifyDataSetChanged();
							}

						} else {
							Toast.makeText(getActivity(), "请求数据失败",
									Toast.LENGTH_SHORT).show();
						}
					}
				});

	}

	public class StaggeredAdapter extends BaseAdapter {
		private Context mContext;
		private LinkedList<AVObject> mInfos;
		private XListView mListView;

		public StaggeredAdapter(Context context, XListView xListView) {
			mContext = context;
			mInfos = new LinkedList<AVObject>();
			mListView = xListView;
		}

		public void ClearData() {
			mInfos.clear();
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			ViewHolder holder;
			AVObject duitangInfo = mInfos.get(position);

			if (convertView == null) {
				LayoutInflater layoutInflator = LayoutInflater.from(parent
						.getContext());
				convertView = layoutInflator.inflate(R.layout.infos_list, null);
				holder = new ViewHolder();
				holder.imageView = (ScaleImageView) convertView
						.findViewById(R.id.news_pic);
				holder.contentView = (TextView) convertView
						.findViewById(R.id.news_content);
				holder.titleView = (TextView) convertView
						.findViewById(R.id.news_title);
				convertView.setTag(holder);
			}

			int width = duitangInfo.getInt("width");
			int height = duitangInfo.getInt("height");

			String text = duitangInfo.getAVObject("content") == null ? ""
					: duitangInfo.getAVObject("content").getString("text");
			String title = duitangInfo.getAVObject("user") == null ? ""
					: duitangInfo.getAVObject("user").getString("nickname");
			String imagur = duitangInfo.getString("thumbnailURL");
			int screenwidth = Util.getScreenWidht(getActivity());
			int mwidth = (int) ((screenwidth - 20) / 3.0);
			int mheight = (int) (mwidth * 0.1 / (width * 0.1) * height);
			holder = (ViewHolder) convertView.getTag();
			holder.imageView.setImageWidth(200);
			holder.imageView.setImageHeight(mheight);
			holder.contentView.setText(text);
			holder.titleView.setText(title);
			aq.id(holder.imageView).image(imagur, true, false, mwidth, 0);

			return convertView;
		}

		class ViewHolder {
			TextView titleView;
			ScaleImageView imageView;
			TextView contentView;
			TextView timeView;
		}

		@Override
		public int getCount() {
			return mInfos.size();
		}

		@Override
		public AVObject getItem(int arg0) {
			return mInfos.get(arg0);
		}

		@Override
		public long getItemId(int arg0) {
			return 0;
		}

		public void addItemLast(List<AVObject> datas) {
			mInfos.addAll(datas);
		}

		public void addItemTop(List<AVObject> datas) {
			for (AVObject info : datas) {
				mInfos.addFirst(info);
			}
		}
	}

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		mAdapterView = (XListView) getActivity().findViewById(R.id.list);
		mAdapterView.setPullLoadEnable(true);
		mAdapterView.setXListViewListener(this);
		mAdapter = new StaggeredAdapter(getActivity(), mAdapterView);
		aq = new AQuery(getActivity());
		initactionbar();

		mAdapterView.setAdapter(mAdapter);
		loadImages(2);
		setListern();
		newpic_btn = (Button) getActivity().findViewById(R.id.newpic_btn);
		nearby_btn = (Button) getActivity().findViewById(R.id.nearby_btn);
		hotpic_btn = (Button) getActivity().findViewById(R.id.hotpic_btn);
		newpic_btn.getBackground().setAlpha(60);
		nearby_btn.getBackground().setAlpha(180);
		hotpic_btn.getBackground().setAlpha(180);
		newpic_btn.setOnClickListener(this);
		nearby_btn.setOnClickListener(this);
		hotpic_btn.setOnClickListener(this);

//		mGesture = new GestureDetector(getActivity(), new GestureListener());
//		this.getView().setOnTouchListener(this);
	}

	private void setListern() {
		mAdapterView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(PLA_AdapterView<?> parent, View view,
					int position, long id) {
				AVObject avObject = mAdapter.getItem(position - 1);
				((mapplication) getActivity().getApplication())
						.setSchAvobject(avObject);
				Intent intent = new Intent(getActivity(), PicInfoActivity.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivity(intent);
			}
		});
	}

	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		return inflater.inflate(R.layout.act_pull_to_refresh_sample, null);
	}

	private void initactionbar() {
		leftbtn = (ImageButton) getActivity().findViewById(R.id.left_imbt);
		ImageButton Rightbtn = (ImageButton) getActivity().findViewById(
				R.id.right_imbt);
		ImageButton onebtn = (ImageButton) getActivity().findViewById(
				R.id.one_imbt);
		onebtn.setVisibility(View.GONE);
		Rightbtn.setVisibility(View.GONE);
		leftbtn.setImageResource(R.drawable.actionbar_back_pic);
		leftbtn.setOnClickListener(this);
		leftbtn.setPadding(0, 0, 20, 0);

	}

	@Override
	public void onRefresh() {
		lessThenDate = null;
		mAdapter.ClearData();
		mAdapter.notifyDataSetChanged();
		loadImages(1);

	}

	@Override
	public void onLoadMore() {
		loadImages(2);

	}

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
		case R.id.left_imbt:
			// this.finish();
			// getActivity().overridePendingTransition(R.anim.slide_right_in,
			// R.anim.slide_right_out);
			mCallback.callback("rightmenuFragment", null);
			break;
		case R.id.newpic_btn:
			type = 1;
			mAdapter.ClearData();
			mAdapter.notifyDataSetChanged();
			lessThenDate = null;
			loadImages(2);
			newpic_btn.setBackgroundResource(R.drawable.grey_crcle);
			hotpic_btn.setBackgroundResource(R.drawable.black_crcle);
			nearby_btn.setBackgroundResource(R.drawable.black_crcle);
			newpic_btn.getBackground().setAlpha(60);
			nearby_btn.getBackground().setAlpha(180);
			hotpic_btn.getBackground().setAlpha(180);
			break;
		case R.id.hotpic_btn:
			type = 2;
			mAdapter.ClearData();
			mAdapter.notifyDataSetChanged();
			lessThenDate = null;
			loadImages(2);
			newpic_btn.setBackgroundResource(R.drawable.black_crcle);
			hotpic_btn.setBackgroundResource(R.drawable.grey_crcle);
			nearby_btn.setBackgroundResource(R.drawable.black_crcle);
			newpic_btn.getBackground().setAlpha(60);
			nearby_btn.getBackground().setAlpha(180);
			hotpic_btn.getBackground().setAlpha(180);
			break;
		case R.id.nearby_btn:
			type = 3;
			mAdapter.ClearData();
			mAdapter.notifyDataSetChanged();

			lessThenDate = null;
			loadImages(2);
			newpic_btn.setBackgroundResource(R.drawable.black_crcle);
			hotpic_btn.setBackgroundResource(R.drawable.black_crcle);
			nearby_btn.setBackgroundResource(R.drawable.grey_crcle);
			newpic_btn.getBackground().setAlpha(60);
			nearby_btn.getBackground().setAlpha(180);
			hotpic_btn.getBackground().setAlpha(180);
			break;
		default:
			break;
		}
	}



}// end of class
