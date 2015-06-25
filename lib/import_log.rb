class ImportLog
  LOG_PATH = "log/import.log"
  def self.log(string)
    string = "[#{Time.now.strftime("%F %H:%M")}] #{string}\n"
    print string
    File.open(LOG_PATH, 'a') { |file| file << string }
    nil
  end
end
