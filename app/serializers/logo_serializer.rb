class LogoSerializer < ApplicationSerializer
  attributes :id, :width, :height, :color

  attribute :src do
    attachment_path(object, :file)
  end

  attribute :preview_url do
    attachment_path(object, :file, :fill, 272, 272)
  end
end
