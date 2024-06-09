# NSFilePresenterBugSampleProject

NSFilePresenter Does Not Seem to Work on watchOS on Device

Hi, I submitted a Feedback Report (FB13820685) but I thought I would ask here as well because maybe I am using the framework wrong.

I am using NSFilePresenter to monitor changes to a folder. On macOS, iOS (simulator), iOS (device), and watchOS (simulator) it works fine. However when running on watchOS 10.5 on device, it does not appear to work at all.

I created a sample project that reproduces this problem. Am I doing something wrong? It seems like this is too basic of a problem for it to be actually broken on all Apple Watches. Remember, it only doesn't work on watchOS on device. It works on all other platforms.