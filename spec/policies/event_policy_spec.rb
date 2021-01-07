require 'rails_helper'

RSpec.describe EventPolicy do
  subject { described_class }

  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  let(:event) { FactoryBot.create(:event, user: user) }
  let(:event_w_pin) { FactoryBot.create(:event, user: user, pincode: '1597') }

  let(:valid_cookies) { { "events_#{event_w_pin.id}_pincode" => '1597' } }

  let(:user_context) { UserContext.new(user, {}) }
  let(:another_user_w_o_private_access_context) { UserContext.new(another_user, {}) }
  let(:guest_ueser_w_private_access_context) { UserContext.new(nil, valid_cookies) }

  context 'User edit, update or destroy event' do
    context 'when user is owner' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.to permit(user_context, event) }
      end
    end

    context 'when user is not owner' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(another_user_w_o_private_access_context, event) }
      end
    end

    context 'when user is not authenticated' do
      permissions :edit?, :update?, :destroy? do
        it { is_expected.not_to permit(guest_ueser_w_private_access_context, event) }
      end
    end
  end

  context 'User look event' do
    context 'when pin code is absent' do
      permissions :show? do
        it { is_expected.to permit(another_user_w_o_private_access_context, event) }
      end
    end

    context 'when pin code is present' do
      context 'and user is owner' do
        permissions :show? do
          it { is_expected.to permit(user_context, event_w_pin) }
        end
      end

      context 'user has valid cookies' do
        permissions :show? do
          it { is_expected.to permit(guest_ueser_w_private_access_context, event_w_pin) }
        end
      end

      context 'user has not valid cookies' do
        permissions :show? do
          it { is_expected.not_to permit(another_user_w_o_private_access_context, event_w_pin) }
        end
      end
    end
  end
end