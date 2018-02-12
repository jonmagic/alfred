require "minitest/autorun"

describe TextToSpeech do
  it "does something" do
    tts = TextToSpeech.new("hello world")
    tts.play
  end
end
