class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick #미니매직 젬 깔면 커맨트 아웃 함
  include ApplicationController::ApplicationHelper # 커런트유저 불러오기 위해 씀

  # Choose what kind of storage to use for this uploader:
  storage :file # 로컬일때 활성화
  # storage :fog # aws쓸 때 활성화

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir # s3쓸 때 커맨트 아웃
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 버전 thumb 커맨트 아웃해야함
  version :thumb do
    process resize_to_fit: [50, 50]
  end

  #스몰버전
  version :small do
    process resize_to_fit: [400, 600]
  end

end
