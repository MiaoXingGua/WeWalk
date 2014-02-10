package com.basha.activity;

import java.util.LinkedList;
import java.util.List;

import me.maxwin.view.XListView;
import me.maxwin.view.XListView.IXListViewListener;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.TextView;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.basha.application.mapplication;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALPhotoEngine;
import com.basha.util.Util;
import com.dodowaterfall.widget.ScaleImageView;
import com.example.android.bitmapfun.util.ImageFetcher;
import com.huewu.pla.lib.internal.PLA_AdapterView;
import com.huewu.pla.lib.internal.PLA_AdapterView.OnItemClickListener;

public class CollectActivity extends Activity implements IXListViewListener ,OnClickListener{

	 private ImageButton leftbtn;
	private XListView mAdapterView;
	private StaggeredAdapter mAdapter;
	private ImageFetcher mImageFetcher;
    private int currentPage = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
             setContentView(R.layout.collect);
             initactionbar();
             
             mAdapterView = (XListView)findViewById(R.id.list);
             mAdapterView.setPullLoadEnable(true);
             mAdapterView.setXListViewListener(this);
             mAdapter = new StaggeredAdapter(this, mAdapterView);

             mImageFetcher = new ImageFetcher(this, 240);
             mImageFetcher.setLoadingImage(R.drawable.empty_photo);
             initactionbar();
             
             mImageFetcher.setExitTasksEarly(false);
             mAdapterView.setAdapter(mAdapter);
             initView(currentPage, 2);
             setListern();
	 }
	
    private void initView(int pageindex, final int mType){
  	  ALPhotoEngine.defauleEngine().getMyFaviconPhotoList(new CallBack() {
				
				@Override
				public void done(Object object, AVException avexception) {
					Log.i("MyTag", avexception+"-------------searchAllPhoto--------"+object);
					if(avexception != null){
						avexception.printStackTrace();
                    return;
					}
					if(object != null){
						List<AVObject> list = (List<AVObject>) object;

			            if (mType == 1) {
			                mAdapter.addItemTop(list);
			                mAdapter.notifyDataSetChanged();
			                mAdapterView.stopRefresh();

			            } else if (mType == 2) {
			                mAdapterView.stopLoadMore();
			                mAdapter.addItemLast(list);
			                mAdapter.notifyDataSetChanged();
			            }

			        
					}else{
						
					}
				}
			});
  	  
  	  
  }
    private void setListern(){
    	mAdapterView.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(PLA_AdapterView<?> parent, View view,
					int position, long id) {
				AVObject avObject = mAdapter.getItem(position-1);
				((mapplication)getApplication()).setSchAvobject(avObject);
				Intent intent = new Intent(CollectActivity.this,PicInfoActivity.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivity(intent);
			}
		});
    }
	
		private void initactionbar() {
			leftbtn = (ImageButton) findViewById(R.id.left_imbt);
			ImageButton Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
			ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
			TextView title_textview = (TextView) findViewById(R.id.title_textview);
			 title_textview.setText("收藏");
			onebtn.setVisibility(View.GONE);
			Rightbtn.setVisibility(View.GONE);
			leftbtn.setOnClickListener(this);
			leftbtn.setImageResource(R.drawable.actionbar_btn_x);
		}
		@Override
		public void onClick(View v) {
 			 switch (v.getId()) {
			case R.id.left_imbt:
				this.finish();
				break;

			default:
				break;
			}
		}
	    @Override
	    public void onRefresh() {
	    	initView(++currentPage, 1);

	    }

	    @Override
	    public void onLoadMore() {
	    	initView(++currentPage, 2);

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

		        @Override
		        public View getView(int position, View convertView, ViewGroup parent) {

		            ViewHolder holder;
		            AVObject duitangInfo = mInfos.get(position);

		            if (convertView == null) {
		                LayoutInflater layoutInflator = LayoutInflater.from(parent.getContext());
		                convertView = layoutInflator.inflate(R.layout.infos_list, null);
		                holder = new ViewHolder();
		                holder.imageView = (ScaleImageView) convertView.findViewById(R.id.news_pic);
		                holder.contentView = (TextView) convertView.findViewById(R.id.news_content);
		                holder.titleView = (TextView) convertView.findViewById(R.id.news_title);
		                convertView.setTag(holder);
		            }
		            
		            int width =  duitangInfo.getInt("width");
		            int height =  duitangInfo.getInt("height");
		            String text = duitangInfo.getAVObject("content").getString("text");
		            String title = ((AVUser)duitangInfo.getAVObject("user")).getString("nickname");
		            String imagur = duitangInfo.getString("thumbnailURL");
		            int screenwidth = Util.getScreenWidht(CollectActivity.this);
		            int mwidth = (int) ((screenwidth)/3.0);

		            int mheight = (int) (mwidth*0.1/(width*0.1) * height);
		            holder = (ViewHolder) convertView.getTag();
		            holder.imageView.setImageWidth(200);
		            holder.imageView.setImageHeight(mheight);
		            holder.contentView.setText(text);
		            holder.titleView.setText(title);
		            mImageFetcher.loadImage(imagur, holder.imageView);
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
}
