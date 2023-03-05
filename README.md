# cached
 
This is the example project for the [Enpoints-Caching fork](https://github.com/marckrenn/Endpoints/tree/caching).

I still plan to do a proper demonstration of this thing at some point but for now …

## tf is Endpoints-caching?
* IMO improves integration between Endpoints and AsyncReactor
* Instantly loads cached responses into state, then makes the call, updates cache on response → no more blank views before the reactor/view receives the response 🎉 
* Keeps cached response in case of an Error (timeout, ec.) in AsyncLoad → no blank views onError
* Allows for pre-caching of calls
* improves and extents AsyncLoad greatly (with Error-state, origin of response, age of response etc. see [AsyncLoad](https://github.com/marckrenn/cached/blob/main/Network/AsyncLoad.swift) and [StateBarView](https://github.com/marckrenn/cached/blob/main/StateBarView.swift))
* Integrates placeholder support right into AsyncLoad

## Getting started
The best entry point to get started is the [ProfileReactor](https://github.com/marckrenn/cached/blob/main/Profiles/ProfilesReactor.swift).

For demonstration and development purposes I'd suggested using Apple's [Network Link Conditioner](https://developer.apple.com/download/more/?q=Additional%20Tools) to throttle internet speed / package loss on your mac & iOS simulator:
* "100% loss" will timeout the call (so you'd see the cache-onError behavior)
* "Very bad network" or ![signal-2023-03-05-124435_002](https://user-images.githubusercontent.com/2648540/222959412-4a277eb6-b917-488c-9260-6ee8be34d8d2.png) will magnify the benefit of instantly showing the cache

Help, feedback, MRs are very welcomed 😊

## TODOs:
* Do a pass over the [Enpoints-Caching fork](https://github.com/marckrenn/Endpoints/tree/caching) code
* Decide if to drop backwards compat
* Decide if to make this a standalone package
