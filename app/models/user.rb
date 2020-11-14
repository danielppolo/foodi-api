# frozen_string_literal: true

class User < ActiveRecord::Base
  enum gender: %i[female male]

  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable

  include GraphqlDevise::Concerns::Model

  validates :name,
            presence: true
  validates :nickname,
            presence: true,
            uniqueness: true
  validates :email,
            presence: true,
            uniqueness: true

  has_many :likes, dependent: :destroy
  has_many :meals, through: :likes
  has_one_attached :image

  def to_s
    "#{name} (#{email})"
  end
end
