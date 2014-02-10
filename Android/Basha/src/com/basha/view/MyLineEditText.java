package com.basha.view;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.widget.EditText;

public class MyLineEditText extends EditText {
	private Paint linePaint;

	private float margin;

	private int paperColor;

	public MyLineEditText(Context context) {
		super(context);
	}

	public MyLineEditText(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.linePaint = new Paint();
		linePaint.setColor(Color.GRAY);
	}

	@Override
	protected void onDraw(Canvas paramCanvas) {

		paramCanvas.drawColor(this.paperColor);

		int i = getLineCount();

		int j = getHeight();

		int k = getLineHeight();

		int m = 1 + j / k;

		if (i < m)

			i = m;

		int n = getCompoundPaddingTop();

		paramCanvas.drawLine(0.0F, n, getRight(), n, this.linePaint);

		for (int i2 = 0;; i2++) {

			if (i2 >= i) {

				setPadding(10 + (int) this.margin, 0, 0, 0);

				super.onDraw(paramCanvas);

				paramCanvas.restore();

				return;

			}

			n += k;
//			//不会第一条线
//             if(i2 == 0)
//            	continue;
			paramCanvas.drawLine(0.0F, n, getRight(), n, this.linePaint);

			paramCanvas.save();

		}

	}
}