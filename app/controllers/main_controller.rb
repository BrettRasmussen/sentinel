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
      groups = []
      timeout(3) { groups = %x{sudo groups brett}.chomp.match(/^.*:(.*)/).to_a[1].split }
      if groups.include?('admin')
        flash[:notice] = 'Firewall has been unlocked.'
      else
        raise 'Failed to grant admin rights.'
      end
    rescue => e
      flash[:error] = "Could not unlock firewall: #{e.message}"
    end
    redirect_to :action => :index
  end

  def lock
    begin
      lock_cmd = Rails.root.join('bin', 'lock')
      timeout(3) { %x{sudo #{lock_cmd}} }
      groups = ['admin']
      timeout(3) { groups = %x{sudo groups brett}.chomp.match(/^.*:(.*)/).to_a[1].split }
      raise 'Failed to revoke admin rights.' if groups.include?('admin')
      flash[:notice] = 'Firewall has been locked.'
    rescue => e
      flash[:error] = "Could not lock firewall: #{e.message}"
    end
    redirect_to :action => :index
  end
end
