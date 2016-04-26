require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

<<<<<<< HEAD
  it { should belong_to :question }
  it { should validate_presence_of :question }
=======
  it { should belong_to(:question).dependent(:destroy) }
>>>>>>> 62eb033b7ab98121a634f18a63c175b08b260bcb

  it { should have_db_index :answer_id }
end
