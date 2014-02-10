package com.basha.test;

import java.util.List;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.basha.serveRequest.ALUserEngine;
public class UserInterfaceScheTest extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(new TextView(this));
//		signUpTest();
//		createScheduleTest();		
//		LoginTest();
//		getMyScheduleListTest();
		updateScheduleTest();
//		deleScheTest();
	}
	
	private void LoginTest(){
		ALUserEngine.defauleEngine().login("xiao", "xiao", new com.basha.serveRequest.ALEngineConfig.CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
                    if(avexception != null){
                    	avexception.printStackTrace();
                		Log.e("MyTag", "---登录失败--");
                    }else{
                    	if(!(Boolean)object){
                    		Log.e("MyTag", "---登录失败--");
                    		return;
                    	}
                		Log.i("MyTag", "---登录成功--"+AVUser.getCurrentUser());
      	
                    }	
			}
		});
	}

	private void LoginOutTest(){
		ALUserEngine.defauleEngine().logOut();
		Log.i("MyTag", "---登出成功--"+AVUser.getCurrentUser());

		
	}
	
	private void signUpTest(){
		ALUserEngine.defauleEngine().signUp("uip", "abc123", new CallBack() {
			
			@Override
			public void done(Object object, AVException avexception) {
				if(avexception == null){
            		Log.i("MyTag", "---注册成功--");
				}else{
            		Log.e("MyTag", "---注册失败--");
					avexception.printStackTrace();
				}
			}
		});
	}
	
  private void createScheduleTest(){
//	  ALUserEngine.defauleEngine().createSchedule("2014-01-16", "2014-01-16", 1, "xiao", "北京", "这是真的吗", "", null, new CallBack(){
//
//		@Override
//		public void done(Object object, AVException avexception) {
//			if(avexception == null){
//        		Log.i("MyTag", "---添加日程成功--");
//			}else{
//        		Log.e("MyTag", "---添加日程失败--");
//				avexception.printStackTrace();
//			}
//		}
//		  
//	  }) ;
  }
  
  
  private void getMyScheduleListTest(){
	  ALUserEngine.defauleEngine().getMyScheduleList(new CallBack() {
		
		@Override
		public void done(Object object, AVException avexception) {
             if(avexception == null){
            	 if(object == null){
            		 Log.e("MyTag", "--查看日程失败--");
            		 return;
            	 }
//          		Log.i("MyTag", "--查看日程成功--"+object);
            	 if(object instanceof List){
            		 
//            		 for (int i = 0; i < ((List)object).size(); i++) {
            		    for (int i = 0; i < 2; i++) {
            		    	 ALUserEngine.defauleEngine().deleteSchedule(((List<AVObject>)object).get(i), new CallBack() {
								
								@Override
								public void done(Object object, AVException avexception) {

									if(avexception == null){
										if(((Boolean)object) == false){
							        		Log.e("MyTag", "---删除日程失败--");
                                             return;
										}
						        		Log.i("MyTag", "---删除日程成功--");
									}else{
						        		Log.e("MyTag", "---删除日程失败--");
										avexception.printStackTrace();
									}
								
								}
							});
            			}   
            	 }
                  		

             }else{
         		Log.e("MyTag", "--查看日程失败--");
            	 avexception.printStackTrace();
             }		
		}
	}) ;
  }
  
  private void updateScheduleTest(){
	  ALUserEngine.defauleEngine().getMyScheduleList(new CallBack() {
		
		@Override
		public void done(Object object, AVException avexception) {
             if(avexception == null){
            	 if(object == null){
            		 Log.e("MyTag", "--获取日程失败--");
            		 return;
            	 }
            	 if(object instanceof List){
            		 
//            		 for (int i = 0; i < ((List)object).size(); i++) {
            		    for (int i = 0; i < 1; i++) {
            		    	
            		    	
            		    	ALUserEngine.defauleEngine().updateSchedule(((List<AVObject>)object).get(i), null, null, 3, null,"cao", "zz这是文本", null, null, new CallBack(){

								@Override
								public void done(Object object,
										AVException avexception) {
                                 		if(avexception == null){
                                 			if(!((Boolean)object))
                                 			{
                                     			Log.e("MyTag", "--更新日程失败--");
                                                 return;
                                 			}
                                 			Log.i("MyTag", "--更新日程成功--");

                                 		}else{
                                 			Log.e("MyTag", "--更新日程失败--");
                                       	 avexception.printStackTrace();
                                 		}							
								}
            		    		
            		    	});
            		    }   
            	 }
             }else{
         		Log.e("MyTag", "--获取日程失败--");
            	 avexception.printStackTrace();
             }		
		}
	}) ;
  }
  private void deleScheTest(){

	  ALUserEngine.defauleEngine().getMyScheduleList(new CallBack() {
		
		@Override
		public void done(Object object, AVException avexception) {
             if(avexception == null){
            	 if(object == null){
            		 Log.e("MyTag", "--获取日程失败--");
            		 return;
            	 }
            	 if(object instanceof List){
            		 
//            		 for (int i = 0; i < ((List)object).size(); i++) {
            		    for (int i = 0; i < 1; i++) {
            		    	ALUserEngine.defauleEngine().deleteSchedule(((List<AVObject>)object).get(i), new CallBack(){

								@Override
								public void done(Object object,
										AVException avexception) {
                                 		if(avexception == null){
                                 			if(!((Boolean)object))
                                 			{
                                     			Log.e("MyTag", "--删除日程失败--");
                                                 return;
                                 			}
                                 			Log.i("MyTag", "--删除日程成功--");

                                 		}else{
                                 			Log.e("MyTag", "--删除日程失败--");
                                       	 avexception.printStackTrace();
                                 		}							
								}
            		    		
            		    	});
            		    }   
            	 }
             }else{
         		Log.e("MyTag", "--获取日程失败--");
            	 avexception.printStackTrace();
             }		
		}
	}) ;
   
  }
}
