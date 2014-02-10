package com.basha.activity;

import java.io.StringReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import com.avos.avoscloud.AVCloud;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVQuery;
import com.avos.avoscloud.FindCallback;
import com.avos.avoscloud.FunctionCallback;
import com.basha.application.mapplication;
import com.basha.bean.Weather;
import com.basha.serveRequest.ALUserEngine;
import com.basha.serveRequest.ALWeatherEngine;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.test.MyHandler;
import com.basha.view.DateTimePickDialogUtil;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RadioGroup;
import android.widget.Toast;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class AddScheduleActivity extends BaseAcitvity implements OnClickListener {
	private ImageButton edit_btn; // 编辑文本按钮
	private RelativeLayout schtime_layout;// 时间布局
	private RelativeLayout remind_layout;// 提醒布局
	private RelativeLayout place_layout;// 地点布局
	private EditText edittext;// 编辑文本框
	private TextView schdate_tv;
	private TextView reminddate_tv;
	private ImageButton leftbtn;
	private ImageButton Rightbtn;
	private TextView place_textview;// 地点显示
	private RadioGroup schecategory_rg;
    private boolean iseditschle = false;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.addschedule);
		setView();
		initactionbar();
		initData();
		initEditSchle();
	}
     
	private void initEditSchle(){
		String action = getIntent().getStringExtra("action");
		if("editschle".equals(action)){
			iseditschle = true;
		}else{
			return;
		}
		
		AVObject avObject = ((mapplication)getApplication()).getSchAvobject();
		String context = avObject.getAVObject("content").getString("text");
		int type = avObject.getInt("type");
		Date date = avObject.getDate("date");
		Date remindDate = avObject.getDate("remindDate");
		String place = avObject.getString("place");
		
		edittext.setText(context);
		switch (type) {
		case 1:
			schecategory_rg.check(R.id.rb1);
			break;
		case 2:
			schecategory_rg.check(R.id.rb2);
			break;
		case 3:
			schecategory_rg.check(R.id.rb3);
			break;
		case 4:
			schecategory_rg.check(R.id.rb4);
			break;
		default:
			break;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		schdate_tv.setText( sdf.format(date));
		reminddate_tv.setText( sdf.format(remindDate));
		place_textview.setText(place);
	}
	
	private void setView() {
		edit_btn = (ImageButton) findViewById(R.id.edit_btn); // 编辑文本按钮
		edittext = (EditText) findViewById(R.id.edittext); // 编辑文本框
		schtime_layout = (RelativeLayout) findViewById(R.id.schtime_layout); // 时间布局
		remind_layout = (RelativeLayout) findViewById(R.id.remind_layout); // 提醒布局
		place_layout = (RelativeLayout) findViewById(R.id.place_layout); // 地点布局
		schdate_tv = (TextView) findViewById(R.id.schdate_tv); // 时间
		reminddate_tv = (TextView) findViewById(R.id.reminddate_tv); // 提醒时间
		place_textview = (TextView) findViewById(R.id.place_textview); // 地点显示
		schecategory_rg = (RadioGroup) findViewById(R.id.schecategory_rg); // 事物类型选项

		edit_btn.setOnClickListener(this);
		schtime_layout.setOnClickListener(this);
		remind_layout.setOnClickListener(this);
		place_layout.setOnClickListener(this);

		schecategory_rg
				.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(RadioGroup group, int checkedId) {
						switch (checkedId) {
						case R.id.rb1:
							group.setTag(1);
							break;
						case R.id.rb2:
							group.setTag(2);
							break;
						case R.id.rb3:
							group.setTag(3);
							break;
						case R.id.rb4:
							group.setTag(4);
							break;
						default:
							break;
						}
					}
				});

	}

	private void initactionbar() {
		leftbtn = (ImageButton) findViewById(R.id.left_imbt);
		Rightbtn = (ImageButton) findViewById(R.id.right_imbt);
		ImageButton onebtn = (ImageButton) findViewById(R.id.one_imbt);
		onebtn.setVisibility(View.GONE);
		leftbtn.setImageResource(R.drawable.actionbar_btn_x);
		Rightbtn.setImageResource(R.drawable.actionbar_btn_y);
		leftbtn.setOnClickListener(this);
		Rightbtn.setOnClickListener(this);
		leftbtn.setPadding(0, 0, 20, 0);
	}

	private void initData() {
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		String dateTime = sdf.format(calendar.getTime());
		schdate_tv.setText(dateTime);
		reminddate_tv.setText(dateTime);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.edit_btn:
			if (edittext.isShown())
				edittext.setVisibility(View.GONE);
			else
				edittext.setVisibility(View.VISIBLE);
			break;
		case R.id.schtime_layout:
			DateTimePickDialogUtil dateTimePicKDialog = new DateTimePickDialogUtil(
					this, schdate_tv.getText().toString());
			dateTimePicKDialog.dateTimePicKDialog(schdate_tv);
			break;
		case R.id.remind_layout:
			DateTimePickDialogUtil dateTimePicKDialog2 = new DateTimePickDialogUtil(
					this, reminddate_tv.getText().toString());
			dateTimePicKDialog2.dateTimePicKDialog(reminddate_tv);
			break;
		case R.id.place_layout:
            Intent intent = new Intent(this,CitySelcetActivtiy.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivityForResult(intent, 1);
			break;
		case R.id.left_imbt:
			this.finish();
			break;
		case R.id.right_imbt:
			createSchedule();
			break;
		default:
			break;
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if(data != null){
			String cityname = data.getStringExtra("cityname");
			String districtname = data.getStringExtra("districtname");
			String text = data.getStringExtra("text");
			place_textview.setText(text);
			place_textview.setTag(districtname);
		}
	}

	/**
	 * 创建日程
	 */
	private void createSchedule() {

		try {
			SimpleDateFormat simpleDateFormat1 = new SimpleDateFormat(
					"yyyy/MM/dd HH:mm");
			SimpleDateFormat simpleDateFormat2 = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			final String textcontent = edittext.getText().toString();
			final int type = Integer.parseInt(schecategory_rg.getTag() + "");
			final Date date1 = simpleDateFormat1
					.parse(schdate_tv.getText().toString());
			final Date date2 = simpleDateFormat1
					.parse(reminddate_tv.getText().toString());
			final String palce = place_textview.getText().toString();
			if (textcontent.length() == 0) {
				Toast.makeText(getApplicationContext(), "请输入日程内容",
						Toast.LENGTH_SHORT).show();
				return;
			}

			if (TextUtils.isEmpty(palce)) {
				Toast.makeText(getApplicationContext(), "请选择城市",
						Toast.LENGTH_SHORT).show();
				return;
			}
             if(iseditschle){
            	 createWiatDialog("正在更新...请稍等");
            	 AVObject avObject = ((mapplication)getApplication()).getSchAvobject();
            	 ALUserEngine.defauleEngine().updateSchedule(avObject, date1, date2, type, "xiao", "北京", textcontent, "", null, new com.basha.serveRequest.ALEngineConfig.CallBack() {

						@Override
						public void done(Object object, AVException avexception) {
							cancleWaitDialog();
							if (avexception == null) {
								clearInput();
					       		Toast.makeText(getApplicationContext(), "更新成功", Toast.LENGTH_SHORT).show();
					       		AddScheduleActivity.this.finish();
							} else {
					       		Toast.makeText(getApplicationContext(), "更新失败", Toast.LENGTH_SHORT).show();
								avexception.printStackTrace();
							}
						}

					});
              }else{
            	  createWiatDialog("正在添加...请稍等");
            	  ALWeatherEngine.defauleEngine().getWoeid((String)place_textview.getTag(), new CallBack() {
           			
           			@Override
           			public void done(Object object, AVException avexception) {
           				Log.i("MyTag", avexception+"-------获取天气id-"+object);
                             if(avexception == null){
                          	   if(object != null){
                          		    List<Weather> weatherlist = parxml2list((String) object);
                          		    if(weatherlist == null || weatherlist.size() == 0){
        					       		Toast.makeText(getApplicationContext(), "添加日程失败", Toast.LENGTH_SHORT).show();
                          		    	cancleWaitDialog();
                          		    }else{
                          		    	ALUserEngine.defauleEngine().createSchedule(date1, date2, type,
                          		    			weatherlist.get(0).getWoeid(), palce, textcontent, "", null, new com.basha.serveRequest.ALEngineConfig.CallBack() {

                            						@Override
                            						public void done(Object object, AVException avexception) {
                            							cancleWaitDialog();
                            							if (avexception == null) {
                            								clearInput();
                            					       		Toast.makeText(getApplicationContext(), "添加日程成功", Toast.LENGTH_SHORT).show();
                            					       		AddScheduleActivity.this.finish();
                            							} else {
                            					       		Toast.makeText(getApplicationContext(), "添加日程失败", Toast.LENGTH_SHORT).show();
                            								avexception.printStackTrace();
                            							}
                            						}

                            					});
                          		    }
                          	   }
                          	   
                             }else{
                          	   avexception.printStackTrace();
                 		    	cancleWaitDialog();
					       		Toast.makeText(getApplicationContext(), "添加日程失败", Toast.LENGTH_SHORT).show();

                             }
           				
           				
           			}
           		});
              }
		

		} catch (ParseException e) {
			e.printStackTrace();
		}

	}
	private List<Weather> parxml2list(String xml){
		 //解析对象工厂-->reader对象 读取对象，处理xml
		 List<Weather> list = null;
	    try{
	      
	     SAXParserFactory sf=SAXParserFactory.newInstance();
	     SAXParser parse=sf.newSAXParser();
	     XMLReader reader=parse.getXMLReader();
	     MyHandler h = new MyHandler();
	     reader.setContentHandler(h);
	     reader.parse(new InputSource(new StringReader(xml)));
	      list = h.getWeathers();
	     Log.i("MyTag", "--list.size--"+list.size());
	     
	     }catch(Exception e){
	      e.printStackTrace();
	     }
	    return list;
	}
	/**
	 * 更新、添加成功，清除输入。
	 */
   private void clearInput(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		schdate_tv.setText( sdf.format(new Date()));
		reminddate_tv.setText( sdf.format(new Date()));
		place_textview.setText("");
		edittext.setText("");

   }
}
