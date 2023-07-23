/*******************************************************************************
 *                                                                             *
 *  Copyright (C) 2017 by Max Lv <max.c.lv@gmail.com>                          *
 *  Copyright (C) 2017 by Mygod Studio <contact-shadowsocks-android@mygod.be>  *
 *                                                                             *
 *  This program is free software: you can redistribute it and/or modify       *
 *  it under the terms of the GNU General Public License as published by       *
 *  the Free Software Foundation, either version 3 of the License, or          *
 *  (at your option) any later version.                                        *
 *                                                                             *
 *  This program is distributed in the hope that it will be useful,            *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 *  GNU General Public License for more details.                               *
 *                                                                             *
 *  You should have received a copy of the GNU General Public License          *
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.       *
 *                                                                             *
 *******************************************************************************/

package com.appgo.appgopro.services

import android.app.KeyguardManager
import android.content.Context
import android.graphics.drawable.Icon
import android.service.quicksettings.Tile
import android.support.annotation.RequiresApi
import com.appgo.appgopro.AppGoApplication.Companion.app
import com.appgo.appgopro.AppGoConnection
import com.appgo.appgopro.R
import com.appgo.appgopro.aidl.IAppGoService
import com.appgo.appgopro.aidl.IAppGoServiceCallback
import com.appgo.appgopro.database.DataStore
import android.service.quicksettings.TileService as BaseTileService

@RequiresApi(24)
class TileService : BaseTileService(), AppGoConnection.Interface {
    private val iconIdle by lazy { Icon.createWithResource(this, R.drawable.logo_mark) }
    private val iconBusy by lazy { Icon.createWithResource(this, R.drawable.logo_mark) }
    private val iconConnected by lazy { Icon.createWithResource(this, R.drawable.logo_mark) }
    private val keyguard by lazy { getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager }

    override val serviceCallback: IAppGoServiceCallback.Stub by lazy {
        @RequiresApi(24)
        object : IAppGoServiceCallback.Stub() {
            override fun stateChanged(state: Int, profileName: String?, msg: String?) {
                val tile = qsTile ?: return
                var label: String? = null
                when (state) {
                    BaseService.STOPPED -> {
                        tile.icon = iconIdle
                        tile.state = Tile.STATE_INACTIVE
                    }
                    BaseService.CONNECTED -> {
                        tile.icon = iconConnected
                        if (!keyguard.isDeviceLocked) label = profileName
                        tile.state = Tile.STATE_ACTIVE
                    }
                    else -> {
                        tile.icon = iconBusy
                        tile.state = Tile.STATE_UNAVAILABLE
                    }
                }
                tile.label = label ?: getString(R.string.app_name)
                tile.updateTile()
            }
            override fun trafficUpdated(txRate: Long, rxRate: Long, txTotal: Long, rxTotal: Long) { }
            override fun trafficPersisted(profileid: Int) { }
        }
    }

    override fun onServiceConnected(service: IAppGoService) =
            serviceCallback.stateChanged(service.state, service.profileName, null)

    override fun onStartListening() {
        super.onStartListening()
        connection.connect()
    }
    override fun onStopListening() {
        super.onStopListening()
        connection.disconnect()
    }

    override fun onClick() {
        if (isLocked && !DataStore.directBootAware) unlockAndRun(this::toggle) else toggle()
    }

    private fun toggle() {
        val service = connection.service ?: return
        when (service.state) {
            BaseService.STOPPED -> app.startService()
            BaseService.CONNECTED -> app.stopService()
        }
    }
}
