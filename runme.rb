require './signature_test'


key = '<uid>/<subtenant_id>'
secret = '<secret_key>'
url = '<cloud storage hostname>'
filename = '<filename in local directory>'

test = Skyscape::Atmos::Test::Signature.new(key,secret,url,filename)


