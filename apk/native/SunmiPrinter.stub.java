package tj.activbank.qr;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

/**
 * Заглушка плагина печати — компилируется, когда в apk/libs нет
 * printerlibrary.aar от Sunmi. Приложение собирается и работает,
 * печать сообщает «Принтер не найден».
 *
 * Чтобы включить настоящую печать: положить printerlibrary.aar
 * в apk/libs/ и пересобрать. CI сам подхватит полную версию.
 */
@CapacitorPlugin(name = "SunmiPrinter")
public class SunmiPrinter extends Plugin {

    @PluginMethod
    public void isAvailable(PluginCall call) {
        JSObject res = new JSObject();
        res.put("available", false);
        res.put("serial", (String) null);
        call.resolve(res);
    }

    @PluginMethod
    public void printReceipt(PluginCall call) {
        call.reject("printer-unavailable");
    }
}
