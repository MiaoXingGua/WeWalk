package com.basha.Service;

import java.util.Timer;
import java.util.TimerTask;

import org.json.JSONException;
import org.json.JSONObject;

import com.avos.avoscloud.AVException;
import com.basha.serveRequest.ALWeatherEngine;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.text.format.Time;
import android.util.Log;

public class WetherRequestService extends Service{
     @Override
    public void onCreate() {
    	super.onCreate();
    	TimerTask task = new TimerTask() {
    		   public void run() {
    		   //每次需要执行的代码放到这里面。   
    		   }   
    		};
        Timer time = new Timer();
        time.schedule(task, 1000, 2*60*60*1000);
    }
     
     private void requestWether(){

 		ALWeatherEngine.defauleEngine().getWoeid("北京", new com.basha.serveRequest.ALEngineConfig.CallBack() {
// 			{"query":"{results=[{place=[{woeid=[2151330], country=[China], name=[Beijing]}]}]}"}
		
 			@Override
 			public void done(Object object, AVException avexception) {
 				Log.i("MyTag", "-------获取天气id-"+object);
                 if(object != null){
                	try {
						JSONObject jsonobject = new JSONObject((String)object);
//						String woid = jsonobject.getJSONObject("query").getJSONArray("results").getJSONObject(0).getJSONArray("place").get/
					} catch (JSONException e) {
						e.printStackTrace();
					}
                 }
 			
 			}
 		});
 	

	
    	 
     }
     
    private void getWether(String woid){
	ALWeatherEngine.defauleEngine().getWeather(woid, new com.basha.serveRequest.ALEngineConfig.CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				Log.i("MyTag", "-------获取天气id-"+object);

				if(object == null){
					
				}else{
					Log.i("MyTag", "-------获取天气id成功----"+object);
				}
			}
		});
    }
     
    @Override
    public void onStart(Intent intent, int startId) {
    	super.onStart(intent, startId);
    } 
	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}
    
	
	
}
