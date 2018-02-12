module Commands
  QUESTIONS_AND_ANSWERS = {
    "hey alfred": nil,
    "turn on the lights": "will do",
    "turn off the lights": "toot suite",
    "play jazz music": "one moment",
    "play disney music": "right away",
    "stop the music": "done",
    "what will the weather be like today": -> { "someone look out the window" },
    "what will the weather be like tomorrow": -> { "we'll just have to wait and see" },
    "what time is it": -> { Time.now.to_s },
    "how old are you": -> { `uptime -p`.strip },
    "what is your name": "alfred bumbottom the third",
    "who is daddy's princess": "adalyn faith",
    "who is the boss": "natalie sue",
  }

  def self.[](key)
    QUESTIONS_AND_ANSWERS[key.to_sym]
  end

  def self.all
    QUESTIONS_AND_ANSWERS
  end

  def self.keyword
    QUESTIONS_AND_ANSWERS.keys.first
  end
end
