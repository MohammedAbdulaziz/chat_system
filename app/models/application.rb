class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  before_create :generate_token
  validates :name, presence: true

  def as_json(options = {})
    super(options.merge(except: [:id]))
  end

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end