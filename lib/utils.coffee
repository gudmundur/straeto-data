_ = require 'underscore'

@nullOr = nullOr = (x, fn) -> if x is null then null else fn x

@prefixSum = (l) ->
    t = 0
    (_ l).map (x) -> nullOr x, -> t = t + x

@merge = (arrays) -> [].concat.apply [], arrays

