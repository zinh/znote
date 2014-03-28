# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
end
