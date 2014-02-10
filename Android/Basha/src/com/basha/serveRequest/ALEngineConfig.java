package com.basha.serveRequest;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.avos.avoscloud.*;

public class ALEngineConfig {
	
	static int DEFAULE_LIMITE = 20;
	static boolean USER_AVOS_STATUS = true;
	
	//通用回调
	//接口 不实现 使用时必须实现接口中所有方法
	public interface CallBack {   
	     void done(Object object,AVException avexception);
	} 
	//抽象类 可实现 使用时不必须重现所有方法
//	public abstract class CallBack {   
//	     void done(Object object,AVException avexception){
//	};
//	} 
	
	//当前用户
	public static AVUser user() {    
		return AVUser.getCurrentUser();
	}
	
	//是否已登录
	public static  Boolean isLoggedIn() {    
		return ALEngineConfig.user()!=null &&ALEngineConfig.user().isAuthenticated();
	}
	
	//include---user
	public static void _includeKeyWithUser( AVQuery<AVObject>  userQ){
		userQ.include("headView");
		userQ.include("userInfo");
		userQ.include("userCount");
		userQ.include("userFavicon");
	}
	
	//include---follow
	public static void _includeKeyWithFollow( AVQuery<AVObject>  followQ){
		followQ.include("followee");
		followQ.include("follower");
	}
	
	//include---message
	public static void _includeKeyWithMessage( AVQuery<AVObject>  messageQ){
		messageQ.include("fromUser");
		messageQ.include("toUser");
		messageQ.include("content");
	}
	
	//include---comment
	public static void _includeKeyWithComment( AVQuery<AVObject>  commentQ){
		commentQ.include("content");
		commentQ.include("photo");
		commentQ.include("user");
	}
	
	//include---photo
	public static void _includeKeyWithPhoto( AVQuery<AVObject>  photoQ){
		photoQ.include("content");
		photoQ.include("brand");
		photoQ.include("temperature");
		photoQ.include("user");
		photoQ.include("collocation");
	}

	//include---schedule
	public static void _includeKeyWithSchedule( AVQuery<AVObject>  scheduleQ){
		scheduleQ.include("content");
		scheduleQ.include("push");
		scheduleQ.include("user");
	}
	
	//通用relation请求
	public static void _commomRelationQueryRequest(final AVObject object, final String relationKey, final Boolean isCount, final CallBack callback) {    
		if (object==null || object.getObjectId()==null)
		{
			callback.done(false, new AVException(1, "没有登录"));
			return;
		}
		
		AVQuery<AVObject> query = object.getRelation(relationKey).getQuery();
		ALEngineConfig._includeKeyWithUser(query);
		ALEngineConfig._includeKeyWithPhoto(query);
		ALEngineConfig._includeKeyWithComment(query);
		ALEngineConfig._includeKeyWithSchedule(query);
		
		if (isCount)
		{
			query.countInBackground(new CountCallback() {
				  public void done(int count, AVException e) {
					  callback.done(count, e);
					  }
					});
		}
		else
		{
			query.findInBackground(new FindCallback<AVObject>() {
			    public void done(List<AVObject> results, AVException e) {
			    	callback.done(results, e);
			      }
			    });
		}
	}
			
	//通用分页
	//YYYY-MM-DD HH:mm:ss
	public static void _addLimit(final int limit,  final Date lessThenDate, AVQuery<AVObject> query) {    
		if (limit!=0)
	    {
			query.setLimit(limit);
	    }
	    else
	    {
	    	query.setLimit(DEFAULE_LIMITE);
	    }
	    
	    if (lessThenDate!=null)
	    {
	    	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String lessThenDateStr = simpleDateFormat.format(lessThenDate);
	    	query.whereLessThan("createdAt", lessThenDate);
	    }
	    query.orderByDescending("createdAt");
	}
}
