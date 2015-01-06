CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAIURRKMJWYFNPRI5A',
    :aws_secret_access_key  => '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',
  }
  config.fog_directory  = 'jeetflow'
  config.fog_public     = false
  config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"}
end
