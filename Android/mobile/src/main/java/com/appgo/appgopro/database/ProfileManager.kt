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

package com.appgo.appgopro.database

import android.util.Log
import com.appgo.appgopro.models.AGProfile
import java.sql.SQLException

/**
 * SQLExceptions are not caught (and therefore will cause crash) for insert/update transactions
 * to ensure we are in a consistent state.
 */
object ProfileManager {
    private const val TAG = "ProfileManager"

    @Throws(SQLException::class)
    fun createProfile(p: AGProfile? = null, proname: String): Profile {
        val profile = Profile()
        profile.id = 0
        profile.name = proname
        profile.remotePort
        profile.ip = p!!.ip!!
        profile.remotePort = p!!.remotPort
        profile.password = p.password!!
        profile.method = p.method!!
        profile.route = p.route
        profile.remoteDns = p.remoteDns
        profile.proxyApps = p.proxyApps
        profile.bypass = p.bypass
        profile.udpdns = p.udpdns
        profile.ipv6 = p.ipv6
        profile.individual = p.individual
        profile.tx = p.tx
        profile.rx = p.rx
        profile.userOrder = 0;

        var list = getAllProfiles()
        for (p in list!!) {
            delProfile(p.id)
        }
        PrivateDatabase.profileDao.create(profile)
        PrivateDatabase.profileDao.updateId(profile, 1)
        //list = getAllProfiles()

        return profile
    }

    /**
     * Note: It's caller's responsibility to update DirectBoot profile if necessary.
     */
    @Throws(SQLException::class)
    fun updateProfile(profile: Profile) = PrivateDatabase.profileDao.updateSafe(profile)

    fun getProfile(id: Int): Profile? = try {
        PrivateDatabase.profileDao.queryByIdSafe(id)
    } catch (ex: SQLException) {
        Log.e(TAG, "getProfile", ex)
        null
    }

    @Throws(SQLException::class)
    fun delProfile(id: Int) {
        PrivateDatabase.profileDao.deleteByIdSafe(id)

    }

    fun getFirstProfile(): Profile? = try {
        safeWrapper {
            PrivateDatabase.profileDao.query(
                    PrivateDatabase.profileDao.queryBuilder().limit(1L).prepare()).singleOrNull()
        }
    } catch (ex: SQLException) {
        Log.e(TAG, "getFirstProfile", ex)
        null
    }

    fun getAllProfiles(): List<Profile>? = try {
        safeWrapper {
            PrivateDatabase.profileDao.query(
                    PrivateDatabase.profileDao.queryBuilder().orderBy("userOrder", true).prepare())
        }
    } catch (ex: SQLException) {
        Log.e(TAG, "getAllProfiles", ex)
        null
    }
}
