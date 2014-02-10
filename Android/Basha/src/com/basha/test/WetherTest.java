package com.basha.test;

import java.io.StringReader;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import android.app.Activity;
import android.os.Bundle;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.avos.avoscloud.AVException;
import com.basha.bean.Weather;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALUserEngine;
import com.basha.serveRequest.ALWeatherEngine;


public class WetherTest extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(new TextView(this));
		ALUserEngine.defauleEngine().getAllUnreadMessageCount(new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				Log.i("MyTag", avexception+"--------getAllUnreadMessageCount--------"+object);
				
		}});
//		getwoidTest();
//		getWeatherTest();
//		ALWeatherEngine.xml2JSON(null);
//		ALWeatherEngine.defauleEngine().getWeather(null,null);
	}
	
	private void parxml2list(String xml){
		 //解析对象工厂-->reader对象 读取对象，处理xml
	    try{
	      
	     SAXParserFactory sf=SAXParserFactory.newInstance();
	     SAXParser parse=sf.newSAXParser();
	     XMLReader reader=parse.getXMLReader();
	     MyHandler h = new MyHandler();
	     reader.setContentHandler(h);
	     reader.parse(new InputSource(new StringReader(xml)));
	     List<Weather> list = h.getWeathers();
	     Log.i("MyTag", "--list.size--"+list.size());
	     
	     }catch(Exception e){
	      e.printStackTrace();
	     }
	}
//	{"query":"{results=[{place=[{woeid=[2151330], country=[China], name=[Beijing]}]}]}"}

	private void getwoidTest(){
		ALWeatherEngine.defauleEngine().getWoeid("北京", new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
//				Log.i("MyTag", "-------获取天气id-"+object);

				if(object == null){
					
				}else{
				
					Log.i("MyTag", "-------获取天气id成功----"+object);
				}
			}
		});
	}
	
	private void getWeatherTest(){
		ALWeatherEngine.defauleEngine().getWeather("北京", new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				Log.i("MyTag", "-------获取天气id-"+object);

				if(object == null){
					
				}else{
//					dfs((String) object);
//					Log.i("MyTag", "-------获取天气id成功----"+object);
				}
			}
		});
	}
}
