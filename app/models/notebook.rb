# == Schema Information
#
# Table name: notebooks
#
#  id          :integer          not null, primary key
#  note_id     :string
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Notebook < ActiveRecord::Base
  has_many :notes
end
