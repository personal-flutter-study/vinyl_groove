package com.example.vinyl_groove_poc_1

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    lateinit var channelM: MethodChannel


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)



        channelM = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.vinyl_groove_poc_1_m"
        )


        channelM.setMethodCallHandler { call, result ->
            when (call.method) {

                "t" -> {
                    Toast.makeText(this, call.argument<String>("m"), Toast.LENGTH_SHORT).show()
                    result.success(true)
                }
            }
        }


    }

}
