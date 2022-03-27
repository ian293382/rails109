class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :content, presence: true #不留空白

  scope :recent, -> { order{"created_at DESC"}}
end
