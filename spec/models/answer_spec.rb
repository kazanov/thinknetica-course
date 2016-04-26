require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should belong_to :question }
  it { should validate_presence_of :question }

  it { should have_db_index :answer_id }
end
