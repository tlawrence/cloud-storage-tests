#Test for Skyscape CLoud Storage (Object Store)

##signature test

install the necessary gems with:
```bundle install```

Edit the "runme.rb" to include your Cloud Storage credentials

Add a test file to the local directory and add the filename to runme.rb
n.b the file must have a recognised file extension or the 'files.head'
method fails with a 500 error.

run the test with:
```bundle exec ruby runme.rb```


The script will:
- perform an MD5 on the local file
- upload the file to cloud storage
- perform an MD5 on the file stored in Cloud Storage
- download the file to filename_downloaded
- perform an MD5 on filename_downloaded
- delete the file from cloud storage
- delete the locally downloaded file
