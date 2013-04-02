require 'timeout'

class MainController < ApplicationController
  before_filter :authenticate
  before_filter :ensure_admin, :only => [:unlock]

  def index
  end

  def unlock
    begin
      unlock_cmd = Rails.root.join('bin', 'unlock')
      timeout(3) { %x{sudo #{unlock_cmd}} }
      if $?.exitstatus == 0
        flash[:notice] = 'Firewall has been unlocked.'
      else
        raise 'Could not unlock firewall.'
      end
    rescue => e
      flash[:error] = e.message
    end
    redirect_to :action => :index
  end

  def lock
    begin
      lock_cmd = Rails.root.join('bin', 'lock')
      timeout(3) { %x{sudo #{lock_cmd}} }
      if $?.exitstatus == 0
        flash[:notice] = 'Firewall has been locked.'
      else
        raise 'Could not lock firewall.'
      end
    rescue => e
      flash[:error] = e.message
    end
    redirect_to :action => :index
  end
end
