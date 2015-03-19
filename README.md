# xiaoyifan-MPCS51030-Winter-2015-Project
MPCS51030-Winter-2015-Project created for xiaoyifan

The projects is basically designed to record the purchasing behavior of the user. 
You can add items to the list as records, which contains title, description, pics, date, and even location. 
Then you can browse your records. 
Users could see the data visualized as pie Chart by category, and bar Chart by days, with customized animation details. 
burger button triggers the sidebar menus,which allows you to browse the gallery, developer info. 
Data can be fetched from your Dropbox account, and your new records will be synced, too.

Attention:
the barChart data is not linked to the data base, the data is stored in the timeline Array, but for the visualized effect, I just 
choose random number as much as posisble to make the graph looks nice. 
The data merging strategy from Dropbox that we are using is just appeding the local data and the data on the Cloud, I just intended to
  test if the data processing would work. 
  
Our data storage are all processed in the plist file, which cause the data processing on the items.plist could be relatively slow, altough 
it will work successfully. But I'm gonna modify the data structure and store the pics separately as Andrew showed me on the DayOne application. 
The app would have better experiecne. 

All details mentioned above, should be modified and improved for submitting to App Store
