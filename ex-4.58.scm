(rule (big-shot ?person)
      (and
        (job ?person (?person-division . ?person-title))
        (supervisor ?person ?supervisor-name)
        (not (job ?supervisor-name (?person-division . ?title)))))
