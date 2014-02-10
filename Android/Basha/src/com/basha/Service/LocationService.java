package com.basha.Service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.PendingIntent;
import android.app.PendingIntent.CanceledException;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.Log;

import com.basha.application.mapplication;

/**
 * 该服务用于获取位置信息，获取到位置信息之后，将发送广播, 开启两个监听器，一个使用gps监听，一个使用网络监听
 * 
 * @author apple
 */
public class LocationService extends Service {
	private LocationManager lm;

	private mapplication  application;
	private MyLocationlistener netLocationListener;
	private MyLocationlistener gpsLocationListener;

	@Override
	public IBinder onBind(Intent arg0) {
		return null;
	}

	@Override
	public void onCreate() {
		super.onCreate();
		Log.i("MyTag", "----服务开始了------");
		application = (mapplication) this.getApplication();
		initLocation(this);
		// 处理无经纬度版本
		// noLocation();
	}

	@Override
	public void onDestroy() {
		Log.i("menu", "服务停止了");
		if (lm != null && netLocationListener != null) {
			lm.removeUpdates(netLocationListener);
		}
		if (lm != null && gpsLocationListener != null) {
			lm.removeUpdates(gpsLocationListener);
		}
		super.onDestroy();
	}

	/**
	 * 定位部分
	 */
	// 获取location对象
	private void initLocation(Context mContext) {
		lm = (LocationManager) mContext
				.getSystemService(Context.LOCATION_SERVICE);
		// 检测有没有打开位置监听功能
		 if (!lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
		 && !lm.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
		 // 网络和gps都没有打开，发送广播，跳转到设置界面
			 openGPS();
			 Log.i("MyTag", "----------打开GPS---");
		 }
		if (lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
			 Log.i("MyTag", "----------打开网络GPS---");

			// 监听时间间隔
			int t1 = 1000;
			// 如果网络监听是打开的，就注册网络监听
			netLocationListener = new MyLocationlistener();
			lm.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, t1, 0,
					netLocationListener);

		}
		if (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
			 Log.i("MyTag", "----------打开卫星GPS---");

			// 监听时间间隔
			int t1 = 1000;
			// 如果GPS监听是打开的，就注册网络监听
			gpsLocationListener = new MyLocationlistener();
			lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, t1, 0,
					gpsLocationListener);
		}
	}

	// 位置改变监听
	private class MyLocationlistener implements LocationListener {

		@Override
		public void onLocationChanged(Location location) {
			Log.i("MyTag",
					"位置改变了" + location.getLatitude() + "    "
							+ location.getLongitude() + "   "
							+ location.getProvider());
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("lat", location.getLatitude());
			map.put("lon", location.getLongitude());
			map.put("time", System.currentTimeMillis());
			application.setLoactionmap(map);
		      
			getAddressByLatLng(location.getLatitude(), location.getLongitude(),new Callback() {
				@Override
				public void dosomething(String str) {
					if(!TextUtils.isEmpty(str)){
						Map<String,Object> addmap = application.getLoactionmap();
						addmap.put("address", str);
						application.setLoactionmap(addmap);
					}
				}
			});
			
		}

		@Override
		public void onProviderDisabled(String provider) {

		}

		@Override
		public void onProviderEnabled(String provider) {
		}

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {
		}
	}

	/**
	 * 由经纬度获得地址
	 * 
	 * @param latitude
	 *            纬度
	 * @param longitude
	 *            经度
	 * @return
	 */

	private static JSONObject geocodeAddr(double lat, double lng) {
		String urlString = "http://ditu.google.com/maps/geo?q=+" + lat + ","
				+ lng + "&output=json&oe=utf8&hl=zh-CN&sensor=false";
		// String urlString =
		// "http://maps.google.com/maps/api/geocode/json?latlng="+lat+","+lng+"&language=zh_CN&sensor=false";
		StringBuilder sTotalString = new StringBuilder();
		try {

			URL url = new URL(urlString);
			URLConnection connection = url.openConnection();
			HttpURLConnection httpConnection = (HttpURLConnection) connection;

			InputStream urlStream = httpConnection.getInputStream();
			BufferedReader bufferedReader = new BufferedReader(
					new InputStreamReader(urlStream));

			String sCurrentLine = "";
			while ((sCurrentLine = bufferedReader.readLine()) != null) {
				sTotalString.append(sCurrentLine);
			}
			bufferedReader.close();
			httpConnection.disconnect(); // 关闭http连接

		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		JSONObject jsonObject = new JSONObject();
		try {
			jsonObject = new JSONObject(sTotalString.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return jsonObject;
	}

	interface Callback{
		void dosomething(String str);
	}
	
	private  void getAddressByLatLng(final double lat, final double lng,final Callback mcallback) {
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				String address = null;
				JSONObject jsonObject = geocodeAddr(lat, lng);
				Log.i("MyTag", "---------------解析到当前地址--jsonObject----"+jsonObject);				

				try {
					JSONArray placemarks = jsonObject.getJSONArray("Placemark");
					JSONObject place = placemarks.getJSONObject(0);
					address = place.getString("address");
					mcallback.dosomething(address);
				} catch (Exception e) {
					e.printStackTrace();
				}
				Log.i("MyTag", "---------------解析到当前地址------"+address);				
			}
		}).start();
		
		
	}


	private void openGPS(){
		Intent gpsIntent = new Intent();
		gpsIntent.setClassName("com.android.settings", "com.android.settings.widget.SettingsAppWidgetProvider");
		gpsIntent.addCategory("android.intent.category.ALTERNATIVE");
		gpsIntent.setData(Uri.parse("custom:3"));
		try {
		    PendingIntent.getBroadcast(LocationService.this, 0, gpsIntent, 0).send();
		} catch (CanceledException e) {
		    e.printStackTrace();
		}
	}
}