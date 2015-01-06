class Image
    extend CarrierWave::Mount
    attr_accessor :file
    mount_uploader :file, ImageUploader

    def save
        self.store_file!
    end
end