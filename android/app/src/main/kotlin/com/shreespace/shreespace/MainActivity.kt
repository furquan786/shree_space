package com.shreespace.shreespace
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import com.example.otpless_flutter.OtplessFlutterPlugin



class MainActivity: FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        //window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)

         fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
            super.onActivityResult(requestCode, resultCode, data)
            val plugin = flutterEngine?.plugins?.get(OtplessFlutterPlugin::class.java)
            if (plugin is OtplessFlutterPlugin) {
                plugin.onActivityResult(requestCode, resultCode, data)
            }
        }
    }
  /* override fun onNewIntent(intent: Intent) {
       super.onNewIntent(intent)
       val plugin = flutterEngine?.plugins?.get(OtplessFlutterPlugin::class.java)
       if (plugin is OtplessFlutterPlugin) {
           plugin.onNewIntent(intent)
       }
   }

    override fun onBackPressed() {
        val plugin = flutterEngine?.plugins?.get(OtplessFlutterPlugin::class.java)
        if (plugin is OtplessFlutterPlugin) {
            if (plugin.onBackPressed()) return
        }
        // handle other cases
        super.onBackPressed()
    }*/

}

