class ScreenshotSerializer < ApplicationSerializer
  attributes :id, :width, :height, :description, :color

  has_many :sources

  attribute :resource do
    object.model_name.collection
  end

  attribute :src do
    attachment_path(object, :file)
  end

  attribute :landscape_preview_url do
    attachment_path(object, :file, :fill, 220, 145)
  end

  attribute :portrait_preview_url do
    attachment_path(object, :file, :fill, 272, 340)
  end
end
