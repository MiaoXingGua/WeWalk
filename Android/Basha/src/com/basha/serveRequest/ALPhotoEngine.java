package com.basha.serveRequest;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.json.JSONObject;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVGeoPoint;
import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVQuery;
import com.avos.avoscloud.CountCallback;
import com.avos.avoscloud.FindCallback;
import com.avos.avoscloud.GetCallback;
import com.avos.avoscloud.SaveCallback;
import com.basha.serveRequest.ALEngineConfig.CallBack;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;

public class ALPhotoEngine {

	//单例
		private static ALPhotoEngine photoEngine = null;

		public static ALPhotoEngine defauleEngine() {    
			if (photoEngine == null) 
		   {                              
				photoEngine = new ALPhotoEngine();      
		   }    
			return photoEngine;  
		}  

		//上传街拍
		public  void postPhoto(final List<AVFile>imageFiles, final float temperature, final int weatherCode, final String text, final AVFile voiceFile, final Boolean isShareToSinaWeibo, final Boolean isShareToQQWeibo, final float latitude, final float longitude, final CallBack boolCallback) {    
			
			if (!ALEngineConfig.isLoggedIn())
			{
				boolCallback.done(false, new AVException(1, "没有登录"));
				return;
			}
			
			if (imageFiles==null || imageFiles.size()==0)
			{
				boolCallback.done(false, new AVException(2, "参数错误"));
				return;
			}
			
//			HashMap <String,Object> params = new HashMap<String, Object>();
			Boolean isNeetToSave = false;
			
			for (AVFile imageFile : imageFiles)
			{
				if (imageFile instanceof AVFile)
				{
					if (imageFile.getObjectId()==null)
					{
						isNeetToSave = true;
					}
				}
			}
			
			if (isNeetToSave)
			{
				new Thread(new Runnable() {
					
					@Override
					public void run() {
						for (AVFile imageFile : imageFiles)
						{
							if (imageFile instanceof AVFile)
							{
								if (imageFile.getObjectId()==null)
								{
									try {
										imageFile.save();
									} catch (AVException e) {
										boolCallback.done(e!=null, e);
										return;
//										e.printStackTrace();
									}
								}
							}	
						}	
						ALPhotoEngine.this.postPhoto(imageFiles, temperature, weatherCode, text, voiceFile, isShareToSinaWeibo, isShareToQQWeibo, latitude, longitude, boolCallback);
					}
				}).start();
				return;
			}
//			else
//			{
//				ArrayList<String> imageURLs = new ArrayList<String>(); 
//				for (AVFile imageFile : imageFiles)
//				{
//					if (imageFile instanceof AVFile)
//					{
//						imageURLs.add(imageFile.getUrl());
//					}
//				}
////				params.put("imageURLs", imageURLs);
//			}
			
			if (voiceFile!=null)
			{
				if (voiceFile.getObjectId()==null)
				{
					voiceFile.saveInBackground(new SaveCallback() {
				        @Override
				        public void done(AVException e) {
				        	ALPhotoEngine.this.postPhoto(imageFiles, temperature, weatherCode, text, voiceFile, isShareToSinaWeibo, isShareToQQWeibo, latitude, longitude, boolCallback);
				        }
				    });
					return;
				}
//				else
//				{
//					params.put("voiceURL",voiceFile.getUrl());
//				}
			}
			
//			if (text!=null) params.put("text", text);
//			params.put("temperature", temperature);
//			params.put("weatherCode", weatherCode);
//			params.put("latitude", latitude);
//			params.put("longitude", longitude);
			
//			AVCloud.callFunctionInBackground("upload_photo", params, new FunctionCallback<Object>() {
//		        public void done(Object object, AVException e) {
//		        	boolCallback.done(object!=null, e);
//		        }
//		    });
			
			final ArrayList<AVObject> photos = new ArrayList<AVObject>(); 
			for (AVFile imageFile : imageFiles)
			{
				final AVObject photo =  new AVObject("Photo");
				//坐标
		        photo.put("location", new AVGeoPoint(latitude, longitude));
		        //用户
		        photo.put("user", ALEngineConfig.user());
		        //内容
		        AVObject content =  new AVObject("Content");
		        if (voiceFile!=null) content.put("voiceURL",voiceFile.getUrl());
		        if (text!=null) content.put("text",text);
		        photo.put("content",content);
		        //图片
		        photo.put("originalURL",imageFile.getUrl());
		        photo.put("thumbnailURL",imageFile.getUrl()+"?imageMogr/auto-orient/thumbnail/200x");
		        
		        AsyncHttpClient client = new AsyncHttpClient();  
		        client.get(imageFile.getUrl()+"?imageInfo", new AsyncHttpResponseHandler() {  
		              
		            @Override  
		            public void onSuccess(String response) {  
		            	
//		            	stringCallback.done(response, null);
		            	try {
		            		JSONObject json = new JSONObject(response);
		            		photo.put("width", Integer.parseInt(json.getString("width")));
							photo.put("height", Integer.parseInt(json.getString("height")));
							
							AVQuery<AVObject> tempQ = new AVQuery<AVObject>("Temperature");
							tempQ.whereGreaterThan("maxTemperture",	temperature);
							tempQ.whereLessThanOrEqualTo("minTemperture",temperature);
							tempQ.findInBackground(new FindCallback<AVObject>() {
								
								public void done(List <AVObject> objects, AVException e) {
									
						        	photo.put("temperature",objects.get(0));
						        	
						        	AVQuery<AVObject> weatherQ = new AVQuery<AVObject>("WeatherType");
						        	weatherQ.whereEqualTo("weatherCode", weatherCode);
						        	weatherQ.findInBackground(new FindCallback<AVObject>() {
						        		
						        		public void done(List <AVObject> objects, AVException e) {
								        	photo.put("weatherType",objects.get(0));
								        	photos.add(photo);
								        	if (photos.size() == imageFiles.size())
								        	{
								        		AVObject.saveAllInBackground(photos, new SaveCallback() {
								        		       public void done(AVException e) {
								        		    	   boolCallback.done(e==null, e);
								        		       }
								        		   });
								        	}
								        }
								    });
						        }
								
						    });

						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
							boolCallback.done(e==null, null);
						}
		            }  
		        } ); 
			}
		}

		//查看用户的相册
		public void getPhotosForUser(final AVObject user, final int limit,  final Date lessThenDate, final CallBack listCallback) {    
			if (user==null || user.getObjectId()==null)
			{
				listCallback.done(null, new AVException(2, "参数错误"));
				return;
			}
			
			AVQuery<AVObject> photoQ = new AVQuery<AVObject>("Photo");
			ALEngineConfig._includeKeyWithPhoto(photoQ);
			ALEngineConfig._addLimit(limit, lessThenDate, photoQ);
			photoQ.whereEqualTo("user", user);
			photoQ.findInBackground(new FindCallback<AVObject>() {
			    public void done(List<AVObject> results, AVException e) {
			    	listCallback.done(results, e);
			      }
			    });
		}
		
		//查看 : 0.官方 1.最新街拍 2.最热街拍 3.附近街拍
		public void searchAllPhoto(final int type, final int limit,  final Date lessThenDate, final float latitude, final float longitude, final CallBack listCallback) {    
			
			AVQuery<AVObject> photoQ = new AVQuery<AVObject>("Photo");
			ALEngineConfig._includeKeyWithPhoto(photoQ);
			ALEngineConfig._addLimit(limit, lessThenDate, photoQ);
			switch (type) {
				case 0:
				{
					photoQ.whereEqualTo("isOfficial", true);
					photoQ.orderByDescending("updatedAt");
				}
					break;
				case 1:
				{
					photoQ.whereNotEqualTo("isOfficial", true);
					photoQ.orderByDescending("createdAt");
				}
					break;
				case 2:
				{
					photoQ.whereNotEqualTo("isOfficial", true);
					photoQ.orderByDescending("hot");
				}
					break;
				case 3:
				{
					photoQ.whereNotEqualTo("isOfficial", true);
					photoQ.whereNear("location", new AVGeoPoint(latitude, longitude));
				}
					break;
				default:
					break;
			}
			
			photoQ.findInBackground(new FindCallback<AVObject>() {
			    public void done(List<AVObject> results, AVException e) {
			    	listCallback.done(results, e);
			      }
			    });
		}
		
		//查找某张图片（根据天气）
		public void getPhotoForWeather(final float temperature, final int weatherCode, final Boolean isOfficial ,final float latitude, final float longitude, final CallBack objectCallback) {  
			
			AVQuery<AVObject> temperatureQ = new AVQuery<AVObject>("Temperature");
			temperatureQ.whereLessThanOrEqualTo("minTemperture", temperature);
			temperatureQ.whereGreaterThanOrEqualTo("maxTemperture", temperature);
			temperatureQ.getFirstInBackground(new GetCallback<AVObject>() {
				
				@Override
				public void done(final AVObject temperature, AVException e) {
					if (temperature!=null && e==null)
					{
						final AVQuery<AVObject> weatherTypeQ = new AVQuery<AVObject>("WeatherType");
						weatherTypeQ.whereEqualTo("weatherCode", weatherCode);
						weatherTypeQ.getFirstInBackground(new GetCallback<AVObject>() {
							
							@Override
							public void done(final AVObject weatherType, AVException e) {
								if (weatherType!=null && e==null)
								{
									AVQuery<AVObject> photoQ = new AVQuery<AVObject>("Photo");
									photoQ.whereEqualTo("temperature",temperature);
									photoQ.whereEqualTo("weatherName", weatherType.get("name"));
									
									ALEngineConfig._includeKeyWithPhoto(photoQ);
									photoQ.limit(10);
									if (isOfficial)
									{
										photoQ.whereEqualTo("isOfficial", true);
									}
									else if (latitude==0 && longitude==0)
									{
										photoQ.whereNotEqualTo("isOfficial", true);
										photoQ.orderByDescending("createdAt");
									}
									else
									{
										photoQ.whereNotEqualTo("isOfficial", true);
										photoQ.whereNear("location", new AVGeoPoint(latitude, longitude));
									}
									photoQ.findInBackground(new FindCallback<AVObject>() {
										
										@Override
										public void done(List<AVObject> photos, AVException e) {
											if (photos!=null && photos.size()!=0 && e==null)
											{
												objectCallback.done(photos.get(new Random().nextInt(photos.size())), e);
											}	
											else
											{
												objectCallback.done(temperature, e);
											}
										}
									});
								}
								else
								{
									objectCallback.done(temperature, e);
								}
							}
						});
					}
					else
					{
						objectCallback.done(temperature, e);
					}
				}
			});
 
		}
		
		//评论照片
		public void commentPhoto(final AVObject photo, final String text,  final AVFile voiceFile, final CallBack boolCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				boolCallback.done(false, new AVException(1, "没有登录"));
				return;
			}
			
			if (text==null && voiceFile==null)
			{
				boolCallback.done(false, new AVException(2, "参数错误"));
				return;
			}
			
//			HashMap <String,Object> params = new HashMap<String, Object>();
			
			AVObject content =  new AVObject("Content");
			
			if (voiceFile!=null)
			{
				if (voiceFile.getObjectId()==null)
				{
					voiceFile.saveInBackground(new SaveCallback() {
				        @Override
				        public void done(AVException e) {
				        	ALPhotoEngine.this.commentPhoto(photo, text, voiceFile, boolCallback);
				        }
				    });
					return;
				}
//				else
//				{
//					content.put("voiceURL",voiceFile.getUrl());
//				}
			}
			
			if (text!=null) content.put("text",text);

			AVObject comment =  new AVObject("Comment");
			if (photo!=null) comment.put("photo",photo);
			comment.put("content",content);
			comment.put("user",ALEngineConfig.user());
			comment.saveInBackground(new SaveCallback() {
		        @Override
		        public void done(AVException e) {
		        	if (e==null)
		        	{
		        		photo.increment("hot");
		    			photo.saveEventually();
		        	}
		        	boolCallback.done(e==null, e);
		        }
		    });
	
		}
		
		//查看照片评论
		public void getCommentListFromPhoto(final AVObject photo, final int limit,  final Date lessThenDate, final CallBack listCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				listCallback.done(null, new AVException(1, "没有登录"));
				return;
			}
			
			AVQuery<AVObject> commentQ = new AVQuery<AVObject>("Comment");
			ALEngineConfig._addLimit(limit,lessThenDate,commentQ);
			ALEngineConfig._includeKeyWithComment(commentQ);
			commentQ.whereEqualTo("photo",photo);
			commentQ.findInBackground(new FindCallback<AVObject>() {
			    public void done(List<AVObject> results, AVException e) {
			    	listCallback.done(results, e);
			      }
			    });
		}
		
		//查看照片评论
		public void getCommenCountFromPhoto(final AVObject photo, final CallBack intCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				intCallback.done(0, new AVException(1, "没有登录"));
				return;
			}
			
			if (photo==null || photo.getObjectId()==null)
			{
				intCallback.done(false, new AVException(2, "参数错误"));
				return;
			}
			
			AVQuery<AVObject> commentQ = new AVQuery<AVObject>("Comment");
			commentQ.whereEqualTo("photo",photo);
			commentQ.countInBackground(new CountCallback() {
				  public void done(int count, AVException e) {
					  intCallback.done(count, e);
					  }
				});
		}
		
		//收藏照片
		public void faviconPhoto(final AVObject photo, final CallBack boolCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				boolCallback.done(0, new AVException(1, "没有登录"));
				return;
			}
			
			if (photo==null || photo.getObjectId()==null)
			{
				boolCallback.done(false, new AVException(2, "参数错误"));
				return;
			}
			
			ALEngineConfig.user().getRelation("faviconPhotos").add(photo);
			ALEngineConfig.user().saveInBackground(new SaveCallback() {
		        @Override
		        public void done(AVException e) {
		        	if (e==null)
		        	{
		        		photo.increment("hot");
		        		photo.getRelation("faviconUsers").add(ALEngineConfig.user());
		    			photo.saveInBackground(new SaveCallback() {
		    		        @Override
		    		        public void done(AVException e) {
		    		        	boolCallback.done(e==null, e);
		    		        }
		    		    });
		        	}
		        	boolCallback.done(e==null, e);
		        }
		    });
		}
		
		//取消收藏照片
		public void unfaviconPhoto(final AVObject photo, final CallBack boolCallback) {    
			if (!ALEngineConfig.isLoggedIn())
			{
				boolCallback.done(0, new AVException(1, "没有登录"));
				return;
			}
			
			if (photo==null || photo.getObjectId()==null)
			{
				boolCallback.done(false, new AVException(2, "参数错误"));
				return;
			}
			
			ALEngineConfig.user().getRelation("faviconPhotos").remove(photo);
			ALEngineConfig.user().saveInBackground(new SaveCallback() {
		        @Override
		        public void done(AVException e) {
		        	if (e==null)
		        	{
		        		photo.increment("hot",-1);
		        		photo.getRelation("faviconUsers").remove(ALEngineConfig.user());
		    			photo.saveInBackground(new SaveCallback() {
		    		        @Override
		    		        public void done(AVException e) {
		    		        	boolCallback.done(e==null, e);
		    		        }
		    		    });
		        	}
		        	boolCallback.done(e==null, e);
		        }
		    });
		}
		
		//查看照片的收藏者
		public void getFaviconUserListFromPhoto(final AVObject photo, final CallBack listCallback) {    
			ALEngineConfig._commomRelationQueryRequest(photo, "faviconUsers", false, listCallback);		
		}
		
		//查看照片的收藏者数
		public void getFaviconUserCountFromPhoto(final AVObject photo, final CallBack listCallback) {    
			ALEngineConfig._commomRelationQueryRequest(photo, "faviconUsers", true, listCallback);		
		}
		
		//查看我收藏的照片
		public void getMyFaviconPhotoList(final CallBack listCallback) {    
			ALEngineConfig._commomRelationQueryRequest(ALEngineConfig.user(), "faviconPhotos", false, listCallback);		
		}
		
		//查看我收藏的照片数
		public void getMyFaviconPhotoCount(final CallBack listCallback) {    
			ALEngineConfig._commomRelationQueryRequest(ALEngineConfig.user(), "faviconPhotos", true, listCallback);		
		}
}
