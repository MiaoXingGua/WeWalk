package com.basha.util;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.util.Log;

public class BitmapUtils {
	
	public static Bitmap getCircleNumBitmap(Context context ,int weight , int height,String mcolor,boolean isfill) {
		Log.i("MyTag", "--------------"+weight+"---"+height);
		Bitmap output = Bitmap.createBitmap(weight, height, Config.ARGB_8888);
		Canvas canvas = new Canvas(output);
		final Paint paint = new Paint();
		paint.setAntiAlias(true);
		paint.setColor(Color.parseColor("#00000000"));
		paint.setStrokeWidth((float) DensityUtil.dip2px(
				context, 2));
		paint.setStyle(Paint.Style.STROKE);
		if(isfill){
			paint.setStyle(Paint.Style.FILL);
		}
		canvas.drawRect(0, 0, weight, height, paint);
//		paint.setColor(Color.parseColor("#B7FFDC"));
		paint.setColor(Color.parseColor(mcolor));
		canvas.drawCircle(weight / 2, height / 2,
				height / 2 - DensityUtil.dip2px(context, 1), paint);
		paint.setStrokeWidth(2);
		return output;

	}
	public static Bitmap getCircleStrokbitmap(Context context,Bitmap mbitmap,int width,int strok,String strokcolor){
		// 将圆形图片,返回Bitmap
			int x = width-2*strok;

			// 获得图片的宽高
			int mwidth = mbitmap.getWidth();
			int mheight = mbitmap.getHeight();

			// 计算缩放比例
			float scale = (mwidth > mheight) ? ((float) x / mheight)
					: ((float) x / mwidth);

			// 取得想要缩放的matrix参数
			Matrix matrix = new Matrix();
			matrix.postScale(scale, scale);
			// 得到新的图片
			Bitmap bitmap = Bitmap.createBitmap(mbitmap, 0, 0, mwidth, mheight,
					matrix, true);

			Bitmap output = Bitmap.createBitmap(width, width, Config.ARGB_8888);
			Canvas canvas = new Canvas(output);
	        
			final int color = 0xB7FFDC;
			final Paint paint = new Paint();

			// 根据原来图片大小画一个矩形
			// final Rect rect = new Rect(0, 0, bitmap.getWidth(),
			// bitmap.getHeight());
			// final Rect srcrect = new Rect(bitmap.getWidth() / 2 - x / 2,
			// bitmap.getWidth() / 2 - x / 2, bitmap.getWidth() / 2 + x,
			// bitmap.getWidth() / 2 + x);
			final Rect rect = new Rect(0, 0, width, width);

			paint.setAntiAlias(true);
				paint.setColor(Color.parseColor(strokcolor));
			// 画出一个圆
			canvas.drawCircle(width / 2, width / 2, width / 2, paint);

			// canvas.translate(-25, -6);
			// 取两层绘制交集,显示上层
			paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
			// 将图片画上去
			canvas.drawBitmap(bitmap, rect, rect, paint);
			//
			paint.setStrokeWidth(strok*2);

			paint.setStyle(Paint.Style.STROKE);
			paint.setXfermode(new PorterDuffXfermode(Mode.SRC_OVER));
			canvas.drawCircle(width / 2, width / 2,
					width / 2 - strok, paint);
			paint.setColor(Color.parseColor("#d9d6c3"));
			paint.setStrokeWidth(1);
			canvas.drawCircle(width / 2, width / 2,
					width / 2 , paint);

			// 返回Bitmap对象
			return output;
		}
}
