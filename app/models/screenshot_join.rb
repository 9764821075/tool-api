class ScreenshotJoin < ApplicationRecord

  soft_deleteable

  belongs_to :screenshotable, polymorphic: true
  belongs_to :screenshot

end

# == Schema Information
#
# Table name: screenshot_joins
#
#  id                  :uuid             not null, primary key
#  deleted             :boolean          default(FALSE)
#  screenshotable_type :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  screenshot_id       :uuid
#  screenshotable_id   :uuid
#
# Indexes
#
#  index_screenshot_joins_on_screenshotable_id_and_type  (screenshotable_id,screenshotable_type)
#
