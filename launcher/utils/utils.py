# encoding=utf-8


def dict_override(s, d):
  if not s:
    return d

  for k in s.keys():
    if k not in d:
      d[k] = s[k]
    elif isinstance(s[k], (tuple, list)):
      d[k] = s[k]
    elif s[k] is None:
      d[k] = s[k]
    elif isinstance(s[k], dict):
      dict_override(s[k], d[k])
    else:
      d[k] = s[k]

  return d