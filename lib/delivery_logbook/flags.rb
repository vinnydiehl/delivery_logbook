module DeliveryLogbook
  FLAGS = {
    # Anything less than a dollar is a stiff, good is $5 or more
    s: "Stiff",
    t: "Good Tip",
    # Fuckers that send their kids to the door so they don't have to tip
    # If you do this you deserve to have a thin stream of acid drizzled onto
    # your ballsack
    k: "Kids",
    # Took a long time to come to the door
    l: "Long",
  }

  FLAGS_REGEX, FLAGS_ANY_REGEX = %w[+ *].map { |r| /[#{FLAGS.keys.join}]#{r}/i }
end
