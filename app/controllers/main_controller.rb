require 'timeout'

class MainController < ApplicationController
  before_filter :authenticate
  before_filter :ensure_admin, :only => [:unlock]

  def index
    # TODO: Show list of delayed jobs and when they'll run.
  end

  def lock
    begin
      if Firewall.lock
        flash[:notice] = 'Firewall has been locked.'
      else
        raise 'Could not lock firewall.'
      end
    rescue => e
      flash[:error] = e.message
    end
    redirect_to :action => :index
  end

  def unlock
    begin
      if Firewall.unlock
        flash[:notice] = 'Firewall has been unlocked.'
      else
        raise 'Could not unlock firewall.'
      end
    rescue => e
      flash[:error] = e.message
    end
    redirect_to :action => :index
  end

  def delayed_unlock
    begin
      Firewall.delayed_unlock
      flash[:notice] = 'Firewall will be unlocked in 1 hour.'
    rescue => e
      flash[:error] = e.message
    end
    redirect_to :action => :index
  end

  def whitelist
    if params[:urls]
      begin
        Firewall.whitelist(params[:urls])
        @urls = ''
        flash[:notice] = 'The new urls will be added in 1 hour.'
      rescue => e
        @urls = params[:urls]
        flash[:error] = e.message
      end
    end
  end
end
