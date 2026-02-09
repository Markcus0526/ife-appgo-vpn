package com.appgo.appgopro.aidl;

import com.appgo.appgopro.aidl.IAppGoServiceCallback;

interface IAppGoService {
  int getState();
  String getProfileName();

  oneway void registerCallback(IAppGoServiceCallback cb);
  oneway void startListeningForBandwidth(IAppGoServiceCallback cb);
  oneway void stopListeningForBandwidth(IAppGoServiceCallback cb);
  oneway void unregisterCallback(IAppGoServiceCallback cb);
}
