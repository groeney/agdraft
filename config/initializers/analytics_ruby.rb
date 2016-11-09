require "segment/analytics"

Analytics = Segment::Analytics.new({
    write_key: "PSswEtCGRU2q2f4xhdLEv701DdvfK2TA",
    on_error: Proc.new { |status, msg| print msg }
})