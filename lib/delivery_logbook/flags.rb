module DeliveryLogbook
  FLAGS = {
    # Anything less than a dollar is a stiff, good is $5 or more
    s: "Stiff",
    t: "Good Tip",

    # At the door by the time I got to it
    p: "Prompt",
    # Took a long time to come to the door
    l: "Long",

    # Kids can order from any address and tend not to tip so flag them
    k: "Kids"
  }

  FLAGS_REGEX, FLAGS_ANY_REGEX = %w[+ *].map { |r| /[#{FLAGS.keys.join}]#{r}/i }
end
