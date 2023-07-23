package com.appgo.appgopro.views

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ShortcutManager
import android.os.Build
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.support.v7.widget.Toolbar
import android.text.TextUtils
import com.appgo.appgopro.R
import com.appgo.appgopro.supers.SuperActivity
import com.appgo.appgopro.utils.AGConstants
import com.google.zxing.Result
import me.dm7.barcodescanner.zxing.ZXingScannerView

class QRScannerActivity: SuperActivity(), ZXingScannerView.ResultHandler {

    private var scannerView: ZXingScannerView? = null

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == PERMISSIONS_REQUEST_CAMERA) {
            // If request is cancelled, the result arrays are empty.
            if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                scannerView!!.setResultHandler(this)
                scannerView!!.startCamera()
            } else {
                showErrorDialog(getString(R.string.add_profile_scanner_permission_required))
                finish()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_qrscanner)
        val toolbar = findViewById<Toolbar>(R.id.toolbar)
        toolbar.setTitle(title)
        toolbar.setNavigationIcon(R.drawable.abc_ic_ab_back_material)
        toolbar.setNavigationOnClickListener({
            super.onClickedBackSystemButton()
        })
        scannerView = findViewById<ZXingScannerView>(R.id.scanner)
        if (Build.VERSION.SDK_INT >= 25)
            getSystemService(ShortcutManager::class.java).reportShortcutUsed("scan")
    }

    override fun onResume() {
        super.onResume()
        val permissionCheck = ContextCompat.checkSelfPermission(this,
                android.Manifest.permission.CAMERA)
        if (permissionCheck == PackageManager.PERMISSION_GRANTED) {
            scannerView!!.setResultHandler(this) // Register ourselves as a handler for scan results.
            scannerView!!.startCamera()          // Start camera on resume
        } else {
            ActivityCompat.requestPermissions(this,
                    arrayOf(Manifest.permission.CAMERA), PERMISSIONS_REQUEST_CAMERA)
        }
    }

    override fun onPause() {
        super.onPause()
        scannerView!!.stopCamera()           // Stop camera on pause
    }

    override fun handleResult(rawResult: Result) {
        val uri = rawResult.text
        if (!TextUtils.isEmpty(uri)) {
            val intent = Intent(AGConstants.BROADCAST_SIGNAL_QRCODE_SCANNED)
            intent.putExtra("message", AGConstants.BROADCAST_SIGNAL_QRCODE_SCANNED)
            intent.putExtra("content", uri)
            setResult(Activity.RESULT_OK, intent)
            finish()
        } else super.onClickedBackSystemButton()
    }

    companion object {
        private val PERMISSIONS_REQUEST_CAMERA = 1

        fun showQRScannerActivity(parentActivity: SuperActivity, requestCode: Int) {
            parentActivity.pushNewActivityAnimated(QRScannerActivity::class.java, SuperActivity.AnimConst.ANIMDIR_NONE, 0, requestCode)
        }
    }
}
