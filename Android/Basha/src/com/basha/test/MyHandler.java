package com.basha.test;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import android.util.Log;

import com.basha.bean.Weather;

public class MyHandler extends DefaultHandler {
	private ArrayList<Weather> Weathers;
	private Weather Weather;
	private String content;

	public ArrayList<Weather> getWeathers() {
		return Weathers;
	}

	@Override
	public void startDocument() throws SAXException {
		super.startDocument();
		Weathers = new ArrayList<Weather>();
		System.out.println("----------Start Parse Document----------" );
	}
	
	@Override
	public void endDocument() throws SAXException {
		System.out.println("----------End Parse Document----------" );
	}
	
	@Override
	public void characters(char[] ch, int start, int length)
			throws SAXException {
		super.characters(ch, start, length);
		// 获得标签中的文本
		content = new String(ch, start, length);
	}

	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {
		super.startElement(uri, localName, qName, attributes);
		// 打印出localname和qName
		System.out.println("LocalName->" + localName);
		System.out.println("QName->" + qName);
		if ("yweather:forecast".equals(qName)) {
			Weather = new Weather();
			Weather.setCode(attributes.getValue("code"));
//			Weather.setDate(attributes.getValue("date"));
			Weather.setHightemp(attributes.getValue("high"));
			Weather.setLowtemp(attributes.getValue("low"));
		}else if("yweather:condition".equals(qName)){
			Weather = new Weather();
			Weather.setCode(attributes.getValue("code"));
			Weather.setTemp(attributes.getValue("temp"));
			
//			Weather.setDate(attributes.getValue("date"));
//			Weather.setHightemp(attributes.getValue("high"));
//			Weather.setLowtemp(attributes.getValue("low"));
			

		}else if("woeid".equals(qName)){
			Weather = new Weather();
		}
	}

	@Override
	public void endElement(String uri, String localName, String qName)
			throws SAXException {
		super.endElement(uri, localName, qName);
		if ("yweather:forecast".equals(qName)) {
			Log.i("MyTag", "----Weather-------"+Weather.toString());
			Weathers.add(Weather);
		} else if ("yweather:condition".equals(qName)) {
			Log.i("MyTag", "----Weather-------"+Weather.toString());
			Weathers.add(Weather);
		} else if ("Weather".equals(localName)) {
		}else if("woeid".equals(qName)){
			Weather.setWoeid(content);
			Weathers.add(Weather);
		}
	}
}