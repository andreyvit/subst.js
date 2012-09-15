# http://xkr.us/js/regexregex
RegExp_escape = (str) -> str.replace(/[\\\^\$*+[\]?{}.=!:(|)]/g, "\\$&")

create = (prefix, suffix) ->
  prefix = RegExp_escape(prefix)
  suffix = RegExp_escape(suffix)

  subst = (value, args) ->
    switch typeof value
      when 'string'
        for own argName, argValue of args
          value = value.replace ///#{prefix}#{RegExp_escape(argName)}#{suffix}///g, argValue
        value
      when 'object'
        if Array.isArray(value)
          result = []
          for item in value
            # when $(something) arg value is an array, occurrences of $(something) in the source array are substituted by splicing
            if (typeof item is 'string') and (argValue = args[item])? and (Array.isArray argValue)
              result.push.apply(result, argValue)
            else
              result.push subst(item, args)
        else if not value?
          result = value
        else if value.constructor is Object
          result = {}
          for own k, v of value
            k = subst(k, args)
            v = subst(v, args)
            result[k] = v
        else
          result = value
        result
      else
        value

  subst.wrap = (p, s) -> create(p, s)

  return subst


module.exports = create('', '')
