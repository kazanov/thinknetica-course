require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list(:user, 2) }
  let!(:questions) { create_list(:question, 2, user: users.first, created_at: (Time.now - 1.day)) }

  it 'sends daily digest to each user' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:daily_digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
