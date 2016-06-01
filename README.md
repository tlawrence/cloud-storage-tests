#Test for Skyscape Cloud Storage (Object Store)

##signature test

1. install the necessary gems with: ```bundle install```

2. Edit the "runme.rb" to include your Cloud Storage credentials

3. Add a test file to the local directory and add the filename to runme.rb
..*   **n.b the file must have a recognised file extension or the 'files.head'
method fails with a 500 error.**

4. run the test with: ```bundle exec ruby runme.rb```


The script will:
- perform an MD5 on the local file
- upload the file to cloud storage
- perform an MD5 on the file stored in Cloud Storage
- download the file to filename_downloaded
- perform an MD5 on filename_downloaded
- delete the file from cloud storage
- delete the locally downloaded file
