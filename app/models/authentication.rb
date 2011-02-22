# == Schema Information
# Schema version: 20110218135916
#
# Table name: authentications
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid
  
  belongs_to :user
  
  validates :user_id,   :presence => true
  validates :provider,  :presence => true, :uniqueness => {:scope => :user_id}
  validates :uid,       :presence => true, :uniqueness => {:scope => :provider}
  
end
