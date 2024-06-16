class Message < ApplicationRecord
  belongs_to :chat
  include Searchable
  validates :body, presence: true
  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, on: :update
  validate :number_must_be_positive, on: :update

  def as_json(options = {})
    super(options.merge(except: [:id, :chat_id]))
  end

  private

  def number_must_be_positive
    errors.add(:number, "must be 1 or greater") if number.present? && number < 1
  end
end