package tj.activbank.qr;

import android.os.Bundle;
import android.view.WindowManager;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        registerPlugin(SunmiPrinter.class);
        super.onCreate(savedInstanceState);
        // POS-режим: экран не гаснет, пока приложение открыто.
        // (в манифесте android:keepScreenOn не существует — только здесь)
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }
}
