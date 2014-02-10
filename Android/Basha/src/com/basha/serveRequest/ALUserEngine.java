package com.basha.serveRequest;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVInstallation;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVQuery;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.CountCallback;
import com.avos.avoscloud.DeleteCallback;
import com.avos.avoscloud.FindCallback;
import com.avos.avoscloud.FollowCallback;
import com.avos.avoscloud.LogInCallback;
import com.avos.avoscloud.SaveCallback;
import com.avos.avoscloud.SignUpCallback;
import com.basha.serveRequest.ALEngineConfig.CallBack;

public class ALUserEngine {
	
	protected static final Object Boolean = null;

	static int DEFAULE_LIMITE = 20;
	
	//单例
	private static ALUserEngine userEngine = null;

	public static ALUserEngine defauleEngine() {    
		if (userEngine == null) 
	   {                             
			userEngine = new ALUserEngine();       
	   }    
		return userEngine;  
	}  

	//手动登录
	public void login(String username, String password, final CallBack boolCallback) {  

		AVUser.logInInBackground(username, password, new LogInCallback() {
		    public void done(AVUser user, AVException e) {
		    	if (user!=null&&e!=null)
		    	{
//		    		userEngine.bindingUser();
		    		ALUserEngine.this.bindingUser();
		    	}
		    	boolCallback.done(user!=null, e);
		    }
		});
	}

	//手动注册
	public void signUp(String username, String password, final CallBack boolCallback) {    
		AVUser user = new AVUser();
		user.setUsername(username);
		user.setPassword(password);

		user.signUpInBackground(new SignUpCallback() {
		    public void done(AVException e) {
		    	boolCallback.done(e!=null,e);
		    }
		});
	}
	
	//登出
	public  void logOut() {    
		AVUser.logOut();
//		SNS.logout(AVUser.getCurrentUser(), 1 , null);
//		SNS.logout(AVUser.getCurrentUser(), 2 , null);
	}
	
	
	
	//添加设备绑定
	public void bindingUser() {    
		AVInstallation.getCurrentInstallation().put("user",ALEngineConfig.user());
		AVInstallation.getCurrentInstallation().saveInBackground();
	}

	//解除设备绑定
	public void unbindingUser() {    
		AVInstallation.getCurrentInstallation().remove("user");
		AVInstallation.getCurrentInstallation().saveInBackground();
	}
	
	//更新用户资料
	public void updateUserInfo(final AVFile headViewFile, final AVFile backgroundViewFile, final String nickname, final String city, final Boolean gender,  final CallBack boolCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			boolCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
		
//		HashMap <String,Object> params = new HashMap<String, Object>();
		if (headViewFile!=null)
		{
			if (headViewFile.getObjectId()==null)
			{
				headViewFile.saveInBackground(new SaveCallback() {
			        @Override
			        public void done(AVException e) {
			           ALUserEngine.this.updateUserInfo(headViewFile,backgroundViewFile,nickname,city,gender,boolCallback);
			        }
			    });
				return;
			}
//			else
//			{
//				params.put("headViewURL",headViewFile.getUrl());
//			}
		}
		
		if (backgroundViewFile!=null)
		{
			if (backgroundViewFile.getObjectId()==null)
			{
				backgroundViewFile.saveInBackground(new SaveCallback() {
			        @Override
			        public void done(AVException e) {
			           ALUserEngine.this.updateUserInfo(headViewFile,backgroundViewFile,nickname,city,gender,boolCallback);
			        }
			    });
			}
//			else
//			{
//				params.put("backgroundViewFile",backgroundViewFile.getUrl());
//			}
		}
		
//		if (nickname!=null) params.put("nickname",nickname);
//	    if (city!=null)  params.put("city",city);
//	    params.put("gender",gender);
	    
//	    AVCloud.callFunctionInBackground("update_user_info", params, new FunctionCallback<Object>() {
//	        public void done(Object object, AVException e) {
//	        	boolCallback.done(object!=null, e);
//	        }
//	    });
		if (headViewFile!=null)
	    {
	        ALEngineConfig.user().put("largeHeadViewURL", headViewFile.getUrl());
	        ALEngineConfig.user().put("smallHeadViewURL", headViewFile.getUrl()+"?imageMogr/auto-orient/thumbnail/100x100");
	    }
	    
	    if (backgroundViewFile!=null)  ALEngineConfig.user().put("backgroundViewURL", backgroundViewFile.getUrl());

	    if (nickname!=null)  ALEngineConfig.user().put("nickname", nickname);

	    if (city!=null) ALEngineConfig.user().put("city", city);

	    ALEngineConfig.user().put("gender", gender);
	    
	    ALEngineConfig.user().put("isCompleteSignUp", true);

	    ALEngineConfig.user().saveInBackground(new SaveCallback() {
	        public void done(AVException e) {
	        	boolCallback.done(e==null, e);
	        }
	    });
	}
	
	//用户关系
	//关注
	public void addFriend(final AVUser user,  final CallBack boolCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			boolCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
		
		if (user==null)
		{
			boolCallback.done(false, new AVException(2, "参数错误"));
			return;
		}
		
		if (ALEngineConfig.USER_AVOS_STATUS)
		{
			ALEngineConfig.user().followInBackground(user.getObjectId(), new FollowCallback<AVObject>() {
				
				 @Override
			        public void done(AVObject object, AVException e) {
					 boolCallback.done(e==null,e);
			        }
			}); 
		}
		else
		{
			ALEngineConfig.user().getRelation("friends").add(user);
			ALEngineConfig.user().saveInBackground(new SaveCallback() {
	            @Override
	            public void done(AVException e) {
	                
	            	if (e!=null)
	            	{
	            		user.getRelation("follows").add(ALEngineConfig.user());
	            		user.saveInBackground(new SaveCallback() {
	                        @Override
	                        public void done(AVException e) {
	                            
	                        	if (e!=null)
	                        	{
	                        		boolCallback.done(true, null);
	                        	}
	                        	else
	                        	{
	                        		boolCallback.done(false, e);
	                        	}
	                        }
	            		});
	            	}
	            	else
	            	{
	            		boolCallback.done(false, e);
	            	}
	            }
			});
		}
	}
	
	//解除关注
	public void removeFriend(final AVUser user,  final CallBack boolCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			boolCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
		
		if (user==null)
		{
			boolCallback.done(false, new AVException(2, "参数错误"));
			return;
		}
		
		if (ALEngineConfig.USER_AVOS_STATUS)
		{
			ALEngineConfig.user().unfollowInBackground(user.getObjectId(), new FollowCallback<AVObject>() {
				
				 @Override
			        public void done(AVObject object, AVException e) {
					 boolCallback.done(e==null,e);
			        }
			}); 
		}
		else
		{
			ALEngineConfig.user().getRelation("friends").remove(user);
			ALEngineConfig.user().saveInBackground(new SaveCallback() {
	            @Override
	            public void done(AVException e) {
	                
	            	if (e!=null)
	            	{
	            		user.getRelation("follows").remove(ALEngineConfig.user());
	            		user.saveInBackground(new SaveCallback() {
	                        @Override
	                        public void done(AVException e) {
	                            
	                        	if (e!=null)
	                        	{
	                        		boolCallback.done(true, null);
	                        	}
	                        	else
	                        	{
	                        		boolCallback.done(false, e);
	                        	}
	                        }
	            		});
	            	}
	            	else
	            	{
	            		boolCallback.done(false, e);
	            	}
	            }
			});
		}
	}
	
	//我的关注
	public void myFriends(final CallBack listCallback) {    
		if (ALEngineConfig.USER_AVOS_STATUS)
		{
//			ALEngineConfig.user().getMyFolloweesInBackground(new FindCallback<AVObject>() {
//				@Override
//		        public void done(List Objects, AVException e) {
//					listCallback.done(Objects, e);
//		        }
//			});
			AVQuery<AVObject> followQ =new AVQuery<AVObject>("_Followee");
			ArrayList<String> keys = new ArrayList<String>();
			keys.add("followee");
			followQ.selectKeys(keys);
			ALEngineConfig._includeKeyWithFollow(followQ);
			followQ.whereEqualTo("user", ALEngineConfig.user());
			followQ.findInBackground(new FindCallback<AVObject>() {
				
				@Override
				public void done(List<AVObject> Objects, AVException e) {
					if (e==null)
					{
						ArrayList<AVObject> follows = new ArrayList<AVObject>();
						for (AVObject follow : Objects)
						{
							follows.add((AVObject) follow.get("followee"));
						}
						listCallback.done(follows, e);
					}
					else
					{
						listCallback.done(null, e);
					}
				}
			});
		}
		else
		{
			ALEngineConfig._commomRelationQueryRequest(ALEngineConfig.user(), "friends", false, listCallback);
		}
	}
	
	//我的关注数
	public void myFriendsCount(final CallBack intCallback) {    
		if (ALEngineConfig.USER_AVOS_STATUS)
		{
//			ALEngineConfig.user().getMyFolloweesInBackground(new FindCallback<AVObject>() {
//				@Override
//		        public void done(List Objects, AVException e) {
//					intCallback.done(Objects.size(), e);
//		        }
//			});
			AVQuery<AVObject> userQ =new AVQuery<AVObject>("_Followee");
			userQ.whereEqualTo("user", ALEngineConfig.user());
			userQ.countInBackground(new CountCallback() {
				
				@Override
				public void done(int number, AVException e) {
					intCallback.done(number,e);
				}
			});
		}
		else
		{
			ALEngineConfig._commomRelationQueryRequest(ALEngineConfig.user(), "friends", true, intCallback);
		}
	}
	
	//我的粉丝
	public void myFollows(final CallBack listCallback) {    
		if (ALEngineConfig.USER_AVOS_STATUS)
		{
//			ALEngineConfig.user().getFollowersInBackground(new FindCallback<AVObject>() {
//				@Override
//		        public void done(List Objects, AVException e) {
//					listCallback.done(Objects, e);
//		        }
//			});

			AVQuery<AVObject> followQ =new AVQuery<AVObject>("_Follower");
			ArrayList<String> keys = new ArrayList<String>();
			keys.add("follower");
			followQ.selectKeys(keys);
			ALEngineConfig._includeKeyWithFollow(followQ);
			followQ.whereEqualTo("user", ALEngineConfig.user());
			followQ.findInBackground(new FindCallback<AVObject>() {
				
				@Override
				public void done(List<AVObject> Objects, AVException e) {
					if (e==null)
					{
						ArrayList<AVObject> follows = new ArrayList<AVObject>();
						for (AVObject follow : Objects)
						{
							follows.add((AVObject) follow.get("follower"));
						}
						listCallback.done(follows, e);
					}
					else
					{
						listCallback.done(null, e);
					}
				}
			});
		}
		else
		{
			ALEngineConfig._commomRelationQueryRequest(ALEngineConfig.user(), "follows", false, listCallback);
		}
	}
	
	//我的粉丝数
	public void myFollowsCount(final CallBack intCallback) {    
		if (ALEngineConfig.USER_AVOS_STATUS)
		{
//			ALEngineConfig.user().getFollowersInBackground(new FindCallback<AVObject>() {
//				@Override
//		        public void done(List Objects, AVException e) {
//					intCallback.done(Objects.size(), e);
//		        }
//			});
			AVQuery<AVObject> userQ =new AVQuery<AVObject>("_Follower");
			userQ.whereEqualTo("user", ALEngineConfig.user());
			userQ.countInBackground(new CountCallback() {
				
				@Override
				public void done(int number, AVException e) {
					intCallback.done(number,e);
				}
			});
		}
		else
		{
			ALEngineConfig._commomRelationQueryRequest(ALEngineConfig.user(), "follows", true, intCallback);
		}
	}

	//发消息
	public void postMessage(final String text, final AVFile voiceFile, final String url, final AVUser toUser, final CallBack boolCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			boolCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
//		HashMap <String,Object> params = new HashMap<String, Object>();
		if (voiceFile!=null)
		{
			if (voiceFile.getObjectId()==null)
			{
				voiceFile.saveInBackground(new SaveCallback() {
			        @Override
			        public void done(AVException e) {
			           ALUserEngine.this.postMessage(text,voiceFile,url,toUser,boolCallback);
			        }
			    });
				return;
			}
//			else
//			{
//				params.put("voiceURL",voiceFile.getUrl());
//			}
		}
//		params.put("toUser",toUser);
//		params.put("text",text);
		
//		AVCloud.callFunctionInBackground("post_message", params, new FunctionCallback<Object>() {
//	        public void done(Object object, AVException e) {
//	        	boolCallback.done(object!=null, e);
//	        }
//	    });
		
		AVObject msg = new AVObject("Message");
		msg.put("toUser", toUser);
		msg.put("fromUser", ALEngineConfig.user());
		
		AVObject content = new AVObject("Content");
		if (text!=null) content.put("text",text);
		if (voiceFile!=null) content.put("voiceURL",voiceFile.getUrl());
		msg.put("content", content);
		msg.saveInBackground(new SaveCallback() {
			
			@Override
			public void done(AVException e) {
				boolCallback.done(e==null, e);
			}
		});
	}
	
	//更改会话中未读状态为已读
	public void updateUnreadState(final AVUser user,  final CallBack boolCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			boolCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
		if (user==null)
		{
			boolCallback.done(false, new AVException(2, "参数错误"));
			return;
		}
//		HashMap <String,Object> params = new HashMap<String, Object>();
//		params.put("fromUser",user);
//		AVCloud.callFunctionInBackground("update_message_to_is_read", params, new FunctionCallback<Object>() {
//	        public void done(Object object, AVException e) {
//	        	boolCallback.done(object!=null, e);
//	        }
//	    });
		
		AVQuery<AVObject> msgQ = new AVQuery<AVObject>("Message");
		msgQ.whereEqualTo("toUser",ALEngineConfig.user());
		msgQ.whereEqualTo("fromUser",ALEngineConfig.user());
		msgQ.findInBackground(new FindCallback<AVObject>() {
		    public void done(List<AVObject> results, AVException e) {
		    	for (AVObject msg : results) {
		            msg.put("isRead",true);
		        }
		    	boolCallback.done(results!=null, e);
		      }
		    });
	}
	
	//获得全部未读的聊天记录数
	public void getAllUnreadMessageCount(final CallBack intCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			intCallback.done(false, new AVException(1, "没有登录"));
			return;
		}

//		AVCloud.callFunctionInBackground("post_message", null, new FunctionCallback<Object>() {
//	        public void done(Object object, AVException e) {
//	        	intCallback.done(Integer.parseInt(object.toString()), e);
//	        }
//	    });
		
		AVQuery<AVObject>  msgQ = new AVQuery<AVObject> ("Message");
		msgQ.whereEqualTo("toUser",ALEngineConfig.user());
		msgQ.whereNotEqualTo("isRead",true);
		msgQ.whereNotEqualTo("isDelete",true);
		msgQ.countInBackground(new CountCallback() {
			  public void done(int count, AVException e) {
				  intCallback.done(count, e);
				  }
				});
//	    [msgQ countObjectsInBackgroundWithBlock:resultBlock];
	}
	
	public void getAllUnreadMessageCountAboutUser(final CallBack listCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			listCallback.done(null, new AVException(1, "没有登录"));
			return;
		}
		AVQuery<AVObject>  msgQ = new AVQuery<AVObject> ("Message");
		ArrayList<String> keys = new ArrayList<String>();
		keys.add("fromUser");
		msgQ.selectKeys(keys);
		msgQ.whereEqualTo("toUser",ALEngineConfig.user());
		msgQ.whereNotEqualTo("isRead",true);
		msgQ.whereNotEqualTo("isDelete",true);
		ALEngineConfig._includeKeyWithMessage(msgQ);
		msgQ.findInBackground(new FindCallback<AVObject>() {
			
			@Override
			public void done(List<AVObject> objects, AVException e) {
				if (e==null)
				{
					ArrayList<Map> messages = new ArrayList<Map>();
					for (AVObject msg : objects)
					{
						Boolean isExsit = false;
						for (Map <String,Object> msgDic : messages)
						{
							AVObject user1 = (AVObject) msgDic.get("user");
							AVObject user2 = msg.getAVObject("fromUser");
							if (user1!=null && user2!=null && user1.getObjectId().equals(user2.getObjectId()))
							{
								isExsit = true;
								msgDic.put("count", (Integer)msgDic.get("count")+1);
							}
						}
						if (!isExsit)
						{
							Map <String,Object> msgDic = new HashMap<String, Object>();
							msgDic.put("user", msg.getAVObject("fromUser"));
							msgDic.put("count", 1);
							messages.add(msgDic);
						}
					}
					listCallback.done(messages,e);
				}
				else
				{
					listCallback.done(objects,e);
				}
			}
		});
//	    [msgQ countObjectsInBackgroundWithBlock:resultBlock];
	}
	
	//获取与某用户的聊天记录
	public void getUserMessage(final AVUser user, final int limit,  final Date lessThenDate,  final CallBack listCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			listCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
		if (user==null)
		{
			listCallback.done(false, new AVException(2, "参数错误"));
			return;
		}
		HashMap <String,Object> params = new HashMap<String, Object>();
		
		AVQuery<AVObject> msgQ1 = new AVQuery<AVObject>("Message");
		msgQ1.whereEqualTo("toUser",ALEngineConfig.user());
		msgQ1.whereEqualTo("fromUser",user);
		msgQ1.whereNotEqualTo("isDelete",true);
		
		AVQuery<AVObject> msgQ2 = new AVQuery<AVObject>("Message");
		msgQ2.whereEqualTo("fromUser",ALEngineConfig.user());
		msgQ2.whereEqualTo("toUser",user);
		msgQ2.whereNotEqualTo("isDelete",true);
		
		AVQuery<AVObject> msgQ = new AVQuery<AVObject>("Message");
		ALEngineConfig._addLimit(limit,lessThenDate,msgQ);
		ALEngineConfig._includeKeyWithMessage(msgQ);
//		msgQ.orderByDescending("createdAt");
		msgQ.findInBackground(new FindCallback<AVObject>() {
			
			@Override
			public void done(List<AVObject> objects, AVException e) {
				// TODO Auto-generated method stub
				if (e==null)
		    	{
		    		ArrayList<AVObject> objs = new ArrayList<AVObject>();
		    		for (int i = objects.size()-1; i >=0; --i) {
		    			objs.add(objects.get(i));
					}
		    		listCallback.done(objs, e);
		    	}
				else
				{
					listCallback.done(objects, e);
				}
			}
		});
	}
	
	//获取与某用户的未读聊天记录
	public void getUserUnreadMessage(final AVUser user, final int limit,  final Date lessThenDate,  final CallBack listCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			listCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
		if (user==null)
		{
			listCallback.done(false, new AVException(2, "参数错误"));
			return;
		}
		HashMap <String,Object> params = new HashMap<String, Object>();
		
		AVQuery<AVObject> msgQ = new AVQuery<AVObject>("Message");
		msgQ.whereEqualTo("toUser",ALEngineConfig.user());
		msgQ.whereEqualTo("fromUser",user);
		msgQ.whereNotEqualTo("isDelete",true);
//		msgQ.orderByDescending("createdAt");
		ALEngineConfig._addLimit(limit,lessThenDate,msgQ);
		ALEngineConfig._includeKeyWithMessage(msgQ);
		msgQ.findInBackground(new FindCallback<AVObject>() {
		    public void done(List<AVObject> objects, AVException e) {
		    	if (e==null)
		    	{
		    		ArrayList<AVObject> objs = new ArrayList<AVObject>();
		    		for (int i = objects.size()-1; i >=0; --i) {
		    			objs.add(objects.get(i));
					}
		    		listCallback.done(objs, e);
		    	}
				else
				{
					listCallback.done(objects, e);
				}
		      }
		});
	}
	
	//获取最近联系人列表
	public void getContacts(final CallBack listCallback) {    
		ALEngineConfig._commomRelationQueryRequest(ALEngineConfig.user(), "contacts", false, listCallback);
	}
	
	//删除联系人（同时将所有该联系人的消息delete）
	public void delContacts(final AVUser user, final CallBack boolCallback) {    
		if (!ALEngineConfig.isLoggedIn())
		{
			boolCallback.done(false, new AVException(1, "没有登录"));
			return;
		}
		if (user==null)
		{
			boolCallback.done(false, new AVException(2, "参数错误"));
			return;
		}
//		HashMap <String,Object> params = new HashMap<String, Object>();
//		params.put("fromUser", user);
//		AVCloud.callFunctionInBackground("delete_contacts", params, new FunctionCallback<Object>() {
//	        public void done(Object object, AVException e) {
//	        	boolCallback.done(object!=null, e);
//	        }
//	    });
		this.updateUnreadState(user, new CallBack() {
			@Override
			public void done(Object object, AVException e) {
				if ((Boolean)object && e==null)
				{
					ALEngineConfig.user().getRelation("contacts").remove(user);
					ALEngineConfig.user().saveEventually(new SaveCallback() {
					    public void done(AVException e) {
					    	boolCallback.done(e==null, e);
					    }
					});
				}
				else
				{
					boolCallback.done(false, e);
				}
			}
		    });
	}		
	public void test() throws AVException{
		AVObject test1 = new AVObject("Test1");
		test1.put("string", "string");
		test1.put("bug", "");
		
		AVObject test2 = new AVObject("Test2");
		test2.put("string", "string");
		test2.put("test1",test1);
		
		test2.save();
	}
		//创建日程
		public void createSchedule(final Date date, final Date remindDate, final int type, final String woeid, final String place, final String text, final String URL, final AVFile voiceFile, final CallBack boolCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				boolCallback.done(false, new AVException(1, "没有登录"));
				return;
			}

			HashMap <String,Object> params = new HashMap<String, Object>();
//			params.put("fromUser", user);
			if (voiceFile!=null)
			{
				if (voiceFile.getObjectId()==null)
				{
					voiceFile.saveInBackground(new SaveCallback() {
				        @Override
				        public void done(AVException e) {
				           ALUserEngine.this.createSchedule(date, remindDate,  type, woeid, place, text, URL, voiceFile, boolCallback);
				        }
				    });
					return;
				}
//				else
//				{
//					params.put("voiceURL",voiceFile.getUrl());
//				}
			}
			
//			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//			String remindDateStr = simpleDateFormat.format(remindDate);
//			String dateStr = simpleDateFormat.format(date);
			
//			params.put("dateStr",dateStr);
//			params.put("remindDateStr",remindDateStr);
//			params.put("URL",URL);
//			params.put("type",type);
//			params.put("woeid",woeid);
//			params.put("place",place);
//			params.put("text",text);

//			AVCloud.callFunctionInBackground("create_schedule", params, new FunctionCallback<Object>() {
//		        public void done(Object object, AVException e) {
//		        	boolCallback.done(object!=null, e);
//		        }
//		    });
		
			
//			AVCloud.callFunctionInBackground("created_push", params, new FunctionCallback<Object>() {
//		        public void done(Object object, AVException e) {
//		        	if (object!=null && e==null)
//		        	{
		        		AVObject schedule = new AVObject("Schedule");
		        		
		        		schedule.put("date", date);
		        		schedule.put("remindDate", remindDate);
		        		schedule.put("type", type);
		        		schedule.put("woeid", woeid);
		        		schedule.put("place", place);
		        		schedule.put("user", ALEngineConfig.user());
//		        		schedule.put("push", AVObject.createWithoutData("_Notification", (String) object));
		        		
		        		AVObject content = new AVObject("Content");
		        		if (text!=null) content.put("text",text);
		        		if (voiceFile!=null) content.put("voiceURL",voiceFile.getUrl());
		        		if (URL!=null) content.put("URL",URL);
		        		schedule.put("content", content);

		        		schedule.saveEventually(new SaveCallback() {
							
							@Override
							public void done(AVException e) {
								boolCallback.done(e==null, e);
							}
						});
//		        	}
//		        	else
//		        	{
//		        		boolCallback.done(false, e);
//		        	}
//		        }
//		    });
	}
		
		//查看全部日程
		public void getMyScheduleList(final CallBack listCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				listCallback.done(null, new AVException(1, "没有登录"));
				return;
			}
			
			AVQuery<AVObject> scheQ = new AVQuery<AVObject>("Schedule");
			scheQ.whereEqualTo("user",ALEngineConfig.user());
			ALEngineConfig._includeKeyWithSchedule(scheQ);
			scheQ.findInBackground(new FindCallback<AVObject>() {
			    public void done(List<AVObject> results, AVException e) {
			    	listCallback.done(results, e);
			      }
			    });
		}	
		
	
		/**
		 *编辑日程
		 */
		public void updateSchedule(final AVObject chedule, final Date date, final Date remindDate, final int type, final String woeid, final String place, final String text, final String URL, final AVFile voiceFile, final CallBack boolCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				boolCallback.done(false, new AVException(1, "没有登录"));
				return;
			}

			if (chedule.getObjectId()==null || chedule==null)
			{
				boolCallback.done(false, new AVException(1, "参数错误"));
				return;
			}
			HashMap <String,Object> params = new HashMap<String, Object>();
//			params.put("fromUser", user);
			if (voiceFile!=null)
			{
				if (voiceFile.getObjectId()==null)
				{
					voiceFile.saveInBackground(new SaveCallback() {
				        @Override
				        public void done(AVException e) {
				           ALUserEngine.this.updateSchedule(chedule, date, remindDate,  type, woeid, place, text, URL, voiceFile, boolCallback);
				        }
				    });
					return;
				}
//				else
//				{
//					params.put("voiceURL",voiceFile.getUrl());
//				}
			}
			
//			chedule.put("type",type);
//			if (woeid!=null) chedule.put("woeid",woeid);
//			if (place!=null) chedule.put("place",place);
//			if (date!=null) chedule.put("date",date);
//			if (text!=null || URL!=null || voiceFile!=null) 
//			{
//				AVObject content =  new AVObject("Content");
//				if (text!=null) content.put("text",text);
//				if (URL!=null) content.put("URL",URL);
//				if (voiceFile!=null) content.put("voiceURL",voiceFile.getUrl());
//				chedule.put("content",content);
//			}
//
//			if (remindDate!=null) 
//			{
//					((AVObject) chedule.get("push")).deleteEventually(new DeleteCallback() {
//					    public void done(AVException e) {
//					    	if (e==null)
//					    	{
//					    		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//								String remindDateStr = simpleDateFormat.format(remindDate);
//								
//								HashMap <String,Object> params = new HashMap<String, Object>();
//								params.put("remindDateStr", remindDateStr);
//								params.put("alert", "你有一条新得提醒");
//								
//					    		AVCloud.callFunctionInBackground("created_push", params, new FunctionCallback<Object>() {
//							        public void done(Object object, AVException e) {
//							        	AVObject push = AVObject.createWithoutData("_Notification", (String) object);
//							        	chedule.put("push",push);
//							        	chedule.saveInBackground(new SaveCallback() {
//									        @Override
//									        public void done(AVException e) {
//									        	boolCallback.done(e==null, e);
//									        }
//									    });
//							        }
//							    });
//					    	}
//					    	else
//					    	{
//					    		boolCallback.done(e==null, e);
//					    	}
//					    }
//					 });
//			}
//			else
//			{
//				chedule.saveInBackground(new SaveCallback() {
//			        @Override
//			        public void done(AVException e) {
//			        	boolCallback.done(e==null, e);
//			        }
//			    });
//			}

			this.deleteSchedule(chedule, new CallBack() {
				
				@Override
				public void done(Object object, AVException e) {
					// TODO Auto-generated method stub
					if ((Boolean)object && e==null)
					{
						ALUserEngine.this.createSchedule(date, remindDate, type, woeid, place, text, URL, voiceFile, boolCallback);
					}
					else
					{
						boolCallback.done(e==null, e);
					}
				}
			});
	}
		
		//删除日程
		public void deleteSchedule(final AVObject chedule, final CallBack boolCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				boolCallback.done(false, new AVException(1, "没有登录"));
				return;
			}

			if (chedule==null || chedule.getObjectId()==null)
			{
				boolCallback.done(false, new AVException(2, "参数错误"));
				return;
			}
			
//			((AVObject) chedule.get("push")).deleteEventually(new DeleteCallback() {
//			    public void done(AVException e) {
//			    	if (e==null)
//			    	{
			    		chedule.deleteEventually(new DeleteCallback() {
						    public void done(AVException e) {
						    	boolCallback.done(e==null, e);
						    }
						 });
//			    	}
//			    	else
//			    	{
//			    		boolCallback.done(false, null);
//			    	}
//			    }
//			 });

		}	
}





