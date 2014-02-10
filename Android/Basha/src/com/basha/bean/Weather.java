package com.basha.bean;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Weather {
	private String woeid; // 地方的天气id
	private String cityname; // 城市名称
	private Date date; // 日期
	private String temp; // 温度
	private String lowtemp; // 最低温度
	private String hightemp; // 最高温度
	private String atmosphere; // 湿度
	private String speed; // 风速
	private String code; //天气类型21，24...
	private String pm;    //PM污染值
	

	public String getPm() {
		return pm;
	}

	public void setPm(String pm) {
		this.pm = pm;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getWoeid() {
		return woeid;
	}

	public void setWoeid(String woeid) {
		this.woeid = woeid;
	}

	public String getCityname() {
		return cityname;
	}

	public void setCityname(String cityname) {
		this.cityname = cityname;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(String datestr) {
		 try {
			 SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date mdate = simpleDateFormat.parse(datestr);
			this.date = mdate;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	public String getTemp() {
		return temp;
	}

	public void setTemp(String temp) {
		this.temp = temp;
	}

	public String getLowtemp() {
		return lowtemp;
	}

	public void setLowtemp(String lowtemp) {
		this.lowtemp = lowtemp;
	}

	public String getHightemp() {
		return hightemp;
	}

	public void setHightemp(String hightemp) {
		this.hightemp = hightemp;
	}

	public String getAtmosphere() {
		return atmosphere;
	}

	public void setAtmosphere(String atmosphere) {
		this.atmosphere = atmosphere;
	}

	public String getSpeed() {
		return speed;
	}

	public void setSpeed(String speed) {
		this.speed = speed;
	}
	
	@Override
	public String toString() {
		return "code:"+code+" lowtemp:"+lowtemp+" hightemp:"+hightemp;
	}

}
