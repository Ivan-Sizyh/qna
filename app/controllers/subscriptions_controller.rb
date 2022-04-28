class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  expose :subscription, find: ->(id){ Subscription.find(id) },
         build: ->(subscription_params){ current_user.subscriptions.new(subscription_params) }

  def create
    flash.now[:notice] = 'Subscribed!' if subscription.save
  end

  def destroy
    flash.now[:notice] = 'Unsubscribed!' if subscription.destroy
  end

  private

  def subscription_params
    params.permit(:id, :question_id)
  end
end
