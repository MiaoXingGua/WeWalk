package com.basha.application;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import android.app.Application;
import android.content.SharedPreferences;
import android.text.TextUtils;
import android.util.Log;

import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.AVObject;
import com.basha.bean.Weather;

public class mapplication extends Application {

	private AVObject schAvobject = null; // 当前选择的日程，用于编辑日程
	private AVObject shifanphotoAvobject = null; // 示范图片
	private AVObject jiepaphotoAvobject = null; //  街拍图片

	private Map<String, List<Weather>> cityWeathersmap = null;

	private Date nowdate = new Date();

	private String nowcityname = "北京";

	private SharedPreferences shp;
	
	private Map<String,Object> loactionmap = null; //当前地理位置key :lat\ lon\time\place

	public Map<String, Object> getLoactionmap() {
		return loactionmap;
	}

	public void setLoactionmap(Map<String, Object> loactionmap) {
		this.loactionmap = loactionmap;
	}
	

	public AVObject getShifanphotoAvobject() {
		return shifanphotoAvobject;
	}

	public void setShifanphotoAvobject(AVObject shifanphotoAvobject) {
		this.shifanphotoAvobject = shifanphotoAvobject;
	}

	public AVObject getJiepaphotoAvobject() {
		return jiepaphotoAvobject;
	}

	public void setJiepaphotoAvobject(AVObject jiepaphotoAvobject) {
		this.jiepaphotoAvobject = jiepaphotoAvobject;
	}

	public String getNowCityname() {
		String name = "北京";
		String jsonarrstr = shp.getString("setting_citys", "");
		int index = shp.getInt("setting_citys_select", 0);
		try {
			JSONArray jsonarr = new JSONArray(jsonarrstr);
			name = jsonarr.getJSONObject(index).getString("cityname");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return name;
	}

	public String getNowDistrictnamename() {

		String name = "北京";
		String jsonarrstr = shp.getString("setting_citys", "");
		int index = shp.getInt("setting_citys_select", 0);
		try {
			JSONArray jsonarr = new JSONArray(jsonarrstr);
			name = jsonarr.getJSONObject(index).getString("districtname");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return name;

	}

	public Date getNowdate() {
		return nowdate;
	}

	public void setNowdate(Date nowdate) {
		if (nowdate == null)
			return;
		nowdate.setHours(0);
		nowdate.setMinutes(0);
		nowdate.setSeconds(0);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		Log.i("MyTag", "------setnowdate-----" + sdf.format(nowdate));
		this.nowdate = nowdate;
	}

	public Map<String, List<Weather>> getCityWeathersmap() {
		return cityWeathersmap;
	}

	public void addtCityWeathers2map(String cityname, List<Weather> weathers) {
		cityWeathersmap.put(cityname, weathers);
	}

	/**
	 * 
	 * @param cityname
	 *            可以是城市名、woid
	 * @return
	 */
	public List<Weather> getCityWeathers(String cityname) {

		return cityWeathersmap.get(cityname);
	}

	public AVObject getSchAvobject() {
		return schAvobject;
	}

	public void setSchAvobject(AVObject schAvobject) {
		this.schAvobject = schAvobject;
	}

	@Override
	public void onCreate() {
		super.onCreate();
		AVOSCloud.useAVCloudCN();
		AVOSCloud.initialize(this,
				"sy9s3xqtcdi3nsogyu1gnojg0wxslws0kl28lgd02hgsddff",
				"bc0cullpfyceroe12164i8evoi5cw4zpbszssgtqp0k78xyh");
//		AVOSCloud.initialize(this,
//				"pljwkiridjjh98hum6dy1vs3eeq4uu00bgguuhrmt0lk4gtm",
//				"z021ffbim9aq6jmef6lbs1q1d2ckbocr26ewcvcphrrrkxo6");
		AVOSCloud.setLastModifyEnabled(false);	
		cityWeathersmap = new HashMap<String, List<Weather>>();
		shp = getSharedPreferences("basha", MODE_PRIVATE);

	}

	// /**
	// * User-Agent
	// *
	// * @return user-agent
	// */
	// public String getUser_Agent() {
	// String ua = "Android;" + getOSVersion() + ";" + getVersion() + ";"
	// + getVendor() + "-" + getDevice();
	// return ua;
	// }
	//
	// /**
	// * device model name, e.g: GT-I9100
	// *
	// * @return the user_Agent
	// */
	// public String getDevice() {
	// return Build.MODEL;
	// }
	//
	// /**
	// * device factory name, e.g: Samsung
	// *
	// * @return the vENDOR
	// */
	// public String getVendor() {
	// return Build.BRAND;
	// }
	//
	// /**
	// * @return the SDK version
	// */
	// public int getSDKVersion() {
	// return Build.VERSION.SDK_INT;
	// }
	//
	// /**
	// * @return the OS version
	// */
	// public String getOSVersion() {
	// return Build.VERSION.RELEASE;
	// }
	//
	// /**
	// * Retrieves application's version number from the manifest
	// *
	// * @return versionName
	// */
	// public String getVersion() {
	// String version = "0.0.0";
	// try {
	// PackageInfo packageInfo = this.getPackageManager().getPackageInfo(
	// getPackageName(), 0);
	// version = packageInfo.versionName;
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// return version;
	// }
	//
	// /**
	// * Retrieves application's version code from the manifest
	// *
	// * @return versionCode
	// */
	// public int getVersionCode() {
	// int code = 1;
	// try {
	// PackageInfo packageInfo = getPackageManager().getPackageInfo(
	// getPackageName(), 0);
	// code = packageInfo.versionCode;
	// } catch (NameNotFoundException e) {
	// e.printStackTrace();
	// }
	//
	// return code;
	// }
}
