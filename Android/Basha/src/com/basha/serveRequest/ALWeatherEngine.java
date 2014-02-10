package com.basha.serveRequest;

import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

import android.util.Log;

import com.loopj.android.http.*;
import com.avos.avoscloud.*;
import com.basha.bean.Weather;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.test.MyHandler;

import net.sf.json.*;
import net.sf.json.xml.XMLSerializer;

public class ALWeatherEngine {
	
	static String YAHOO_BASIC_WEATHER = "http://weather.yahooapis.com/forecastrss?";

	static String YAHOO_CITY_NAME_TO_WOEID = "http://query.yahooapis.com/v1/public/yql?q=select%20woeid,name,country%20from%20geo.places%20where%20text=";
	static String BAIDU_TRANSFORM = "http://openapi.baidu.com/public/2.0/bmt/translate?client_id=uvo4jom8E8TkTpU2RE5AKYeR&from=auto&to=auto&q=";

	static String PM25_API = "http://www.pm25.in/api/querys/pm2_5.json?token=5j1znBVAsnSf5xQyNQyq&city=";
	
	//单例
		private static ALWeatherEngine weatherEngine = null;

		public static ALWeatherEngine defauleEngine() {    
			if (weatherEngine == null) 
		   {                          
				weatherEngine = new ALWeatherEngine();     
		   }    
			return weatherEngine;  
		}  
		
		//xml2json
		 public static String xml2JSON(String xml){  
		        return new XMLSerializer().read(xml).toString();  
		    }  
		      
		 //json2xml
	    public static String json2XML(String json){  
	        JSONObject jobj = JSONObject.fromObject(json);  
	        String xml =  new XMLSerializer().write(jobj);  
	        return xml;  
	    }  
		
		//获取woeid
		public void getWoeid(String cityName, final CallBack stringCallback) {    
			
			AsyncHttpClient client = new AsyncHttpClient();  
	        try {
				client.get(ALWeatherEngine.YAHOO_CITY_NAME_TO_WOEID+"'"+new String(cityName.getBytes(),"UTF-8")+"'", new AsyncHttpResponseHandler() {  
				      
				    @Override  
				    public void onSuccess(String response) {  
				    	stringCallback.done(response, null);
				    }  
                   public void onFailure(Throwable arg0) {
   	            	stringCallback.done(null, new AVException(arg0));
                   };
				} );
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				stringCallback.done(e==null, new AVException(1, "UnsupportedEncodingException"));
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
		//获取天气
		public  void getWeather(String woeid, final CallBack stringCallback) {  
//			2151330
			AsyncHttpClient client = new AsyncHttpClient();  
	        client.get(ALWeatherEngine.YAHOO_BASIC_WEATHER+"w="+woeid+"&u=c", new AsyncHttpResponseHandler() {  
	              
	            @Override  
	            public void onSuccess(String response) {  
	            	
	            	stringCallback.done(response, null);
	            }  
	            public void onFailure(Throwable arg0) {
	            	stringCallback.done(null, new AVException(arg0));
	            };  
	            
	        } ); 
		}  
		
		public void mgetWeather(String cityName, final CallBack stringCallback){
			getWoeid(cityName ,new CallBack() {
				
				@Override
				public void done(Object object, AVException avexception) {
					if(avexception == null){
						if(object == null)return;
						List<Weather> list = parxml2list((String)object);
						if(list == null || list.size() == 0) return;
						getWeather(list.get(0).getWoeid(),new CallBack() {
							
							@Override
							public void done(Object object, AVException avexception) {
								  if(avexception == null){
									  if(object == null)return;
//										List<Weather> list = parxml2list((String)object);
										stringCallback.done(object, null);
										
								  }else{
									  avexception.printStackTrace();
								  }
							}
						});
					}else{
						avexception.printStackTrace();
					}
				}
			});
			
			
			
			
		}
		//获取pm25
		public  void getAQI(String cityName, final CallBack intCallback) {    
			AVQuery<AVObject> aqiQ = AVQuery.getQuery("AirQualityIndex");
			aqiQ.whereEqualTo("area", cityName);
			aqiQ.orderByDescending("createdAt");
			aqiQ.limit(10);
			aqiQ.findInBackground(new FindCallback<AVObject>() {
			    public void done(List<AVObject> objects, AVException e) {
//			    	stringCallback.done(objects,e);
			    	if (e==null)
			    	{
			    		ArrayList<AVObject> aqis = new ArrayList<AVObject>(); 
			    		AVObject obj0 = objects.get(0);
						for (AVObject obj : objects)
						{
							if (obj.getCreatedAt().getTime() == obj0.getCreatedAt().getTime())
							{
								aqis.add(obj);  
							}
						}
						int aqi = 0;
						for (AVObject temAqi : aqis)
						{
							aqi += temAqi.getInt("aqi");
						}
						aqi/=aqis.size();
						intCallback.done(aqi,null);
			    	}
			    	else
			    	{
			    		intCallback.done(0,e);
			    	}
			    }
			});
		}  
		/*
		 * 返回当前时间的时间戳datetime
		 */
		public  void currentDate(final CallBack intCallback) {    
			AVCloud.callFunctionInBackground("datetime", null, new FunctionCallback<Object>() {
		        public void done(Object object, AVException e) {
		        	intCallback.done(object, e);
		        }
		    });
		}  
		
}