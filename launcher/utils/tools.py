# encoding=utf-8

import shortuuid
import random

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


# 密码生成方法，最短生成 3 位密码
def gen_password(l, special_chars = "-._~"):
  l = max(l, 3)
  password = shortuuid.ShortUUID().random(length=l - 1)

  if special_chars and len(special_chars) > 0:
    special_char = special_chars[random.randint(0, len(special_chars) - 1)]

    pos = random.randint(1, l - 2)
    return password[0: pos] + special_char + password[pos: len(password)]

  return password