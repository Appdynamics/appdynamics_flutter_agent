/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:io';

var localServerURL = "http://${Platform.isIOS ? "localhost" : "10.0.2.2"}:9001";

final collectors = {
  "Local": {"url": localServerURL, "screenshotURL": localServerURL},
  "Shadow Master": {
    "url": "https://eum-shadow-master-col.saas.appd-test.com",
    "screenshotURL": "https://eum-shadow-master-image.saas.appd-test.com"
  },
  "Shadow": {
    "url": "https://shadow-eum-col.appdynamics.com",
    "screenshotURL": "https://shadow-eum-image.appdynamics.com"
  },
  "North America": {
    "url": "https://mobile.eum-appdynamics.com",
    "screenshotURL": "https://mobile.eum-appdynamics.com"
  },
  "Europe": {
    "url": "https://fra-col.eum-appdynamics.com",
    "screenshotURL": "https://fra-col.eum-appdynamics.com"
  },
  "APAC": {
    "url": "https://syd-col.eum-appdynamics.com",
    "screenshotURL": "https://syd-col.eum-appdynamics.com"
  },
};
