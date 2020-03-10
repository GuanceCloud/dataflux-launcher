# Python 2.x/3.x AES-245-CBC
import binascii
import six
try:
    from Cryptodome.Cipher import AES
except ImportError:
    from Crypto.Cipher import AES

def _pad_length(text, length):
    text = six.ensure_binary(text)

    count = len(text)
    add_count = length - (count % length)
    text += six.ensure_binary(' ' * add_count)
    return text

def cipher_by_aes(text, key):
    text = six.ensure_binary(text)
    key  = six.ensure_binary(key)

    text = _pad_length(text, 16)
    key = _pad_length(key, 32)[:32] # 只取前32位

    c = AES.new(key, AES.MODE_CBC, six.ensure_binary('\0' * 16))
    bin_data = c.encrypt(text)
    data = binascii.b2a_base64(bin_data)

    return data.strip()

def decipher_by_aes(data, key):
    key = six.ensure_binary(key)

    key = _pad_length(key, 32)[:32] # 只取前32位

    c = AES.new(key, AES.MODE_CBC, six.ensure_binary('\0' * 16))
    bin_data = binascii.a2b_base64(data)
    text = c.decrypt(bin_data)

    return six.ensure_str(text).strip()

if __name__ == '__main__':
    test_case = [
        {'raw': 'a', 'key': 'a'},
        {'raw': '01234567890abcde', 'key': '01234567890abcde01234567890abcde'},
        {'raw': '01234567890abcde01234567890abcde', 'key': '01234567890abcde'},
    ]

    for t in test_case:
        raw = t['raw']
        key = t['key']
        ciphered = cipher_by_aes(raw, key)
        deciphered = decipher_by_aes(ciphered, key)
        print('AES("{}", "{}") = "{}" => "{}"'.format(raw, key, ciphered, deciphered))
        assert raw == deciphered
