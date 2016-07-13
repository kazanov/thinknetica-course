require 'rails_helper'
RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let(:subscription_create) do
      post :create, question_id: question.id, format: :js
    end

    context 'authenticated user' do
      before { sign_in user2 }

      context 'not subscribed' do
        it 'creates new subscription' do
          expect { subscription_create }.to change(Subscription, :count).by 1
        end

        it 'change user and question subscriptions count' do
          expect { subscription_create }.to change(user2.subscriptions, :count).by(1) &&
                                            change(question.subscriptions, :count).by(1)
        end

        it 'add user to question subscribers' do
          subscription_create
          expect(assigns(:question).subscriptions.last.user_id).to match user2.id
        end
      end

      context 'already subscribed' do
        let(:subscription) { create(:subscription, question: question) }
        before { user2.subscriptions << subscription }

        it 'does not create new subscription' do
          expect { subscription_create }.to_not change(Subscription, :count)
        end

        it 'change user and question subscriptions count' do
          expect { subscription_create }.to_not change(user2.subscriptions, :count) &&
                                                change(question.subscriptions, :count)
        end
      end
    end

    context 'non-authenticated user' do
      it 'returns 401' do
        subscription_create
        expect(response).to redirect_to root_path
      end

      it 'does not change subscription count' do
        expect { subscription_create }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user2) }
    let(:subscription_destroy) do
      delete :destroy, id: subscription.id, format: :js
    end

    context 'subscribed authenticated user' do
      before { sign_in user2 }

      it 'change subscriptions count' do
        expect { subscription_destroy }.to change(Subscription, :count).by(-1)
      end

      it 'change user and question subscriptions count' do
        expect { subscription_destroy }.to change(user2.subscriptions, :count).by(-1) &&
                                           change(question.subscriptions, :count).by(-1)
      end
    end

    context 'not subscribed authenticated user' do
      let(:user3) { create(:user) }
      before { sign_in user3 }

      it 'change subscriptions count' do
        expect { subscription_destroy }.to_not change(Subscription, :count)
      end

      it 'change user and question subscriptions count' do
        expect { subscription_destroy }.to_not change(user2.subscriptions, :count) &&
                                               change(question.subscriptions, :count)
      end
    end

    context 'non-authenticated user' do
      it 'returns 401' do
        subscription_destroy
        expect(response).to redirect_to root_path
      end

      it 'does not change subscription count' do
        expect { subscription_destroy }.to_not change(Subscription, :count)
      end
    end
  end
end
