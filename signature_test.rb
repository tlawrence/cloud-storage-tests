require 'fog/aws'
require 'digest/md5'

module Skyscape
  module Atmos
    module Test
      class Signature
        def initialize(key,secret,url,filename)
            params = {
              :aws_access_key_id => key,
              :aws_secret_access_key => secret,
              :host => url,
              :port => '8443',
              :scheme => 'https',
              :path_style => true,
              :aws_signature_version=> 2
            }

          #connect to Cloud Storage
          s = Fog::Storage::AWS.new(params)



          #create the directory
          s.directories.create({:key=>'signature-test-bucket'})



          #get a directory
          opts = {
            :max_keys => 1,
            :delimeter => '%2F'
          }

          dir =  s.directories.get('signature-test-bucket',opts)



          #get local  file signature
          puts "Local File Signature: #{Digest::MD5.file(filename).to_s}"



          #upload a file
          file_detail = {
            :key => filename,
            :body => File.open(filename),
            :public => false
          }

          puts "Uploading File #{filename}"
          file = dir.files.create(file_detail)
          puts "File Uploaded Succesfully"



          #check remote signature
          file = dir.files.head(filename)
          puts "Remote File Signature On Cloud Storage: #{file.etag}"



          #download it
          new_filename = "#{file.key}_downloaded"
          puts "Downloading File To #{new_filename}"
          File.open(new_filename,'w') do |f|
            f.write(file.body)
          end
          puts "File #{new_filename} Downladed Succesfully"



          #check signature of downloaded file
          puts "Downloaded File Signature: #{Digest::MD5.file(new_filename).to_s}"



          #delete remote file
          puts "Deleting File From Cloud Storage"
          file.destroy



          #delete local file
          puts "Deleting Downloaded File"
          File.delete(new_filename)
       end
      end
    end
  end
end

