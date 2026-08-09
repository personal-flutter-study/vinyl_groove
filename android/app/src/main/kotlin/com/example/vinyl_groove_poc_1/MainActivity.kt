package com.example.vinyl_groove_poc_1

import android.widget.Toast
import com.google.zxing.BinaryBitmap
import com.google.zxing.MultiFormatReader
import com.google.zxing.PlanarYUVLuminanceSource
import com.google.zxing.common.HybridBinarizer
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


                "scan" -> {

                    try {
                        val bytes = call.argument<ByteArray>("bytes")
                        val width = call.argument<Int>("width") ?: 0;
                        val height = call.argument<Int>("height") ?: 0;
                        val row = call.argument<Int>("rowStride") ?: width

                        if (bytes != null && width > 0 && height > 0) {
                            // 1. rowStride 패딩을 제거한 순수 Y 데이터 추출
                            val cleanYData = ByteArray(width * height)
                            for (y in 0 until height) {
                                System.arraycopy(bytes, y * row, cleanYData, y * width, width)
                            }

                            // 2. 세로 모드 대응을 위해 이미지를 90도 회전 (필요 시)
                            val rotatedData = ByteArray(width * height)
                            for (y in 0 until height) {
                                for (x in 0 until width) {
                                    rotatedData[x * height + (height - 1 - y)] =
                                        cleanYData[y * width + x]
                                }
                            }


                            PlanarYUVLuminanceSource(
                                rotatedData,
                                height,
                                width,
                                0,
                                0,
                                height,
                                width,
                                false
                            ).let { src ->
                                BinaryBitmap(HybridBinarizer(src)).let { img ->


                                    MultiFormatReader().decode(img).let { res ->
                                        result.success(res.text)
                                    }
                                }
                            }

                        }
                    } catch (e: Exception) {
                        result.success(null)
                    }
                }
            }
        }


    }

}
