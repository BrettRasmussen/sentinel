class Firewall
  def self.lock
    lock_cmd = Rails.root.join('bin', 'lock')
    timeout(3) { %x{sudo #{lock_cmd}} }
    $?.exitstatus == 0
  end

  def self.unlock
    unlock_cmd = Rails.root.join('bin', 'unlock')
    timeout(3) { %x{sudo #{unlock_cmd}} }
    $?.exitstatus == 0
  end

  def self.delayed_unlock
    Firewall.unlock
  end
  handle_asynchronously :delayed_unlock, :run_at => Proc.new { 1.hour.from_now }

  def self.whitelist(urls)
    urls = urls.split
    path = Rails.root.join('etc', 'squid3', 'acls', 'whitelist.txt')
    existing_urls = File.readlines(path).map(&:chomp)
    new_urls = urls - existing_urls

    new_urls.each do |url|
      raise "Bad url: #{url}" if url !~ /^(\w|\.|\-)+$/
    end

    File.open(path, 'w+') do |f|
      f.puts(new_urls)
    end
  end
  handle_asynchronously :whitelist, :run_at => Proc.new { 1.hour.from_now }
end
