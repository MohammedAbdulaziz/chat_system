class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy
  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, on: :update
  validate :number_cannot_be_less_than_one, on: :update

  def as_json(options = {})
    super(options.merge(except: [:id, :application_id]))
  end

  private

  def number_cannot_be_less_than_one
    errors.add(:number, "must be 1 or greater") if number.present? && number < 1
  end
end