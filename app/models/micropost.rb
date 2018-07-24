class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.maximum_content}
  validate  :picture_size

  scope :feed_user, ->(id){where user_id: id}
  scope :user_create, ->{order(created_at: :desc)}
  scope :feed_for, ->(user_id, following_ids){where(user_id: [user_id, *following_ids])}

  private

  def picture_size
    return unless picture.size > Settings.picture.size.megabytes
    errors.add(:picture, t("picture.pic_size"))
  end
end
