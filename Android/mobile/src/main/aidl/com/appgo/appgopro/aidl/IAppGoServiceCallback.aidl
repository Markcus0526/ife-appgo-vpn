package com.appgo.appgopro.aidl;

interface IAppGoServiceCallback {
  oneway void stateChanged(int state, String profileName, String msg);
  oneway void trafficUpdated(long txRate, long rxRate, long txTotal, long rxTotal);
  // Traffic data has persisted to database, listener should refetch their data from database
  oneway void trafficPersisted(int profileId);
}
