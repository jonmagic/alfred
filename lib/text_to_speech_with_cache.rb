require_relative "./text_to_speech"
require "pathname"

class TextToSpeechWithCache < TextToSpeech
  def initialize
    super

    @root_path = Pathname("#{File.dirname(__FILE__)}/../cache")
  end

  attr_reader :root_path

  def play(text)
    mp3_path = file_path(text)

    if mp3_path.exist?
      `#{play_command} #{mp3_path}`
    else
      super(text)
    end
  end

  def file_path(text)
    root_path.join("#{text.gsub(/\W/, "_")}.mp3")
  end
end
