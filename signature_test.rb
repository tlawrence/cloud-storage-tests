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
          local_sig = Digest::MD5.file(filename).to_s
          puts "Local File Signature: #{local_sig}"



          #upload a file
          file_detail = {
            :key => filename,
            :body => File.open(filename),
            :public => false
          }

          puts "Uploading File #{filename}"
          file = dir.files.create(file_detail)
          puts "File Uploaded Succesfully"



          #add some metadata
          puts "Adding Metadata"
          file.metadata={'x-amz-meta-monkey' => 'tennis'}
          file.save
          puts "Metadata Saved"



          #read the metadata
          file = dir.files.head(filename)
          file.metadata.each {|k,v| puts "Metadata Entry: #{k} = #{v}" if k =~ /^x-amz-meta/}



          #check remote signature
          file = dir.files.head(filename)
          remote_sig = file.etag
          puts "Remote File Signature On Cloud Storage: #{remote_sig}"



          #download it
          new_filename = "#{file.key}_downloaded"
          puts "Downloading File To #{new_filename}"
          File.open(new_filename,'w') do |f|
            f.write(file.body)
          end
          puts "File #{new_filename} Downladed Succesfully"



          #check signature of downloaded file
          downloaded_sig = Digest::MD5.file(new_filename).to_s
          puts "Downloaded File Signature: #{downloaded_sig}"



          #delete remote file
          puts "Deleting File From Cloud Storage"
          file.destroy



          #delete local file
          puts "Deleting Downloaded File"
          File.delete(new_filename)

          puts "\nSignatures:\n\nLocal: #{local_sig}\nRemote: #{remote_sig}\nDownloaded: #{downloaded_sig}\n\n"
          if remote_sig == local_sig && downloaded_sig == local_sig then
            puts "ALL SIGNATURES MATCHED"
          else
            puts "SOME SIGNATURES DID NOT MATCH"
          end
       end
      end
    end
  end
end

