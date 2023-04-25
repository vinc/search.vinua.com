class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def queries_usage
    (100.0 * queries_count / queries_max).to_i
  end

  def queries_max
    50
  end
end
