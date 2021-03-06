require 'test_helper'
require 'models/confirmable_test'

class ConfirmableTest < ActiveSupport::TestCase
  def teardown
    Timecop.return
  end

  # User#confirmation_sent_at is of DateTime type, user.confirmation_sent_at = Time.zone.today gives error.
  undef :test_should_be_active_when_we_set_allow_unconfirmed_access_for_to_nil
  test 'should be active when we set allow_unconfirmed_access_for to nil' do
    swap Devise, allow_unconfirmed_access_for: nil do
      user = create_user
      user.confirmation_sent_at = Time.now
      assert user.active_for_authentication?
    end
  end

  undef :test_should_not_be_active_when_confirm_in_is_zero
  test 'should not be active when confirm in is zero' do
    Devise.allow_unconfirmed_access_for = 0.days
    user = create_user
    user.confirmation_sent_at = Time.now
    refute user.active_for_authentication?
  end

  undef :test_should_not_be_active_when_confirm_period_is_set_to_0_days
  test 'should not be active when confirm period is set to 0 days' do
    Devise.allow_unconfirmed_access_for = 0.days
    user = create_user

    Timecop.freeze(Time.zone.today) do
      user.confirmation_sent_at = Time.now
      refute user.active_for_authentication?
    end
  end
end
