require "open-uri"
require "tempfile"
require "uri"

class TextToSpeech
  def initialize
    @play_command = if RUBY_PLATFORM =~ /darwin/
      "afplay -q 1"
    elsif RUBY_PLATFORM =~ /linux/
      "omxplayer"
    end
  end

  attr_reader :play_command

  def save(text, file_path)
    File.open(file_path, "w+") do |file|
      file.write(text_to_mp3(text))
    end
    true
  end

  def text_to_mp3(text)
    url = "#{GOOGLE_TRANSLATE_URL}?tl=en&ie=UTF-8&client=tw-ob&q=#{URI.escape(text)}"
    open(url, "User-Agent" => USER_AGENT, "Referer" => REFERER).read
  end

  def play(text)
    file = Tempfile.new("play")
    file.write(text_to_mp3(text))
    file.close
    `#{play_command} #{file.path}`
  ensure
    unless file.nil?
      file.close
      file.unlink
    end
  end

  GOOGLE_TRANSLATE_URL = "https://translate.google.com/translate_tts"
  USER_AGENT = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.68 Safari/534.24"
  REFERER = "https://translate.google.com/"
end
