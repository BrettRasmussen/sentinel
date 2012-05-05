require 'timeout'

class MainController < ApplicationController
  before_filter :authenticate
  before_filter :ensure_admin, :only => [:unlock]

  def index
  end

  def unlock
    begin
      timeout(3) { %x{sudo gpasswd -a brett admin} }
      groups = []
      timeout(3) { groups = %x{sudo groups brett}.chomp.match(/^.*:(.*)/).to_a[1].split }
      if groups.include?('admin')
        flash[:notice] = 'Filter has been unlocked.'
      else
        raise 'Failed to grant admin rights.'
      end
    rescue => e
      flash[:error] = "Could not unlock filter: #{e.message}"
    end
    redirect_to :action => :index
  end

  def lock
    begin
      timeout(3) { %x{sudo gpasswd -d brett admin} }
      groups = ['admin']
      timeout(3) { groups = %x{sudo groups brett}.chomp.match(/^.*:(.*)/).to_a[1].split }
      raise 'Failed to revoke admin rights.' if groups.include?('admin')
      flash[:notice] = 'Filter has been locked.'
    rescue => e
      flash[:error] = "Could not lock filter: #{e.message}"
    end
    redirect_to :action => :index
  end
end
