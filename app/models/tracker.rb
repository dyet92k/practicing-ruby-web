class Tracker

  class << self
    def update_status(user)
      tracker = new(user)
      
      tracker.set(:status => user.status)
    end

    def update_payment_provider(user)
      tracker = new(user)

      if s = user.subscriptions.active
        tracker.set(:payment_provider => s.payment_provider) 
      else
        tracker.set(:payment_provider => nil)
      end
    end
  end

  def initialize(user, params={})
    @user     = user
    @mixpanel = Mixpanel::Tracker.new(MIXPANEL_API_TOKEN, params)
  end

  def track(event, params={})
    if @user.try(:github_nickname)
      params = { :distinct_id => @user.hashed_id }.merge(params)
    end

    @mixpanel.track(event, params)
    @mixpanel.set("$last_seen" => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S"))
  end

  def set(params)
    return unless @user.try(:github_nickname)

    @mixpanel.set(@user.hashed_id, params)
  end
end
