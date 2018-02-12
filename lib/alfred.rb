require "logger"
require "pocketsphinx-ruby"
require_relative "./commands"
require_relative "./text_to_speech_with_cache"

class Alfred
  def initialize
    @configuration = Pocketsphinx::Configuration::Grammar.new do
      Commands.all.keys.each do |command|
        sentence command
      end
    end
    @logger = Logger.new(STDOUT)
    @tts = TextToSpeechWithCache.new
  end

  attr_reader :configuration
  attr_reader :logger
  attr_reader :tts
  attr_accessor :last_active_command_timestamp

  def call
    Pocketsphinx::LiveSpeechRecognizer.new(configuration).recognize do |speech|
      begin
        phrase = speech.to_sym

        if phrase == Commands.keyword
          self.last_active_command_timestamp = Time.now
          logger.info "recognized keyword"
        elsif last_active_command_timestamp && last_active_command_timestamp > Time.now - 5
          if response = Commands[phrase]
            if response.respond_to?(:call)
              response = response.call
            end

            logger.info response
            tts.play(response)
            self.last_active_command_timestamp = Time.now
          else
            logger.info "unknown command: #{phrase}"
          end
        end
      rescue => error
        logger.debug error
      end
    end
  end
end
